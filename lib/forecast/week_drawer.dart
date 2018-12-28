import 'package:flutter/material.dart';
import 'dart:ui';

class WeekDrawer extends StatelessWidget {
  final week = [
    'Saturday\nDecember 29',
    'Sunday\nDecember 30',
    'Monday\nDecember 31',
    'Tuesday\nJanuary 1',
    'Wednesday\nJanuary 2',
    'Thursday\nJanuary 3',
    'Friday\nJanuary 4',
  ];

  final Function(String title) onDaySelected;

  WeekDrawer({
    this.onDaySelected,
  });

  List<Widget> _buildDayButtons() {
    return week.map((String title) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            onDaySelected(title);
          },
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: RectClipper(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Container(
          width: 125.0,
          height: double.infinity,
          color: Color(0xAA234060),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 40.0,
                ),
              ),
            ]..addAll(_buildDayButtons()),
          ),
        ),
      ),
    );
  }
}

class RectClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
