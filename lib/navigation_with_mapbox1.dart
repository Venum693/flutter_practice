


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practice/model_response_body.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mapbox_gl/mapbox_gl.dart';

class MapboxNavigationDemo extends StatefulWidget {
  @override
  _MapboxNavigationDemoState createState() => _MapboxNavigationDemoState();
}

class _MapboxNavigationDemoState extends State<MapboxNavigationDemo> {
  late MapboxMapController _mapController;
  final LatLng origin = LatLng(12.9784, 77.6408); // Replace with your origin coordinates
  final LatLng destination = LatLng(13.1989, 77.7068);
  final String acstkn='pk.eyJ1IjoiaGVscHltb3RvIiwiYSI6ImNsamNscHVuejAyOXAzZG1vNXppYnM1NzkifQ.BB9fpPJb9eDpRJkWwkRHXA';// Replace with your destination coordinates

  Welcome obj = Welcome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        accessToken: acstkn,

        initialCameraPosition: CameraPosition(
          target: origin,
          zoom: 12.0,
        ),
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
            _mapController.getLineLatLngs(
              Line(acstkn, LineOptions(geometry: [LatLng(12.9784, 77.6408), LatLng(13.1989, 77.7068)])
            ));
            _onStyleLoaded();
          });
        },

        // polylines: <Polyline>[
        //   Polyline(
        //     polylineId: PolylineId('route'),
        //     points: [], // Define your route points here
        //     color: Colors.blue,
        //     width: 3,
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getRoute();
        },
        child: Icon(Icons.directions),
      ),
    );
  }

  Future<void> getRoute() async {
    final Uri routeUri = Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/driving/'
            '${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}'
    ).replace(queryParameters: {
      'access_token': acstkn,
    });

    final routeResponse = await http.get(routeUri);


    if (routeResponse.statusCode == 200) {
      print(routeResponse.body);

      final decodedResponse = json.decode(routeResponse.body);
      //final routeGeometry = decodedResponse['routes'][0]['geometry'];
      //final List<Point> routePoints = decodeLine(routeGeometry);
      final List<Point<num>> routePoints = decodeLine(decodedResponse['routes'][0]['geometry']);

      // Convert List<Point<num>> to List<LatLng>
      final List<LatLng> latLngRoutePoints = routePoints.map((point) {
        return LatLng(point.y.toDouble(), point.x.toDouble());
      }).toList();

      // Remove the old polyline
      //_mapController.clearLines();

      // Add the new polyline to the map
      _mapController.addLine(
        LineOptions(
          geometry: latLngRoutePoints, // Use the converted List<LatLng>
          lineColor: '#FF0000',
          lineWidth: 3.0,
          lineOpacity: 1.0,
          draggable: true,
        ),
      );

      // setState(() {
      //   _mapController.updatePolyline(
      //     PolylineOptions(
      //       polylineId: PolylineId('route'),
      //       points: routePoints,
      //     ),
      //   );
      // });

      List<Map<String, dynamic>> steps = (decodedResponse['routes'][0]['legs'][0]['steps'] as List<dynamic>).cast<Map<String, dynamic>>();
      for (int index = 0; index < steps.length; index++) {
        final step = steps[index];
        final LatLng turnPoint = LatLng(
          step['maneuver']['location'][1],
          step['maneuver']['location'][0],
        );
        // Now you can use the step information as needed
        _mapController.addSymbol(
          SymbolOptions(
            geometry: turnPoint,
            iconImage: 'assetImage', // Replace with your icon image
            iconSize: 1.5,
            textField: step['maneuver']['instruction'],
            textOffset: Offset(0, 2),
          ),
        );
      }
    } else {
      throw Exception('Failed to load route');
    }
  }
  List<Point> decodeLine(String encodedLine) {
    final List<Point> points = [];
    int x = 0;
    int y = 0;
    int i = 0; // Initialize the index variable

    while (i < encodedLine.length) {
      int byte;
      int shift = 0;
      int result = 0;

      do {
        if (i >= encodedLine.length) {
          // Check if we reached the end of the string
          break; // Exit the loop if we reached the end
        }
        byte = encodedLine.codeUnitAt(i++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      if (i >= encodedLine.length) {
        // Check if we reached the end of the string
        break; // Exit the loop if we reached the end
      }

      int dx = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      x += dx;

      shift = 0;
      result = 0;

      do {
        if (i >= encodedLine.length) {
          // Check if we reached the end of the string
          break; // Exit the loop if we reached the end
        }
        byte = encodedLine.codeUnitAt(i++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      if (i >= encodedLine.length) {
        // Check if we reached the end of the string
        break; // Exit the loop if we reached the end
      }

      int dy = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      y += dy;

      points.add(Point(x / 1E5, y / 1E5));
    }

    return points;
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/images/Group 71.png");
  }
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return _mapController.addImage(name, list);
  }
}
