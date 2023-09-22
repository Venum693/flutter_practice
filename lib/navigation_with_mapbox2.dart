import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class NavigationWithMapbox extends StatefulWidget {
  @override
  _NavigationWithMapboxState createState() => _NavigationWithMapboxState();
}

class _NavigationWithMapboxState extends State<NavigationWithMapbox> {
  late MapboxMapController _mapController;
  late String _durationText;
  final String accessToken = '<your-access-token>';
  final LatLng origin = LatLng(37.7749, -122.4194);
  final LatLng destination = LatLng(37.7749, -122.4313);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation with Mapbox'),
      ),
      body: MapboxMap(
        accessToken: accessToken,
        initialCameraPosition: CameraPosition(
          target: origin,
          zoom: 12.0,
        ),
        onMapCreated: (MapboxMapController controller) {
          _mapController = controller;
        },
        onStyleLoadedCallback: _onStyleLoaded,
      ),
    );
  }

  Future<void> getRoute() async {
    final Uri routeUri = Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/driving/'
            '${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}'
    ).replace(queryParameters: {
      'access_token': accessToken,
    });

    final routeResponse = await http.get(routeUri);

    if (routeResponse.statusCode == 200) {
      final decodedResponse = json.decode(routeResponse.body);
      final route = Route.fromJson(decodedResponse['routes'][0]);

      // Display the duration of the route
      final duration = route.legs.first.duration;
      setState(() {
        _durationText = 'Duration: ${duration.toStringAsFixed(0)} seconds';
      });

      // Draw the polyline on the map
      final List<Point> routePoints = decodeLine(route.geometry);
      final List<LatLng> latLngRoutePoints = routePoints.map((point) {
        return LatLng(point.y.toDouble(), point.x.toDouble());
      }).toList();
      _mapController.addLine(
        LineOptions(
          geometry: latLngRoutePoints,
          lineColor: '#FF0000',
          lineWidth: 3.0,
          lineOpacity: 1.0,
          draggable: true,
        ),
      );

      // Add turn instructions as markers
      final List<LegStep> steps = route.legs.first.steps;
      final List<Point> turnPoints = steps.map((step) => Point(
        x: step.maneuver.location[0],
        y: step.maneuver.location[1],
      )).toList();
      for (int i = 0; i < turnPoints.length; i++) {
        _mapController.addSymbol(
          SymbolOptions(
            geometry: LatLng(turnPoints[i].y.toDouble(), turnPoints[i].x.toDouble()),
            iconImage: 'assetImage',
            iconSize: 1.5,
            textField: steps[i].maneuver.instruction,
            textOffset: Offset(0, 2),
          ),
        );
      }
    } else {
      throw Exception('Failed to load route');
    }
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/images/Group 71.png");
    getRoute();
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return _mapController.addImage(name, list);
  }

  List<Point> decodeLine(String encodedLine) {
    final List<Point> points = [];
    int i = 0;
    int x = 0;
    int y = 0;
    while (i < encodedLine.length) {
      int byte = 0;
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

      points.add(Point(x: x / 1E5, y: y / 1E5));
    }

    return points;
  }
}
class Point {
  final double x;
  final double y;

  Point({required this.x, required this.y});
}
class Route {
  final List<RouteLeg> legs;
  final String geometry;

  Route({required this.legs, required this.geometry});

  factory Route.fromJson(Map<String, dynamic> json) {
    final legsJson = json['legs'] as List<dynamic>;
    final legs = legsJson.map((legJson) => RouteLeg.fromJson(legJson)).toList();
    return Route(
      legs: legs,
      geometry: json['geometry'] as String,
    );
  }
}

class RouteLeg {
  final double weight;
  final double duration;
  final double distance;
  final String summary;
  final List<LegStep> steps;

  RouteLeg({required this.weight, required this.duration, required this.distance, required this.summary, required this.steps});

  factory RouteLeg.fromJson(Map<String, dynamic> json) {
    final stepsJson = json['steps'] as List<dynamic>;
    final steps = stepsJson.map((stepJson) => LegStep.fromJson(stepJson)).toList();
    return RouteLeg(
      weight: json['weight'] as double,
      duration: json['duration'] as double,
      distance: json['distance'] as double,
      summary: json['summary'] as String,
      steps: steps,
    );
  }
}

class LegStep {
  final Maneuver maneuver;

  LegStep({required this.maneuver});

  factory LegStep.fromJson(Map<String, dynamic> json) {
    return LegStep(
      maneuver: Maneuver.fromJson(json['maneuver']),
    );
  }
}

class Maneuver {
  final List<double> location;
  final String instruction;

  Maneuver({required this.location, required this.instruction});

  factory Maneuver.fromJson(Map<String, dynamic> json) {
    final locationJson = json['location'] as List<dynamic>;
    final location = locationJson.map((coord) => coord as double).toList();
    return Maneuver(
      location: location,
      instruction: json['instruction'] as String,
    );
  }
}