import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather/generic_widgets/radius_position.dart';

class RadialList extends StatelessWidget {
  final RadialListViewModel radialList;

  RadialList({
    this.radialList,
  });

  List<Widget> _radialListItems() {
    final double firstItemAngle = -pi / 3;
    final double lastItemAngle = pi / 3;
    final double angleDiffPerItem =
        (lastItemAngle - firstItemAngle) / (radialList.items.length - 1);

    double currAngle = firstItemAngle;

    return radialList.items.map((RadialListItemViewModel viewModel) {
      final listItem = _radialListItem(viewModel, currAngle);
      currAngle += angleDiffPerItem;
      return listItem;
    }).toList();
  }

  Widget _radialListItem(RadialListItemViewModel viewModel, double angle) {
    return Transform(
      transform: Matrix4.translationValues(
        40.0,
        334.0,
        0.0,
      ),
      child: RadialPosition(
        radius: 140.0 + 75.0,
        angle: angle,
        child: RadialListItem(
          listItem: viewModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _radialListItems(),
    );
  }
}

class RadialListItem extends StatelessWidget {
  final RadialListItemViewModel listItem;

  RadialListItem({
    this.listItem,
  });

  @override
  Widget build(BuildContext context) {
    final circleDecoration = listItem.isSelected
        ? BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          )
        : BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: new Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          );

    return Transform(
      transform: Matrix4.translationValues(-30.0, -30.0, 0.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 60.0,
            height: 60.0,
            decoration: circleDecoration,
            child: Padding(
              padding: EdgeInsets.all(7.0),
              child: Image(
                  image: listItem.icon,
                  color:
                      listItem.isSelected ? Color(0xFF6688CC) : Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  listItem.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  listItem.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RadialListViewModel {
  final List<RadialListItemViewModel> items;

  RadialListViewModel({
    this.items = const [],
  });
}

class RadialListItemViewModel {
  final ImageProvider icon;
  final String title;
  final String subtitle;
  final bool isSelected;

  RadialListItemViewModel({
    this.icon,
    this.title = '',
    this.subtitle = '',
    this.isSelected = false,
  });
}
