import 'package:flutter/material.dart';
import 'package:weather/forcast/app_bar.dart';
import 'package:weather/forcast/background/background_with_rings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          BackgroundWithRings(),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: ForecastAppBar(),
          ),
        ],
      ),
    );
  }
}
