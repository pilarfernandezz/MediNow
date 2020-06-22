import 'dart:async';
import 'dart:io';

import 'package:day_selector/day_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trabalho_1/MedicineDetails.dart';
import 'Medicine.dart';
import 'AppStateNotifier.dart';
import 'MedicineCreator.dart';
import 'MedicineCard.dart';
import 'Map.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
        child: MyApp(), create: (BuildContext context) => AppStateNotifier()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(builder: (context, appState, child) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: MyHomePage(title: 'MediNow'),
        themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget cardsList;
  int _counter = 0;
  List<Medicine> drugsList = List<Medicine>();
  bool dark = false;
  Timer timer;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String drugNotificationName = "";

  Widget cardTemplate(medicamento) {
    return MedicineCard(drug: medicamento);
  }

  @override
  void initState() {
    initNotification();
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _isDrugTime());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Map()));
            },
          )
        ],
        title: GestureDetector(
            onDoubleTap: () {
              print("Double Tap!");
              dark = (dark) ? false : true;
              print("dark mode: $dark");
              Provider.of<AppStateNotifier>(context, listen: false)
                  .updateTheme(dark);
            },
            child: Text(widget.title)),
      ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: getList()),
              GestureDetector(
                onLongPress: () => showNotificationNoDrug(),
                child: Text(
                  (_counter < 2) ? '$_counter Remédio' : '$_counter Remédios',
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () {
              createNewCard(context);
            },
            tooltip: 'Criar novo remédio',
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }

  void createNewCard(BuildContext context) {
    _createNewCardCreator().then((Medicine result) {
      var medicineValue = result;
      if (result == null) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Criação cancelada!")));
      } else {
        setState(() {
          _counter++;
          drugsList.add(medicineValue);
        });
      }
    });
  }

  Widget getList() {
    if (_counter == 0) {
      return Center(
        child: Text('Nenhum medicamento registrado',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.grey)),
      );
    } else {
      setState(() {
        cardsList = ListView(
          children: drugsList.map((item) => cardTemplate(item)).toList(),
        );
      });
      return cardsList;
    }
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      getList();
    });
    return null;
  }

  Future<Medicine> _createNewCardCreator() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MedicineCreator()),
    );
    if (result == null)
      return null;
    else {
      print("Temos remedio");
      return result;
    }
  }

  _isDrugTime() {
    DateTime time = DateTime.now();
    List<Medicine> drugNotificationList = List<Medicine>();
    for (Medicine drug in drugsList) {
      for (String subscribedTime in drug.hoursSelected) {
        var splitedTime = subscribedTime.split(":");
        int hour = int.parse(splitedTime.elementAt(0));
        int minute = int.parse(splitedTime.elementAt(1));

        if (time.hour == hour && time.minute == minute) {
          print("hora certa");

          if (DaySelector.monday & drug.daysSelected == DaySelector.monday) {
            print('monday selected');
            if (time.weekday == DateTime.monday) {
              drugNotificationList.add(drug);
            }
          }
          if (DaySelector.tuesday & drug.daysSelected == DaySelector.tuesday) {
            print('tuesday selected');
            if (time.weekday == DateTime.tuesday) {
              drugNotificationList.add(drug);
            }
          }
          if (DaySelector.wednesday & drug.daysSelected ==
              DaySelector.wednesday) {
            print('wednesday selected');
            if (time.weekday == DateTime.wednesday) {
              drugNotificationList.add(drug);
            }
          }
          if (DaySelector.thursday & drug.daysSelected ==
              DaySelector.thursday) {
            print('thursday selected');
            if (time.weekday == DateTime.thursday) {
              drugNotificationList.add(drug);
            }
          }
          if (DaySelector.friday & drug.daysSelected == DaySelector.friday) {
            print('friday selected');
            if (time.weekday == DateTime.friday) {
              drugNotificationList.add(drug);
            }
          }
          if (DaySelector.saturday & drug.daysSelected ==
              DaySelector.saturday) {
            print('saturday selected');
            if (time.weekday == DateTime.saturday) {
              drugNotificationList.add(drug);
            }
          }
          if (DaySelector.sunday & drug.daysSelected == DaySelector.sunday) {
            print('sunday selected');
            if (time.weekday == DateTime.sunday) {
              drugNotificationList.add(drug);
            }
          }
        }
      }
    }

    while (drugNotificationList.length > 0) {
      var currentDrug = drugNotificationList.removeAt(0);
      setState(() {
        drugNotificationName = currentDrug.name;
      });
      drugTime(currentDrug);
      sleep(Duration(seconds: 5));
    }
  }

  void drugTime(Medicine drug) {
    setState(() {
      if (drug.drugAmmount > 0) {
        showNotification();
        drug.drugAmmount--;
      } else {
        showNotificationNoDrug();
      }
    });
  }

  initNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(initializationSettingsAndroid, null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    for (Medicine drug in drugsList) {
      if (drug.name == payload) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MedicineDetails(drug: drug)),
        );
        break;
      }
    }
  }

  showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0,
        'Tomar remédio $drugNotificationName', null, platformChannelSpecifics,
        payload: '$drugNotificationName');
  }

  showNotificationNoDrug() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Acabou o remédio: $drugNotificationName.',
        'Estava na hora de tomá-lo.',
        platformChannelSpecifics,
        payload: '$drugNotificationName');
  }
}
