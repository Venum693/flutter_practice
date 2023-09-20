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
//   MapboxMapController? _mapController;
//   final LatLng origin = LatLng(37.7749, -122.4194); // Replace with your origin coordinates
//   final LatLng destination = LatLng(37.8049, -122.4738); // Replace with your destination coordinates
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mapbox Navigation Demo'),
//       ),
//       body: MapboxMap(
//         accessToken: '<your-access-token>',
//         initialCameraPosition: CameraPosition(
//           target: origin,
//           zoom: 12.0,
//         ),
//         onMapCreated: (controller) {
//           setState(() {
//             _mapController = controller;
//           });
//         },
//         polylines: <Polyline>[
//           Polyline(
//             polylineId: PolylineId('route'),
//             points: [], // Define your route points here
//             color: Colors.blue,
//             width: 3,
//           ),
//         ],
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
//     final routeResponse = await http.get(
//       'https://api.mapbox.com/directions/v5/mapbox/driving/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?access_token=<your-access-token>',
//     );
//
//     if (routeResponse.statusCode == 200) {
//       final decodedResponse = json.decode(routeResponse.body);
//       final routeGeometry = decodedResponse['routes'][0]['geometry'];
//       final List<Point> routePoints = decodeLine(routeGeometry);
//
//       setState(() {
//         _mapController?.updatePolyline(
//           PolylineOptions(
//             polylineId: PolylineId('route'),
//             points: routePoints,
//           ),
//         );
//       });
//
//       List<LegStep> steps = decodedResponse['routes'][0]['legs'][0]['steps'];
//       for (int index = 0; index < steps.length; index++) {
//         final step = steps[index];
//         final LatLng turnPoint = LatLng(
//           step['maneuver']['location'][1],
//           step['maneuver']['location'][0],
//         );
//
//         _mapController.addSymbol(
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
// }
