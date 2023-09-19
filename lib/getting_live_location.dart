
import 'package:flutter/material.dart';

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

//add marker icon to map

class LiveLocationMap extends StatefulWidget {
  @override
  _LiveLocationMapState createState() => _LiveLocationMapState();
}

class _LiveLocationMapState extends State<LiveLocationMap> {
   late MapboxMapController _mapController;
   late LatLng _currentLocation;


  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }
  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Permission is granted, you can proceed to get the location.
      _getCurrentLocation();
    } else if (status.isDenied) {
      // Permission denied, handle it accordingly (show a message, etc.).
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission Required'),
            content: Text('To use this feature, please enable location permissions in the app settings.'),
            actions: <Widget>[
              TextButton(
                child: Text('Open Settings'),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    print('----------${position.latitude}-----------------${position.longitude}');
  }

  void _onMapCreated(MapboxMapController controller) {
      _mapController = controller;
    // Add a marker to the map at the current location.
    if (_currentLocation != null && _mapController != null) {
      print('---------Mapcontroller is not null--------');

      _mapController?.addSymbol(
        SymbolOptions(
          geometry: _currentLocation!,
          iconImage: 'assets/images/Group 71.png', // Use the image name
        ),
      );
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          _currentLocation!,
          14.0,
        ),
      );
    }else{
      print('---------Mapcontroller is null--------');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Live Location'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Stack(
          children: [
            if (_currentLocation != null)
              MapboxMap(
                accessToken: 'pk.eyJ1IjoiaGVscHltb3RvIiwiYSI6ImNsamNscHVuejAyOXAzZG1vNXppYnM1NzkifQ.BB9fpPJb9eDpRJkWwkRHXA',
                onMapCreated: _onMapCreated,
                styleString: 'mapbox://styles/mapbox/streets-v11',
                initialCameraPosition: CameraPosition(
                  target: _currentLocation ?? LatLng(0.0, 0.0),
                  zoom: 14.0,

                ),

              ),

            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  if (_currentLocation != null && _mapController != null) {
                    _mapController!.animateCamera(
                      CameraUpdate.newLatLng(_currentLocation!),
                    );
                  }
                  //_onMapCreated(_mapController!);
                },
                tooltip: 'LOCATE ME',
                child: Icon(Icons.my_location,color: Colors.black),
                backgroundColor: Colors.greenAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
