import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({Key? key}) : super(key: key);

  static const String routeName = 'home';

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  late MapboxMapController mapController;
  final LatLng center = const LatLng(12.8519, 76.4807);
   LatLng? _currentLocation;
  String? address;




  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _inclination();
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/images/Group 71.png");
    //addImageFromUrl("networkImage", Uri.parse("https://via.placeholder.com/50"));
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mapController.addImage(name, response.bodyBytes);
  }

  void _inclination() {
    mapController.animateCamera(CameraUpdate.tiltTo(40));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:Stack(
        children: [
          buildMap(),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.5),
                ),
                child:  Text(
                  address==null ? ' ShravanaBelagola ': ' $address ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          )
        ],
      ),
      floatingActionButton: _floatingBottons(),
    );
  }

  Column _floatingBottons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Symbols
        FloatingActionButton(
          splashColor: Colors.green,
          tooltip: 'LOCATE ME',
          backgroundColor: Colors.green.shade800,
          onPressed: () async {
            await _getLocationAndPermission();
            // if (_currentLocation == null ) {
            //   Position position = await Geolocator.getCurrentPosition(
            //     desiredAccuracy: LocationAccuracy.high,
            //   );
            //
            //   setState(() {
            //     _currentLocation = LatLng(position.latitude, position.longitude);
            //   });
            //   mapController.animateCamera(
            //     CameraUpdate.newLatLng(_currentLocation!),
            //   );
            //   mapController.addSymbol(
            //     SymbolOptions(
            //       geometry: _currentLocation,
            //       // iconImage: 'networkImage',
            //       iconImage: 'assetImage',
            //       iconColor: '#fffdd835',
            //       iconSize: 0.15,
            //       textField: 'YOU ARE HERE',
            //       textColor: '#ff000000',
            //       textSize: 20,
            //       textOffset: const Offset(0, 2),
            //     ),
            //   );
            //   getAddressFromLatLng(_currentLocation!);
            // }

          },
          child: const Icon(Icons.my_location),
        ),
        const SizedBox(height: 5),

        // Zoom In
        FloatingActionButton(
          tooltip: 'ZOOM IN',
          backgroundColor: Colors.green.shade800,
          onPressed: () {
            mapController.animateCamera(
              CameraUpdate.zoomIn(),
              // CameraUpdate.tiltTo(40),
            );
          },
          child: const Icon(Icons.zoom_in),
        ),
        const SizedBox(height: 5),

        // Zoom Out
        FloatingActionButton(
          tooltip: 'ZOOM OUT',
          backgroundColor: Colors.green.shade800,
          onPressed: () {
            mapController.animateCamera(
              CameraUpdate.zoomOut(),
            );
          },
          child: const Icon(Icons.zoom_out),
        ),
        const SizedBox(height: 5),

        // Change Style

      ],
    );
  }

  MapboxMap buildMap() {
    return MapboxMap(
      //styleString: selectedStyle,
      accessToken: 'pk.eyJ1IjoiaGVscHltb3RvIiwiYSI6ImNsamNscHVuejAyOXAzZG1vNXppYnM1NzkifQ.BB9fpPJb9eDpRJkWwkRHXA',
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _currentLocation ?? center,
        zoom: 14,
      ),
      compassEnabled: true,
    );
  }

  Future<void> _getLocationAndPermission() async {
    final LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await _getCurrentLocation();
    } else {
      // Handle permission denied or restricted state
      // You can show a dialog or a message to the user
      print('Location permission denied');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      mapController.animateCamera(
        CameraUpdate.newLatLng(_currentLocation!),
      );

      mapController.addSymbol(
        SymbolOptions(
          geometry: _currentLocation,
          iconImage: 'assetImage',
          iconColor: '#fffdd835',
          iconSize: 0.15,
          textField: 'YOU ARE HERE',
          textColor: '#ff000000',
          textSize: 20,
          textOffset: const Offset(0, 2),
        ),
      );

      getAddressFromLatLng(_currentLocation!);
    } catch (e) {
      print('Error getting location: $e');
    }
  }


  Future<String?> getAddressFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
         setState(() {
           address = "${placemark.street},${placemark.subLocality},${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
         });
        print('-----------$address--------------------');
        return address;
      } else {
        return "No address available";
      }
    } catch (e) {
      return "Error retrieving address: $e";
    }
  }
}