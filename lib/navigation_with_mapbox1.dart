// import 'dart:html';
//
// import 'package:flutter/material.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class MapboxNavigationDemo extends StatefulWidget {
//   @override
//   _MapboxNavigationDemoState createState() => _MapboxNavigationDemoState();
// }
//
// class _MapboxNavigationDemoState extends State<MapboxNavigationDemo> {
//   late MapboxMapController _mapController;
//   final LatLng origin = LatLng(37.7749, -122.4194); // Replace with your origin coordinates
//   final LatLng destination = LatLng(37.8049, -122.4738);
//   final String acstkn='pk.eyJ1IjoiaGVscHltb3RvIiwiYSI6ImNsamNscHVuejAyOXAzZG1vNXppYnM1NzkifQ.BB9fpPJb9eDpRJkWwkRHXA';// Replace with your destination coordinates
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: MapboxMap(
//         accessToken: acstkn,
//         initialCameraPosition: CameraPosition(
//           target: origin,
//           zoom: 12.0,
//         ),
//         onMapCreated: (controller) {
//           setState(() {
//             _mapController = controller;
//           });
//         },
//
//         // polylines: <Polyline>[
//         //   Polyline(
//         //     polylineId: PolylineId('route'),
//         //     points: [], // Define your route points here
//         //     color: Colors.blue,
//         //     width: 3,
//         //   ),
//         // ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await getRoute();
//         },
//         child: Icon(Icons.directions),
//       ),
//     );
//   }
//
//   Future<void> getRoute() async {
//     final Uri routeUri = Uri.parse(
//         'https://api.mapbox.com/directions/v5/mapbox/driving/'
//             '${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}'
//     ).replace(queryParameters: {
//       'access_token': acstkn,
//     });
//
//     final routeResponse = await http.get(routeUri);
//
//     if (routeResponse.statusCode == 200) {
//       print(routeResponse.body);
//
//       final decodedResponse = json.decode(routeResponse.body);
//       final routeGeometry = decodedResponse['routes'][0]['geometry'];
//       final List<Point> routePoints = decodeLine(routeGeometry);
//
//       setState(() {
//         _mapController.updatePolyline(
//           PolylineOptions(
//             polylineId: PolylineId('route'),
//             points: routePoints,
//           ),
//         );
//       });
//
//       List<Map<String, dynamic>> steps = decodedResponse['routes'][0]['legs'][0]['steps'];
//       for (int index = 0; index < steps.length; index++) {
//         final step = steps[index];
//         final LatLng turnPoint = LatLng(
//           step['maneuver']['location'][1],
//           step['maneuver']['location'][0],
//         );
//         // Now you can use the step information as needed
//       }
//
//
//       _mapController.addSymbol(
//           SymbolOptions(
//             geometry: turnPoint,
//             iconImage: 'your-icon-image', // Replace with your icon image
//             textField: step['maneuver']['instruction'],
//             textOffset: Offset(0, 2),
//           ),
//         );
//       }
//     } else {
//       throw Exception('Failed to load route');
//     }
//   }
//   List<Point> decodeLine(String encodedLine) {
//     final List<Point> points = [];
//     final List<int> values = [];
//     int x = 0;
//     int y = 0;
//
//     for (int i = 0; i < encodedLine.length; i++) {
//       int byte;
//       int shift = 0;
//       int result = 0;
//
//       do {
//         byte = encodedLine.codeUnitAt(i++) - 63;
//         result |= (byte & 0x1F) << shift;
//         shift += 5;
//       } while (byte >= 0x20);
//
//       int dx = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       x += dx;
//
//       shift = 0;
//       result = 0;
//
//       do {
//         byte = encodedLine.codeUnitAt(i++) - 63;
//         result |= (byte & 0x1F) << shift;
//         shift += 5;
//       } while (byte >= 0x20);
//
//       int dy = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       y += dy;
//
//       points.add(Point(x / 1E5, y / 1E5));
//     }
//
//     return points;
//   }
//
// }
