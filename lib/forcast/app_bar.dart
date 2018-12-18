import 'package:flutter/material.dart';

class ForecastAppBar extends StatelessWidget {
  final Function onDrawerArrowTap;

  ForecastAppBar({this.onDrawerArrowTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Thursday, August 29',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          Text(
            'Sacramento',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: onDrawerArrowTap,
        )
      ],
    );
  }
}
