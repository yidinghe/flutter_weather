import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather/generic_widgets/radius_position.dart';

class SlidingRadialList extends StatelessWidget {
  final RadialListViewModel radialList;
  final SlidingRadialListController controller;

  SlidingRadialList({
    this.radialList,
    this.controller,
  });

  List<Widget> _radialListItems() {
    int index = 0;
    return radialList.items.map((RadialListItemViewModel viewModel) {
      final listItem = _radialListItem(
        viewModel,
        controller.getItemAngle(index),
        controller.getItemOpacity(index),
      );
      ++index;
      return listItem;
    }).toList();
  }

  Widget _radialListItem(
      RadialListItemViewModel viewModel, double angle, double opacity) {
    return Transform(
      transform: Matrix4.translationValues(
        40.0,
        334.0,
        0.0,
      ),
      child: RadialPosition(
        radius: 140.0 + 75.0,
        angle: angle,
        child: Opacity(
          opacity: opacity,
          child: RadialListItem(
            listItem: viewModel,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return Stack(
          children: _radialListItems(),
        );
      },
    );
  }
}

class SlidingRadialListController extends ChangeNotifier {
  final double firstItemAngle = -pi / 3;
  final double lastItemAngle = pi / 3;
  final double startSlidingAngle = 3 * pi / 4;

  final int itemCount;
  final AnimationController _slideController;
  final AnimationController _fadeController;
  final List<Animation<double>> _slidePositions;

  Completer<Null> onOpenedCompleter;
  Completer<Null> onClosedCompleter;

  RadialListState _state = RadialListState.closed;

  SlidingRadialListController({
    this.itemCount,
    vsync,
  })  : _slideController = new AnimationController(
          duration: const Duration(milliseconds: 1500),
          vsync: vsync,
        ),
        _fadeController = new AnimationController(
          duration: const Duration(milliseconds: 150),
          vsync: vsync,
        ),
        _slidePositions = [] {
    _slideController
      ..addListener(() => notifyListeners())
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = RadialListState.slidingOpen;
            notifyListeners();
            break;
          case AnimationStatus.completed:
            _state = RadialListState.open;
            notifyListeners();
            onOpenedCompleter.complete();
            break;
          case AnimationStatus.reverse:
          case AnimationStatus.dismissed:
            break;
        }
      });

    _fadeController
      ..addListener(() => notifyListeners())
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = RadialListState.fadingOut;
            notifyListeners();
            break;
          case AnimationStatus.completed:
            _state = RadialListState.closed;
            _slideController.value = 0.0;
            _fadeController.value = 0.0;
            notifyListeners();
            onClosedCompleter.complete();
            break;
          case AnimationStatus.reverse:
          case AnimationStatus.dismissed:
            break;
        }
      });

    final delayInterval = 0.1;
    final slideInterval = 0.5;
    final angleDeltaPerItem =
        (lastItemAngle - firstItemAngle) / (itemCount - 1);
    for (var i = 0; i < itemCount; ++i) {
      final start = delayInterval * i;
      final end = start + slideInterval;

      final endSlidingAngle = firstItemAngle + (angleDeltaPerItem * i);

      _slidePositions.add(
        Tween(
          begin: startSlidingAngle,
          end: endSlidingAngle,
        ).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: Interval(
              start,
              end,
              curve: Curves.easeInOut,
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  double getItemAngle(int index) {
    return _slidePositions[index].value;
  }

  double getItemOpacity(int index) {
    switch (_state) {
      case RadialListState.closed:
        return 0.0;
      case RadialListState.slidingOpen:
      case RadialListState.open:
        return 1.0;
      case RadialListState.fadingOut:
        return (1.0 - _fadeController.value);
      default:
        return 1.0;
    }
  }

  Future<Null> open() {
    if (_state == RadialListState.closed) {
      _slideController.forward();
      onOpenedCompleter = Completer();
      return onOpenedCompleter.future;
    }
    return null;
  }

  Future<Null> close() {
    if (_state == RadialListState.open) {
      _fadeController.forward();
      onClosedCompleter = Completer();
      return onClosedCompleter.future;
    }
    return null;
  }
}

enum RadialListState {
  closed,
  slidingOpen,
  open,
  fadingOut,
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
                  listItem.subtitle,
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
