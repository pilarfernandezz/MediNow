import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_html/flutter_html.dart';

Future<MedicineJson> fetchMedicineResume({String name}) async {
  final response = await http.get(
      'https://pt.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles=$name');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return MedicineJson.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load wikipedia request');
  }
}

class MedicineJson {
  final String summary;

  MedicineJson({this.summary});

  factory MedicineJson.fromJson(Map<String, dynamic> json) {
    var query = json['query']['pages']['1507481'];
    // print("Json " + query['extract'].toString());
    return MedicineJson(
      summary: query['extract'],
    );
  }
}

class MedicineHttpRequest extends StatefulWidget {
  final name;

  MedicineHttpRequest({this.name});

  @override
  _MedicineHttpRequestState createState() =>
      _MedicineHttpRequestState(name: name);
}

class _MedicineHttpRequestState extends State<MedicineHttpRequest> {
  Future<MedicineJson> futureMedicine;
  final String name;
  String summary = " ";

  _MedicineHttpRequestState({this.name});

  @override
  void initState() {
    super.initState();
    futureMedicine = fetchMedicineResume(name: name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Infos - $name"),
        ),
        body: FutureBuilder<MedicineJson>(
          future: futureMedicine,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print("Foi - ${snapshot.data.summary}");
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Html(
                      data: "<div style='text-align: justify;'>" +
                          snapshot.data.summary.toString() +
                          "</div>",
                      padding: EdgeInsets.all(16),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      defaultTextStyle: DefaultTextStyle.of(context).style,
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text("Não encontrado");
            }

            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
