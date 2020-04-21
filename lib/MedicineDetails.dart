import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_html/flutter_html.dart';

Future<Medicine> fetchMedicineResume({String name}) async {
  final response = await http.get(
      'https://pt.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles=$name');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Medicine.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load wikipedia request');
  }
}

class Medicine {
  final String summary;

  Medicine({this.summary});

  factory Medicine.fromJson(Map<String, dynamic> json) {
    var query = json['query']['pages']['1507481'];
    print("Json " + query['extract'].toString());
    return Medicine(
      summary: query['extract'],
    );
  }
}

class MedicineDetails extends StatefulWidget {
  final name;

  MedicineDetails({this.name});

  @override
  _MedicineDetailsState createState() => _MedicineDetailsState(name: name);
}

class _MedicineDetailsState extends State<MedicineDetails> {
  Future<Medicine> futureMedicine;
  final String name;
  String summary = " ";

  _MedicineDetailsState({this.name});

  @override
  void initState() {
    super.initState();
    futureMedicine = fetchMedicineResume(name: name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Medicine Details - $name"),
        ),
        body: FutureBuilder<Medicine>(
          future: futureMedicine,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("Foi - ${snapshot.data.summary}");
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Html(
                      data: "<div style='text-align: justify;'>" + snapshot.data.summary.toString() + "</div>",
                      padding: EdgeInsets.all(16),
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              print("N Foi");
              return Text("Erro");
            }

            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
