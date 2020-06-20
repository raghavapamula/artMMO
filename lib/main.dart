import 'package:flutter/material.dart';
import 'paint.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "artMMO",
      home: Frame(),
      theme: ThemeData.dark(),
    );
  }
}
