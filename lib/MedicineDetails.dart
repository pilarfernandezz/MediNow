import 'dart:io';

import 'package:camera/camera.dart';
import 'package:day_selector/day_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Medicine.dart';

import 'MedicineHttpRequest.dart';
import 'Photo.dart';

class MedicineDetails extends StatefulWidget {
  final Medicine drug;

  MedicineDetails({this.drug});

  @override
  _MedicineDetailsState createState() => _MedicineDetailsState(drug: drug);
}

class _MedicineDetailsState extends State<MedicineDetails> {
  Medicine drug;
  TimeOfDay timeNow;
  String hourConcat = "";
  bool editMode = false;

  _MedicineDetailsState({this.drug});

  @override
  void initState() {
    timeNow = TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${drug.name}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(editIcon()),
            onPressed: () {
              print("pressed");
              setState(() {
                editMode = !editMode;
              });
            },
          )
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(10.0),
        crossAxisCount: 2,
        children: <Widget>[
          GestureDetector(
            child: createBox(Text("Nome do Remédio:\n"+drug.name,)),
            onTap: (editMode) ? _dialogName : null,
          ),
          GestureDetector(
            child: createBox(Text("Quantidade do Remédio:\n"+drug.drugAmmount.toString())),
            onTap: (editMode) ? _dialogAmmount : null,
          ),
          GestureDetector(
            child: createBox(Text(getDays(drug.daysSelected))),
            onTap: (editMode) ? _dialogDays : null,
          ),
          GestureDetector(
            child: createBox(Text("Horas do Remédio:\n"+concatHoursList(drug.hoursSelected))),
            onTap: (editMode) ? _dialogHours : null,
          ),
          GestureDetector(
            child: createBox(Text("Mais informações")),
            onTap: (editMode) ? null : _goToHttp,
          ),
          GestureDetector(
            child: createBox(CircleAvatar(backgroundImage: getImage(), maxRadius: 85,)),
            onTap: (editMode) ? getPhoto : null,
          )
        ],
      ),
    );
  }

  String getDays(int value) {
    String days = "Dias da Semana:\n";

    if (DaySelector.monday & value == DaySelector.monday) {
      days += ('Segunda\n');
    }
    if (DaySelector.tuesday & value == DaySelector.tuesday) {
      days += ('Terça\n');
    }
    if (DaySelector.wednesday & value == DaySelector.wednesday) {
      days += ('Quarta\n');
    }
    if (DaySelector.thursday & value == DaySelector.thursday) {
      days += ('Quinta\n');
    }
    if (DaySelector.friday & value == DaySelector.friday) {
      days += ('Sexta\n');
    }
    if (DaySelector.saturday & value == DaySelector.saturday) {
      days += ('Sábado\n');
    }
    if (DaySelector.sunday & value == DaySelector.sunday) {
      days += ('Domingo\n');
    }

    return days;
  }

  String concatHoursList(List<String> list) {
    var concatenate = StringBuffer();

    for (int i = 0; i < list.length; i++) {
      concatenate.write(list[i]);

      if (i != (list.length - 1)) concatenate.write("; ");
    }

    if (concatenate.toString() != "")
      return concatenate.toString();
    else
      return "Nenhum horário definido";
  }

  Widget createBox(Widget widget) {
    return Container(
        child: Center(
          child: widget,
        ),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).focusColor,
                blurRadius: 5.0,
                spreadRadius: 5.0,
                offset: Offset(
                  5.0,
                  5.0,
                ),
              )
            ],
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(50)));
  }

  void _dialogName() {
    var dialog = Dialog(
      child: Container(
        width: 320,
        height: 50,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Center(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    drug.name = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Entre o nome do remédio',
                ),
              ),
            ),
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  void _dialogAmmount() {
    var dialog = Dialog(
      child: Container(
        width: 300,
        height: 50,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Center(
                child: TextField(
              onChanged: (value) {
                setState(() {
                  drug.drugAmmount = int.parse(value);
                });
              },
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration:
                  InputDecoration(hintText: 'Entre a quantidade de remédio'),
            )),
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  void _dialogDays() {
    var dialog = Dialog(
      child: Container(
        width: 300,
        height: 50,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Center(
                child: Container(
              width: 300,
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  DaySelector(
                    onChange: (value) {
                      setState(() {
                        drug.daysSelected = value;
                      });
                    },
                    mode: DaySelector.modeFull,
                    value: drug.daysSelected,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  void _dialogHours() {
    var dialog = Dialog(
      child: Container(
        width: 320,
        height: 60,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Center(
              child: ListTile(
                leading: GestureDetector(
                  child: Icon(Icons.remove_circle),
                  onTap: _removeTime,
                ),
                title: Text(concatHoursList(drug.hoursSelected)),
                trailing: GestureDetector(
                    child: Icon(Icons.add_circle), onTap: _pickTime),
              ),
            ),
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: timeNow);

    if (t != null) {
      setState(() {
        var minuto = (t.minute < 10) ? "0${t.minute}" : "${t.minute}";
        drug.hoursSelected.add("${t.hour}:$minuto");
      });
    }
  }

  _removeTime() {
    setState(() {
      drug.hoursSelected.removeAt(drug.hoursSelected.length - 1);
    });
  }

  void _goToHttp() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MedicineHttpRequest(name: drug.name)),
    );
  }

  ImageProvider<dynamic> getImage(){
    if(drug.image != null)
      return drug.image.image;
    else
      return AssetImage('lib/assets/remedio.png');
  }

  getPhoto() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Photo(camera: firstCamera)),
    );
    if (result != null) {
      setState(() {
        drug.image = Image.file(File(result));
      });
    }
  }

  IconData editIcon() {
    return (editMode) ? Icons.lock : Icons.edit;
  }
}
