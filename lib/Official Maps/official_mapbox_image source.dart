// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:turf/helpers.dart';
//
//
//
// class ImageSourceWidget extends StatefulWidget {
//   const ImageSourceWidget();
//
//   @override
//   State createState() => ImageSourceWidgetState();
// }
//
// class ImageSourceWidgetState extends State<ImageSourceWidget> {
//   MapboxMap? mapboxMap;
//   var isLight = true;
//
//   _onMapCreated(MapboxMap mapboxMap) async {
//
//     // this.mapboxMap = mapboxMap;
//     // await mapboxMap.style
//     //     .addSource(ImageSource(id: "image_source-id", coordinates: [
//     //   [-80.11725, 25.7836],
//     //   [-80.1397431334, 25.783548],
//     //   [-80.13964, 25.7680],
//     //   [-80.11725, 25.76795]
//     // ]));
//     // await mapboxMap.style.addLayer(RasterLayer(
//     //   id: "image_layer-id",
//     //   sourceId: "image_source-id",
//     // ));
//   }
//
//   _onStyleLoaded(StyleLoadedEventData data) async {
//     var imageSource =
//     await mapboxMap?.style.getSource("image_source-id") as ImageSource;
//     final ByteData bytes = await rootBundle.load('assets/images/Group 71.png');
//     final Uint8List list = bytes.buffer.asUint8List();
//     // TODO: Create MbxImage in an eaier way.
//     imageSource.updateImage(MbxImage(width: 280, height: 203, data: list));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: MapWidget(
//           key: ValueKey("mapWidget"),
//           resourceOptions: ResourceOptions(accessToken: 'pk.eyJ1IjoiaGVscHltb3RvIiwiYSI6ImNsamNscHVuejAyOXAzZG1vNXppYnM1NzkifQ.BB9fpPJb9eDpRJkWwkRHXA'),
//           styleUri: MapboxStyles.TRAFFIC_DAY,
//           cameraOptions: CameraOptions(
//               center: Point(coordinates: Position(76.4807, 12.8519)).toJson(),
//               zoom: 12.0),
//           onMapCreated: _onMapCreated,
//           onStyleLoadedListener: _onStyleLoaded,
//         ));
//   }
// }