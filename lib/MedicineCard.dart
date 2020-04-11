import 'package:flutter/material.dart';

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
      ),
    );
  }
}