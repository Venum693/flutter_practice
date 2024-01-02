import 'package:flutter/material.dart';
import 'package:flutter_practice/Animation.dart';
import 'package:flutter_practice/interactive_viewer.dart';
import 'package:flutter_practice/keys.dart';
import 'package:flutter_practice/ONDC%20/ondc_cart.dart';
import 'package:flutter_practice/navigation.dart';
import 'package:flutter_practice/pagination.dart';

import 'Official Maps/official_mapbox_image source.dart';
import 'Official Maps/official_mapbox_map_interface.dart';
import 'flutter_mapbox/full_screen_map.dart';
import 'flutter_mapbox/getting_live_location.dart';
import 'flutter_mapbox/nav_map_box3.dart';
import 'flutter_mapbox/navigation_with_mapbox1.dart';
import 'Official Maps/official_map_box_circle annotation.dart';
import 'Official Maps/official_mapbox_Full_map.dart';
import 'Official Maps/official_mapbox_animation.dart';
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
      //home: MapInterfacePageBody(),
      //home: KeysTypes(),
      //home: OndcCart(),
      //home: DemoInteractiveViewer(),
      //home: AnimationDemo(),
      home: SampleNavigationApp(),

    );
  }
}
