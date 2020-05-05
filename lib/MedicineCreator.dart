import 'package:flutter/material.dart';
import 'package:day_selector/day_selector.dart';
import 'package:flutter/services.dart';

import 'Medicine.dart';

class MedicineCreator extends StatefulWidget {
  MedicineCreator();

  @override
  _MedicineCreatorState createState() => _MedicineCreatorState();
}

class _MedicineCreatorState extends State<MedicineCreator> {
  String name = "";
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
      body: ListView(
        padding: const EdgeInsets.all(10.0),
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
            Text("Entre os horários do remédio:"),
            Padding(padding: EdgeInsets.all(8)),
            ListTile(
              leading: GestureDetector(
      child: Icon(Icons.remove_circle),
      onTap: _removeTime,
              ),
              title: Text(concatHoursList(hoursSelected)),
              trailing: GestureDetector(
        child: Icon(Icons.add_circle), onTap: _pickTime),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Text("Quantidade disponível: "),
            TextField(
              onChanged: (value) {
      drugAmmount = int.parse(value);
              },
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
      WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
        hintText: 'Entre a quantiade de remédio disponível'),
            ),
            Padding(padding: EdgeInsets.all(12)),
            Text("Dias de uso: "),
            Padding(padding: EdgeInsets.all(8)),
            DaySelector(
              onChange: (value) {
      daysSelected = value;
              },
              mode: DaySelector.modeFull,
            )
          ],
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

    for (int i = 0; i < list.length; i++) {
      concatenate.write(list[i]);

      if (i != (list.length - 1)) concatenate.write("; ");
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
        var minuto = (t.minute < 10) ? "0${t.minute}" : "${t.minute}";
        hoursSelected.add("${t.hour}:$minuto");
      });
    }
  }

  _removeTime() {
    setState(() {
      hoursSelected.removeAt(hoursSelected.length - 1);
    });
  }

  _saveMedicine() {
    String erro = "";

    if (name == "") {
      erro += "- Sem Nome. Digite um nome\n";
    }
    if (drugAmmount == 0) {
      erro += "- Sem quantidade de remédios. Digite um valor\n";
    }
    if (daysSelected == 0) {
      erro += "- Sem dias selecionados. Selecione pelo menos um dia\n";
    }
    if (hoursSelected.length == 0) {
      erro += "- Sem horários definidos. Selecione pelo menos um horário\n";
    }

    print(erro);

    if (erro == "") {
      Medicine med = Medicine(
          name: name,
          drugAmmount: drugAmmount,
          daysSelected: daysSelected,
          hoursSelected: hoursSelected);
      Navigator.pop(context, med);
    } else {
      var okBtn = FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK"));
      var dialog = Center(
        child: Container(
        width: 320,
        height: 420,
        child: AlertDialog(
        title: Text("Campos não preenchidos"),
        content: Center(child: Text(erro)),
        actions: <Widget>[
          okBtn
        ],
      ))
      );

      showDialog(context: context, builder: (BuildContext context) => dialog);
    }
  }
}
