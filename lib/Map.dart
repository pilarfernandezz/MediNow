import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:permission_handler/permission_handler.dart';

class Map extends StatefulWidget {
  Map();

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController mapController;

  // final LatLng _center = const LatLng(45.521563, -122.677433);
  Position position;
  List<Marker> markers;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    getPosition().then((Position pos) {
      setState(() {
        position = pos;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Mapa de farmácias")),
        body: FutureBuilder<Position>(
          future: getPosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (markers == null){
              getPlacesResponse(snapshot.data.latitude, snapshot.data.longitude)
                  .then((List<Marker> mk) {
                setState(() {
                  markers = mk;
                });
              });
              }
             else {
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(markers),
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(snapshot.data.latitude, snapshot.data.longitude),
                    zoom: 15.0,
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Text("Local não encontrado");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ));
  }

  Future<List<Marker>> getPlacesResponse(double lat, double long) async {
    getLocationPermission();
    final places =
        GoogleMapsPlaces(apiKey: 'AIzaSyDHhS694bLQPiYxEx6ipftDE6mebyK6RyM');
    PlacesAutocompleteResponse response;
    List<Prediction> predList = List<Prediction>();
    List<LatLng> predLatLongList = List<LatLng>();
    for (String val in ["farmácia", "drogaria"]) {
      response = await places.autocomplete(val,
          location: Location(lat, long),
          language: "pt-BR",
          radius: 1000,
          region: "BR");
      if (response.isOkay) {
        for (Prediction prediction in response.predictions) {
          predList.add(prediction);
          final ltlng = await places.getDetailsByPlaceId(prediction.placeId);
          predLatLongList.add(LatLng(ltlng.result.geometry.location.lat,
              ltlng.result.geometry.location.lng));
        }
      }
    }

    for (Prediction pred in predList) {
      print(pred.description);
    }

    // print("acabou");

    return getMarkers(predList, predLatLongList);
  }

  Future<void> getLocationPermission() async {
    final status = await Permission.location.request();
    print(status);
  }

  Future<Position> getPosition() async {
    return await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  List<Marker> getMarkers(List<Prediction> predictions, List<LatLng> latLong) {
    List<Marker> markers = List<Marker>();

    for (int i = 0; i < predictions.length; i++) {
      markers.add(Marker(
          markerId: MarkerId(predictions.elementAt(i).id),
          position: latLong.elementAt(i)));
    }

    return markers;
  }
}
