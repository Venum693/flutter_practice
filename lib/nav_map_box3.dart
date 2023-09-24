// import 'dart:async';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
//
// class NavigationWithMapbox extends StatefulWidget {
//   @override
//   _NavigationWithMapboxState createState() => _NavigationWithMapboxState();
// }
//
// class _NavigationWithMapboxState extends State<NavigationWithMapbox> {
//   late MapboxMapController mapController;
//   final LatLng _origin = const LatLng(37.7749, -122.4194);
//   late  LatLng _destination =  LatLng(37.7749, -122.5194);
//   List<LatLng> _route = [];
//   late Symbol _marker;
//   bool _isNavigating = false;
//   int _currentStep = 0;
//   late StreamSubscription<MapboxNavigationEvent> _subscription;
//
//   void _onMapCreated(MapboxMapController controller) {
//     mapController = controller;
//     _addMarker(_origin);
//     _addMarker(_destination);
//     _getRoute();
//
//   }
//
//   void _addMarker(LatLng point) async {
//     var image = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(devicePixelRatio: 2.5),
//       'assets/images/marker.png',
//     );
//     mapController.addSymbol(
//       SymbolOptions(
//         geometry: point,
//         iconImage: image,
//         iconSize: 1,
//       ),
//     );
//   }
//
//   void _getRoute() async {
//     var result = await DirectionsRepository().getDirections(_origin, _destination);
//     setState(() {
//       _route = result;
//     });
//   }
//
//   void _startNavigation() async {
//     if (_route.isNotEmpty) {
//       _isNavigating = true;
//       _subscription = MapboxNavigation.onEventResult.listen((event) {
//         if (event.event == MapboxNavigationEvent.progress_change) {
//           setState(() {
//             _currentStep = event.data['step'];
//           });
//         }
//       });
//       await MapboxNavigation.startNavigation(
//         options: MapboxNavigationOptions(
//           mode: MapboxNavigationMode.drivingWithTraffic,
//           simulateRoute: true,
//         ),
//         origin: _origin,
//         destination: _destination,
//         waypoints: _route.sublist(1, _route.length - 1),
//       );
//     }
//   }
//
//   void _stopNavigation() async {
//     if (_isNavigating) {
//       await MapboxNavigation.stopNavigation();
//       _subscription.cancel();
//       setState(() {
//         _isNavigating = false;
//         _currentStep = 0;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Navigation with Mapbox'),
//       ),
//       body: MapboxMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: _origin,
//           zoom: 11.0,
//         ),
//         onMapClick: (point, coordinates) {
//           if (!_isNavigating) {
//             // _destination.latitude = coordinates.latitude;
//             // _destination.longitude = coordinates.longitude;
//             setState(() {
//               _destination = LatLng(coordinates.latitude, coordinates.longitude);
//             });
//             _getRoute();
//           }
//         },
//         onStyleLoadedCallback: () {
//           //MapboxMapController mapController = MapboxMapController();
//           mapController.addImage(
//             'arrow-icon',
//             AssetImage('assets/images/arrow.png'),
//           );
//         },
//
//         annotations: _route.map((point) {
//           return MarkerOptions(
//             geometry: point,
//             iconImage: 'arrow-icon',
//             iconSize: 0.5,
//             rotateWithView: true,
//             rotationAlignment: Alignment.center,
//             rotation: _getBearing(point, _route[_currentStep]),
//           );
//         }).toList(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _isNavigating ? _stopNavigation : _startNavigation,
//         child: Icon(_isNavigating ? Icons.stop : Icons.navigation),
//       ),
//     );
//   }
//
//   double _getBearing(LatLng start, LatLng end) {
//     double lat1 = _degreesToRadians(start.latitude);
//     double lon1 = _degreesToRadians(start.longitude);
//     double lat2 = _degreesToRadians(end.latitude);
//     double lon2 = _degreesToRadians(end.longitude);
//     double y = sin(lon2 - lon1) * cos(lat2);
//     double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1);
//     double bearing = _radiansToDegrees(atan2(y, x));
//     return bearing;
//   }
//
//   double _degreesToRadians(double degrees) {
//     return degrees * pi / 180;
//   }
//
//   double _radiansToDegrees(double radians) {
//     return radians * 180 / pi;
//   }
// }
//
// class DirectionsRepository {
//   Future<List<LatLng>> getDirections(LatLng origin, LatLng destination) async {
//     // Implement your own logic to get the route between the origin and destination
//     // For example, you can use the Mapbox Directions API to get the route
//     // Here, we just return a random route for demonstration purposes
//     List<LatLng> route = [];
//     Random random = Random();
//     double lat = origin.latitude;
//     double lng = origin.longitude;
//     for (int i = 0; i < 10; i++) {
//       lat += random.nextDouble() * 0.01;
//       lng += random.nextDouble() * 0.01;
//       route.add(LatLng(lat, lng));
//     }
//     route.add(destination);
//     return route;
//   }
// }
//
// enum MapboxNavigationEvent {
//   progress_change,
// }
//
// class MapboxNavigation {
//   static Stream<MapboxNavigationEvent> get onEventResult {
//     return const EventChannel('com.mapbox.plugins.navigation.event_channel')
//         .receiveBroadcastStream()
//         .map((dynamic event) => _parseEvent(event));
//   }
//
//   static Future<void> startNavigation({
//     required MapboxNavigationOptions options,
//     required LatLng origin,
//     required LatLng destination,
//     required List<LatLng> waypoints,
//   }) async {
//     Map<String, dynamic> args = {
//       'options': options.toJson(),
//       'origin': [origin.latitude, origin.longitude],
//       'destination': [destination.latitude, destination.longitude],
//       'waypoints': waypoints.map((point) => [point.latitude, point.longitude]).toList(),
//     };
//     await MethodChannel('com.mapbox.plugins.navigation.method_channel').invokeMethod('startNavigation', args);
//   }
//
//   static Future<void> stopNavigation() async {
//     await MethodChannel('com.mapbox.plugins.navigation.method_channel').invokeMethod('stopNavigation');
//   }
//
//   static MapboxNavigationEvent _parseEvent(dynamic event) {
//     Map<String, dynamic> data = Map<String, dynamic>.from(event);
//     switch (data['event']) {
//       case 'progress_change':
//         return MapboxNavigationEvent.progress_change;
//       default:
//         throw ArgumentError('Invalid event type: ${data['event']}');
//     }
//   }
// }
//
// class MapboxNavigationOptions {
//   final MapboxNavigationMode mode;
//   final bool simulateRoute;
//
//   MapboxNavigationOptions({
//     this.mode = MapboxNavigationMode.drivingWithTraffic,
//     this.simulateRoute = false,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'mode': mode.toString().split('.').last,
//       'simulateRoute': simulateRoute,
//     };
//   }
// }
//
// enum MapboxNavigationMode {
//   driving,
//   drivingWithTraffic,
//   walking,
//   cycling,
// }