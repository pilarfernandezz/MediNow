import 'package:flutter/material.dart';
import 'package:trabalho_1/MedicineDetails.dart';

class MedicineCard extends StatelessWidget {
  final String name;
  MedicineCard({this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(),
        title: Text(name),
        trailing: Icon(Icons.keyboard_arrow_right),
        selected: false,
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => MedicineDetails(name: name)),
          );
        }
      ),
    );
  }
}