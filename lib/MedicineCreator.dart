import 'package:flutter/material.dart';
import 'package:day_selector/day_selector.dart';

import 'main.dart';

class MedicineCreator extends StatefulWidget {

  MedicineCreator();

  @override
  _MedicineCreatorState createState() => _MedicineCreatorState();
}

class _MedicineCreatorState extends State<MedicineCreator> {
  String name = " ";
  int drugAmmount = 0;
  int daysSelected = 0;
  List<String> hoursSelected = new List();
  TimeOfDay timeNow;

  @override
  void initState() {
    timeNow = TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicione novo medicamento"),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 10, color: Colors.white),
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Nome: ",
            ),
            TextField(
              onChanged: (value) {
                name = value;
              },
              decoration: InputDecoration(
                hintText: 'Entre o nome do remédio',
              ),
            ),
            Padding(padding: EdgeInsets.all(12)),
            Text("Dias de uso: "),
            Padding(padding: EdgeInsets.all(8)),
            DaySelector(
              onChange: (value) {
                print('value is $value');
                if (DaySelector.monday & value == DaySelector.monday) {
                  print('monday selected');
                }
                if (DaySelector.tuesday & value == DaySelector.tuesday) {
                  print('tuesday selected');
                }
                if (DaySelector.wednesday & value == DaySelector.wednesday) {
                  print('wednesday selected');
                }
                if (DaySelector.thursday & value == DaySelector.thursday) {
                  print('thursday selected');
                }
                if (DaySelector.friday & value == DaySelector.friday) {
                  print('friday selected');
                }
                if (DaySelector.saturday & value == DaySelector.saturday) {
                  print('saturday selected');
                }
                if (DaySelector.sunday & value == DaySelector.sunday) {
                  print('sunday selected');
                }
                daysSelected = value;
              },
              mode: DaySelector.modeFull,
            ),
            Padding(padding: EdgeInsets.all(12)),
            Text("Quantidade disponível: "),
            TextField(
              onChanged: (value) {
                drugAmmount = value as int;
              },
              decoration: InputDecoration(
                  hintText: 'Entre a quantiade de remédio disponível'),
            ),
            Padding(padding: EdgeInsets.all(12)),
            Text("Entre os horários do remédio:"),
            Padding(padding: EdgeInsets.all(8)),
            ListTile(
              title: Text(concatHoursList(hoursSelected)),
              trailing: Icon(Icons.add_circle),
              onTap: _pickTime,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveMedicine,
        tooltip: 'Salvar',
        child: Icon(Icons.save),
      ),
    );
  }

  String concatHoursList(List<String> list) {
    var concatenate = StringBuffer();

    for (int i = 0; i < list.length; i++){
      concatenate.write(list[i]);

      if (i != (list.length-1))
        concatenate.write("; ");
    }

    print(concatenate); // displays 'onetwothree'

    if (concatenate.toString() != "")
      return concatenate.toString();
    else
      return "Nenhum horário definido";
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: timeNow);

    if (t != null) {
      setState(() {
        hoursSelected.add("${t.hour}:${t.minute}");
      });
    }
  }

  _saveMedicine(){
    Medicine med = Medicine(
        name: name,
        drugAmmount: drugAmmount,
        daysSelected: daysSelected,
        hoursSelected: hoursSelected);
    Navigator.pop(context, med);
  }
}
