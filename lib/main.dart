import 'package:flutter/material.dart';

import 'full_screen_map.dart';
import 'getting_live_location.dart';
import 'nav_map_box3.dart';
import 'navigation_with_mapbox1.dart';
import 'official_mapbox_maps.dart';
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
      home: FullMap(),
    );
  }
}
