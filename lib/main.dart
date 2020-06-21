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
  Widget list;

  int _counter = 0;
  List<Medicine> cardsList = List<Medicine>();
  bool dark = false;

  Widget cardTemplate(medicamento) {
    return MedicineCard(drug: medicamento);
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      getList();
    });
    return null;
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
        onRefresh: refreshList,
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
    _createNewCardDetails().then((Medicine result) {
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
      setState(() {
        list = ListView(
          children: cardsList.map((item) => cardTemplate(item)).toList(),
        );
      });
      return list;
    }
  }

  Future<Medicine> _createNewCardDetails() async {
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
}
