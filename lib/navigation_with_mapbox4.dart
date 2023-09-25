// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:http/http.dart' as http;
//
// class NavigationWithMapbox4 extends StatefulWidget {
//   @override
//   _NavigationWithMapbox4State createState() => _NavigationWithMapbox4State();
// }
//
// class _NavigationWithMapbox4State extends State<NavigationWithMapbox4> {
//   late MapboxMapController _mapController;
//   late String _routeString;
//   late List<Point<num>> _routePoints;
//   late List<LatLng> _routeLatLngs;
//   LatLng _origin = LatLng(37.7749, -122.4194);
//   LatLng _destination = LatLng(37.3366, -121.8906);
//   int _currentStep = 0;
//   bool _isNavigating = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _getRoute();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mapbox Navigation'),
//       ),
//       body: MapboxMap(
//         accessToken: 'YOUR_MAPBOX_ACCESS_TOKEN',
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: _origin,
//           zoom: 14.0,
//         ),
//         annotations: Set<Annotation>.of(_routeLatLngs.asMap().entries.map((entry) {
//           int index = entry.key;
//           LatLng point = entry.value;
//           return Annotation(
//             id: index.toString(),
//             position: point,
//             iconImage: 'arrow-icon',
//             iconSize: 0.5,
//             rotateWithMap: true,
//             rotationAlignment: Alignment.center,
//             rotation: _getBearing(point, _routeLatLngs[_currentStep]),
//           );
//         })),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _isNavigating = !_isNavigating;
//           });
//           if (_isNavigating) {
//             _startNavigation();
//           } else {
//             _stopNavigation();
//           }
//         },
//         child: Icon(_isNavigating ? Icons.stop : Icons.play_arrow),
//       ),
//     );
//   }
//
//   void _onMapCreated(MapboxMapController controller) {
//     _mapController = controller;
//   }
//
//   void _getRoute() async {
//     String url =
//         'https://api.mapbox.com/directions/v5/mapbox/driving/${_origin.longitude},${_origin.latitude};${_destination.longitude},${_destination.latitude}?geometries=polyline&access_token=YOUR_MAPBOX_ACCESS_TOKEN';
//     http.Response response = await http.get(url);
//     if (response.statusCode == 200) {
//       setState(() {
//         _routeString = response.body;
//         _routePoints = decodeLine(_routeString);
//         _routeLatLngs = _routePoints.map((point) => LatLng(point.y, point.x)).toList();
//       });
//     } else {
//       throw Exception('Failed to load route');
//     }
//   }
//
//   List<Point<num>> decodeLine(String encodedLine) {
//     final List<Point<num>> points = [];
//     int i = 0;
//     int x = 0;
//     int y = 0;
//     while (i < encodedLine.length) {
//       int byte = 0;
//       int shift = 0;
//       int result = 0;
//       do {
//         if (i >= encodedLine.length) {
//           // Check if we reached the end of the string
//           break; // Exit the loop if we reached the end
//         }
//         byte = encodedLine.codeUnitAt(i++) - 63;
//         result |= (byte & 0x1F) << shift;
//         shift += 5;
//       } while (byte >= 0x20);
//
//       if (i >= encodedLine.length) {
//         // Check if we reached the end of the string
//         break; // Exit the loop if we reached the end
//       }
//
//       int dx = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       x += dx;
//
//       shift = 0;
//       result = 0;
//       do {
//         if (i >= encodedLine.length) {
//           // Check if we reached the end of the string
//           break; // Exit the loop if we reached the end
//         }
//         byte = encodedLine.codeUnitAt(i++) - 63;
//         result |= (byte & 0x1F) << shift;
//         shift += 5;
//       } while (byte >= 0x20);
//
//       if (i >= encodedLine.length) {
//         // Check if we reached the end of the string
//         break; // Exit the loop if we reached the end
//       }
//
//       int dy = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       y += dy;
//
//       points.add(Point(x: x / 1E5, y: y / 1E5));
//     }
//
//     return points;
//   }
//
//   double _getBearing(LatLng from, LatLng to) {
//     double lat1 = from.latitude * (3.141592653589793 / 180);
//     double lon1 = from.longitude * (3.141592653589793 / 180);
//     double lat2 = to.latitude * (3.141592653589793 / 180);
//     double lon2 = to.longitude * (3.141592653589793 / 180);
//     double y = sin(lon2 - lon1) * cos(lat2);
//     double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1);
//     double bearing = atan2(y, x) * (180 / 3.141592653589793);
//     return bearing;
//   }
//
//   void _startNavigation() {
//     _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//       target: _routeLatLngs[_currentStep],
//       zoom: 16.0,
//     )));
//     _mapController.addSymbol(SymbolOptions(
//       geometry: _routeLatLngs[_currentStep],
//       iconImage: 'arrow-icon',
//       iconSize: 0.5,
//       rotateWithView: true,
//       rotationAlignment: Alignment.center,
//       rotation: _getBearing(_routeLatLngs[_currentStep], _routeLatLngs[_currentStep + 1]),
//     ));
//     _mapController.onSymbolTapped.add(_onSymbolTapped);
//   }
//
//   void _stopNavigation() {
//     _mapController.clearSymbols();
//     _mapController.onSymbolTapped.remove(_onSymbolTapped);
//   }
//
//   void _onSymbolTapped(Symbol symbol) {
//     int index = int.parse(symbol.id);
//     if (index == _currentStep) {
//       setState(() {
//         _currentStep++;
//       });
//       if (_currentStep < _routeLatLngs.length - 1) {
//         _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//           target: _routeLatLngs[_currentStep],
//           zoom: 16.0,
//         )));
//         _mapController.clearSymbols();
//         _mapController.addSymbol(SymbolOptions(
//           geometry: _routeLatLngs[_currentStep],
//           iconImage: 'arrow-icon',
//           iconSize: 0.5,
//           rotateWithView: true,
//           rotationAlignment: Alignment.center,
//           rotation: _getBearing(_routeLatLngs[_currentStep], _routeLatLngs[_currentStep + 1]),
//         ));
//       } else {
//         _stopNavigation();
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Navigation Complete'),
//               content: Text('You have reached your destination.'),
//               actions: <Widget>[
//                 FlatButton(
//                   child: Text('OK'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     }
//   }
// }