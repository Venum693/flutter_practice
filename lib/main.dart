import 'package:flutter/material.dart';

import 'full_screen_map.dart';
import 'getting_live_location.dart';
import 'navigation_with_mapbox1.dart';

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
      home: FullScreenMap()
    );
  }
}
