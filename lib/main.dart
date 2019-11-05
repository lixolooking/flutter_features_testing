import 'package:flutter/material.dart';
import 'home.dart';
import 'routes/guide_map/mobile_guide_map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => GuideHome(),
        '/map': (BuildContext context) => GuideMap(),
      }
    );
  }
}

