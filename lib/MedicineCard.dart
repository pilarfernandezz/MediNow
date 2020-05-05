import 'package:flutter/material.dart';
import 'MedicineDetails.dart';
import 'Medicine.dart';

class MedicineCard extends StatelessWidget {
  final Medicine drug;
  MedicineCard({this.drug});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image(image: AssetImage('lib/assets/remedio.png'),height: 45, width: 45, ),
        title: Text(drug.name),
        trailing: Icon(Icons.keyboard_arrow_right),
        selected: false,
        onTap: () {
          Navigator.push(
            context,
             MaterialPageRoute(builder: (context) => MedicineDetails(drug: drug) ));
        }
      ),
    );
  }
}