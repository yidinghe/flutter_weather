import 'package:flutter/material.dart';
import 'package:weather/forecast/app_bar.dart';
import 'package:weather/forecast/forcast_list.dart';
import 'package:weather/forecast/forecast.dart';
import 'package:weather/forecast/radial_list.dart';
import 'package:weather/forecast/week_drawer.dart';
import 'package:weather/generic_widgets/sliding_drawer.dart';

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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  OpenableController openableController;
  SlidingRadialListController slidingRadialListController;
  String selectedDay = 'Friday, December 28';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Forecast(
            radialList: forecastRadialList,
            slidingRadialListController: slidingRadialListController,
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: ForecastAppBar(
              onDrawerArrowTap: openableController.open,
              selectedDay: selectedDay,
            ),
          ),
          SlidingDrawer(
            openableController: openableController,
            drawer: WeekDrawer(
              onDaySelected: (String title) {
                setState(() {
                  selectedDay = title.replaceAll('\n', ', ');
                });

                slidingRadialListController
                    .close()
                    .then((_) => slidingRadialListController.open());

                openableController.close();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    openableController = OpenableController(
      vsync: this,
      openDuration: Duration(milliseconds: 250),
    )..addListener(() => setState(() {}));

    slidingRadialListController = SlidingRadialListController(
      itemCount: forecastRadialList.items.length,
      vsync: this,
    )..open();
  }
}
