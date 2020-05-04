import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppStateNotifier.dart';
import 'MedicineCreator.dart';
import 'MedicineCard.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      child: MyApp(), 
      create: (BuildContext context) =>
         AppStateNotifier()
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: MyHomePage(title: 'MediNow'),
      themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<String> cardsList = List<String>();
  bool dark = false;

  void _createNewCard() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      _createNewCardDetails().then((String result) {
        setState(() {
          var medicineName = result;
          if (result == null) {
            //TODO  Scaffold não existe nesse contexto
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Criação cancelada!")));
          } else {
            _counter++;
            cardsList.add(medicineName.toString());
          }
        });
      });
    });
  }

  Widget cardTemplate(medicamento) {
    return MedicineCard(name: medicamento);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: GestureDetector(
          onDoubleTap: (){
            print("Double Tap!");
                  dark = (dark) ? false: true;
                  print("dark mode: $dark");
                  Provider.of<AppStateNotifier>(context, listen: false).updateTheme(dark);
          },
          child: Text(widget.title)),
        // actions: <Widget>[
        //   Switch(
        //       value: Provider.of<AppStateNotifier>(context).isDarkMode,
        //       onChanged: (boolVal) {
        //         Provider.of<AppStateNotifier>(context, listen: false).updateTheme(boolVal);
        //       },
        //     )
        // ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: getList()),
            Text(
              '$_counter Remédios',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewCard,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
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

  Future<String> _createNewCardDetails() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MedicineCreator()),
    );
    if (result == null)
      return null;
    else {
      print("Temos remedio");
      return result.name;
    }
  }
}

class Medicine {
  String name;
  int drugAmmount;
  int daysSelected;
  List<String> hoursSelected;

  Medicine(
      {this.name, this.drugAmmount, this.daysSelected, this.hoursSelected});
}
