import 'package:flutter/material.dart';
import 'MedicineDetails.dart';

class MedicineCard extends StatelessWidget {
  final String name;
  MedicineCard({this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image(image: AssetImage('lib/assets/remedio.png'),height: 45, width: 45, ),
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