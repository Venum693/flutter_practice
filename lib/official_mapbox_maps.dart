import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  late MapboxMap mapboxMapcontroller;

  _onMapCreated(MapboxMap mapboxMap) async {
    //mapboxMapcontroller = mapboxMap;
    // mapboxMap.location.updateSettings(
    //   LocationComponentSettings(
    //     locationPuck: LocationPuck(
    //      locationPuck3D: LocationPuck3D(
    //        modelUri:"https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf"
    //      )
    //     ),
    //   )
    // );
    mapboxMapcontroller = mapboxMap;
    await mapboxMapcontroller.annotations.createPointAnnotationManager().then((value) async{
      final ByteData bytes = await rootBundle.load('assets/images/Group 71.png');
      final Uint8List list = bytes.buffer.asUint8List();
      var options = <PointAnnotationOptions>[];
      for (var i = 0; i < 5; i++){
        options.add(PointAnnotationOptions(
            geometry: Point(coordinates: Position(77.6408,12.9784)).toJson(), image: list,),);
      }
      //pointAnnotationManager?. = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(resourceOptions: ResourceOptions(
          accessToken: 'pk.eyJ1IjoiaGVscHltb3RvIiwiYSI6ImNsamNscHVuejAyOXAzZG1vNXppYnM1NzkifQ.BB9fpPJb9eDpRJkWwkRHXA'
      ),
      onMapCreated: _onMapCreated,
        key: ValueKey('map_widget'),
        // cameraOptions: CameraOptions(
        //   center: Point(coordinates: Position(77.6408,12.9784)).toJson(),
        //   zoom: 20.0,
        // ),
      ),
    );
  }
}
