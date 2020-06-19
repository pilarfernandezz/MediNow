import 'dart:async';

import 'package:day_selector/day_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  int _counter = 0;
  List<Medicine> cardsList = List<Medicine>();
  bool dark = false;
  Timer timer;

  Widget cardTemplate(medicamento) {
    return MedicineCard(drug: medicamento);
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _isDrugTime());
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: getList()),
            Text(
              (_counter < 2) ? '$_counter Remédio' : '$_counter Remédios',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () {
              createNewCard(context);
            },
            tooltip: 'Increment',
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
          cardsList.add(medicineValue);
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
      return ListView(
        children: cardsList.map((item) => cardTemplate(item)).toList(),
      );
    }
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
    for (Medicine drug in cardsList) {
      for (String subscribedTime in drug.hoursSelected) {
        var splitedTime = subscribedTime.split(":");
        int hour = int.parse(splitedTime.elementAt(0));
        int minute = int.parse(splitedTime.elementAt(1));
        if (time.hour == hour && time.minute == minute) {
          print("hora certa");
          if (DaySelector.monday & drug.daysSelected == DaySelector.monday) {
            print('monday selected');
            if (time.weekday == DateTime.monday) {
              print("Tomar remédio: ${drug.name}");
              setState(() {
                if (drug.drugAmmount > 0) {
                  drug.drugAmmount--;
                } else {
                  print("Acabou o remédio: ${drug.name}");
                }
              });
            }
          }
          if (DaySelector.tuesday & drug.daysSelected == DaySelector.tuesday) {
            print('tuesday selected');
            if (time.weekday == DateTime.tuesday) {
              print("Tomar remédio: ${drug.name}");
              setState(() {
                if (drug.drugAmmount > 0) {
                  drug.drugAmmount--;
                } else {
                  print("Acabou o remédio: ${drug.name}");
                }
              });
            }
          }
          if (DaySelector.wednesday & drug.daysSelected ==
              DaySelector.wednesday) {
            print('wednesday selected');
            if (time.weekday == DateTime.wednesday) {
              print("Tomar remédio: ${drug.name}");
              setState(() {
                if (drug.drugAmmount > 0) {
                  drug.drugAmmount--;
                } else {
                  print("Acabou o remédio: ${drug.name}");
                }
              });
            }
          }
          if (DaySelector.thursday & drug.daysSelected ==
              DaySelector.thursday) {
            print('thursday selected');
            if (time.weekday == DateTime.thursday) {
              print("Tomar remédio: ${drug.name}");
              setState(() {
                if (drug.drugAmmount > 0) {
                  drug.drugAmmount--;
                } else {
                  print("Acabou o remédio: ${drug.name}");
                }
              });
            }
          }
          if (DaySelector.friday & drug.daysSelected == DaySelector.friday) {
            print('friday selected');
            if (time.weekday == DateTime.friday) {
              print("Tomar remédio: ${drug.name}");
              setState(() {
                if (drug.drugAmmount > 0) {
                  drug.drugAmmount--;
                } else {
                  print("Acabou o remédio: ${drug.name}");
                }
              });
            }
          }
          if (DaySelector.saturday & drug.daysSelected ==
              DaySelector.saturday) {
            print('saturday selected');
            if (time.weekday == DateTime.saturday) {
              print("Tomar remédio: ${drug.name}");
              setState(() {
                if (drug.drugAmmount > 0) {
                  drug.drugAmmount--;
                } else {
                  print("Acabou o remédio: ${drug.name}");
                }
              });
            }
          }
          if (DaySelector.sunday & drug.daysSelected == DaySelector.sunday) {
            print('sunday selected');
            if (time.weekday == DateTime.sunday) {
              print("Tomar remédio: ${drug.name}");
              setState(() {
                if (drug.drugAmmount > 0) {
                  drug.drugAmmount--;
                } else {
                  print("Acabou o remédio: ${drug.name}");
                }
              });
            }
          }
        }
      }
    }
  }
}
