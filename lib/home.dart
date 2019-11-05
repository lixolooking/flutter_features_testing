import 'package:flutter/material.dart';

class GuideHomeState extends State<GuideHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guide map'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Center(
              child: Text('Home page'),
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Icon(
                        Icons.map
                    ),
                    Text('Map'),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/map');
              },
            ),
          ),
        ]
      ),
    );
  }
}

class GuideHome extends StatefulWidget {
  @override
  GuideHomeState createState() => GuideHomeState();
}