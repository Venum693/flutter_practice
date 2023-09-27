import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
   MapboxMap? mapboxMapcontroller;

  _onMapCreated(MapboxMap mapboxMap) async {
    mapboxMapcontroller = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(resourceOptions: ResourceOptions(
              accessToken: 'pk.eyJ1IjoiaGVscHltb3RvIiwiYSI6ImNsamNscHVuejAyOXAzZG1vNXppYnM1NzkifQ.BB9fpPJb9eDpRJkWwkRHXA'
          ),
            onMapCreated: _onMapCreated,
            key: ValueKey('map_widget'),
            // cameraOptions: CameraOptions(
            //   center: Point(coordinates: Position(77.6408,12.9784)).toJson(),
            //   zoom: 20.0,
            // ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              color: Colors.black,
              child: TextButton(onPressed: () async {
                var status = await Permission.locationWhenInUse.request();
                print("Location granted : $status");
                mapboxMapcontroller?.easeTo(CameraOptions(
                  zoom: 17,
                  center: Point(coordinates: Position(77.6408,12.9784)).toJson(),
                ),
                    MapAnimationOptions(duration: 2000, startDelay: 0));
                  // mapboxMapcontroller?.location
                  //     .updateSettings(LocationComponentSettings(enabled: true,));
                  // mapboxMapcontroller?.setCamera(CameraOptions(
                  //   center: Point(coordinates: Position(1.0,2.0)).toJson(),
                  //   zoom: 16.0,
                  // ));
            }, child: Text('Locate Me'),),),
          )
        ],
      )
    );
  }
}
