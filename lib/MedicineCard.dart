import 'package:flutter/material.dart';

class MedicineCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MedicineCardState();
  }
}

class MedicineCardState extends State<MedicineCard> {
  Widget get medicineCard {
    return new Card(
      child: ListTile(
        leading: FlutterLogo(),
        title: Text('One-line with both widgets'),
        trailing: Icon(Icons.keyboard_arrow_right),
        selected: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(child: medicineCard);
  }
}
