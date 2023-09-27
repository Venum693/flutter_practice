import 'package:flutter/material.dart';

import 'Official Maps/official_mapbox_image source.dart';
import 'Official Maps/official_mapbox_map_interface.dart';
import 'full_screen_map.dart';
import 'getting_live_location.dart';
import 'nav_map_box3.dart';
import 'navigation_with_mapbox1.dart';
import 'Official Maps/official_map_box_circle annotation.dart';
import 'Official Maps/official_mapbox_Full_map.dart';
import 'Official Maps/official_mapbox_animation.dart';
import 'official_mapbox_maps.dart';
import 'Official Maps/official_mapbox_maps2.dart';
//import 'navigation_with_mapbox2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //remove debug banner
      title: 'MAPS',
      //home: FullScreenMap()
      //home: NavigationWithMapbox(),
      //home: FullMap(),
      //home: LocationPageBody(),
      //home: AnimationPageBody(),
      //home: CircleAnnotationPageBody(),
      home: MapInterfacePageBody(),

    );
  }
}
