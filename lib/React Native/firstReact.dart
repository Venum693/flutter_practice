// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:flutter_redux_demo/navigation/navigation.dart';
// import 'package:flutter_redux_demo/redux/store.dart';
// import 'package:flutter_redux_demo/utils/theme.dart';
// import 'package:redux/redux.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   final Store<AppState> store = createStore(); // Create your Redux store here
//
//   @override
//   Widget build(BuildContext context) {
//     return StoreProvider(
//       store: store,
//       child: MaterialApp(
//         title: 'Flutter Redux Demo',
//         theme: themeData,
//         home: MainScreen(),
//       ),
//     );
//   }
// }
//
// class MainScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Redux Demo'),
//       ),
//       body: Column(
//         children: [
//           // Add your main content here
//           Navigation(), // Assuming Navigation is your main content widget
//           NetworkBanner(), // Your NetworkBanner widget
//         ],
//       ),
//     );
//   }
// }
