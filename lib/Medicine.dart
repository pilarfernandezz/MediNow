import 'package:flutter/material.dart';

class Medicine {
  String name;
  int drugAmmount;
  int daysSelected;
  Image image;
  List<String> hoursSelected;

  Medicine(
      {this.name,
      this.drugAmmount,
      this.daysSelected,
      this.image,
      this.hoursSelected});
}
