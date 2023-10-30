import 'package:flutter/material.dart';

class KeysTypes extends StatefulWidget {
  const KeysTypes({super.key});

  @override
  State<KeysTypes> createState() => _KeysTypesState();
}

class _KeysTypesState extends State<KeysTypes> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
    Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('GlobalKey Example'),),
        body:
        // ListView(
        //   children: myData.map((data) {
        //     return ListTile(
        //       key: ObjectKey(data), // Use ObjectKey to identify items
        //       title: Text(data),
        //     );
        //   }).toList(),
        // )

      Center(
          child: ElevatedButton(
            onPressed: () {
              final snackBar = SnackBar(
                content: Text('Hello, GlobalKey!'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            child: Text('Show Snackbar'),),),
    );
  }
}
