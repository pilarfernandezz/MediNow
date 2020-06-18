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
        leading: CircleAvatar(backgroundImage: getImage() ),
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

  ImageProvider<dynamic> getImage(){
    if(drug.image != null)
      return drug.image.image;
    else
      return AssetImage('lib/assets/remedio.png');
  }
}