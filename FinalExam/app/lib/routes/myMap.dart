import 'dart:math';
import 'dart:convert';
import 'package:app/main.dart';
import 'package:app/services/notification_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;

// ignore: must_be_immutable
class Mymap extends StatefulWidget {
  Position position;
  late LatLng pos;
  List<LatLng> points = [];

  Mymap({super.key, required this.position}) {
    pos = LatLng(position.latitude, position.longitude);
  }

  @override
  State<Mymap> createState() => _MymapState(currentPosition: pos); // change position
}

class _MymapState extends State<Mymap> {
  bool inSelectedArea = true;
  List<LatLng> points = [];
  String? locName;
  late LatLng currentPosition;

  _MymapState({required this.currentPosition});

  void checkUpdateLocation(LatLng pointLatLng, BuildContext context) {
    List<map_tool.LatLng> convertedPolygonPoints = points
        .map(
          (e) => map_tool.LatLng(e.latitude, e.longitude)
    ).toList();
    inSelectedArea = map_tool.PolygonUtil.containsLocation(
      map_tool.LatLng(pointLatLng.latitude, pointLatLng.longitude), 
      convertedPolygonPoints,
      false);
    locName = inSelectedArea ? 'Inside Boundaries!' : 'Outside Boundaries!';
    if (!inSelectedArea) {
      NotificationService.showBigTextNotification(
          title: 'Geofencing',
          body: 'You got outside the boundaries!',
          fln: flutterLocalNotificationsPlugin
      );
    }
    
    currentPosition = pointLatLng;
    setState(() {});
  }

  List<LatLng> createCirclePolygon(LatLng center, double radius, int numPoints) {
    List<LatLng> points = [];
    const double earthRadius = 6371000.0;

    for (int i = 0; i < numPoints; i++) {
      double angle = (i * 2 * pi) / numPoints;

      double distanceRadians = radius / earthRadius;

      double latRadians = center.latitude * (pi / 180);
      double lonRadians = center.longitude * (pi / 180);

      double pointLatRadians = asin(sin(latRadians) * cos(distanceRadians) +
          cos(latRadians) * sin(distanceRadians) * cos(angle));

      double pointLonRadians = lonRadians +
          atan2(sin(angle) * sin(distanceRadians) * cos(latRadians),
              cos(distanceRadians) - sin(latRadians) * sin(pointLatRadians));

      double pointLat = pointLatRadians * (180 / pi);
      double pointLon = pointLonRadians * (180 / pi);

      points.add(LatLng(pointLat, pointLon));
    }

    return points;
  }

  Future<String> getAddressFromCoordinates(LatLng location) async
  {
    try {
      final apiKey = 'AIzaSyBUre2infGo2er3qlsyw_LcsJ39-uiCJIM';
      final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$apiKey');
      final response = await http.get(url);


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          final results = data['results'] as List;
          if (results.isNotEmpty) {
            final address = results[0]['formatted_address'] as String;
            return address;
          }
        }
      }
    } catch (e) {}

    return 'Location not found!';
  }

  @override 
  void initState() {
    super.initState();
    points = createCirclePolygon(currentPosition, 100, 63);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentPosition,
                zoom: 17.8
              ),
              markers: {
                Marker(
                  markerId: MarkerId('source'),
                  position: currentPosition,
                  draggable: true,
                  onDragEnd: (updateLatLng) {
                    checkUpdateLocation(updateLatLng, context);
                  },
                )
              },
              polygons: {
                Polygon(
                  polygonId: PolygonId('1'),
                  points: points,
                  strokeWidth: 2,
                  fillColor: Color(0xFF006491).withOpacity(0.2)
                ),
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(30),
            width: double.infinity,
            child: Column(
              children: [
                LocationField(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    showDialog(context: context, builder: (context) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    });
                    locName = await getAddressFromCoordinates(currentPosition);
                    setState(() {});
                    Navigator.of(context).pop();
                  }, 
                  child: Text(
                    'Get location',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: inSelectedArea ? Theme.of(context).colorScheme.primary : Colors.red,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2)
                    )
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget LocationField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 222, 219, 223),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: inSelectedArea ? Theme.of(context).colorScheme.primary : Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              color: Colors.white,
              size: 40 * 0.7,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              locName ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                color: inSelectedArea ? Colors.black : Colors.red,
              ),
            ),
          )
        ],
      )
    );
  }
}