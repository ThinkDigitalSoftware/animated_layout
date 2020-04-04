import 'dart:async';

import 'package:animated_layout/src/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class AnimatedLayoutController {
  StreamController _eventStreamController =
      StreamController<ControllerEvent>.broadcast();
  List<Widget> children;

  List<int> _percentages;

  Duration duration;
  final Curve curve;
  AnimatedLayoutController({
    @required List<int> initialDivisions,
    @required this.duration,
    @required this.children,
    this.curve = Curves.linear,
  })  : assert(duration != null),
        assert(children != null),
        assert(initialDivisions.length == children.length),
        assert(curve != null),
        _percentages = initialDivisions;
  List<int> get divisions => _percentages;

  set divisions(List<int> divisions) {
    assert(numOfDivisions == children.length);
    _percentages = divisions;
  }

  Stream<ControllerEvent> get eventStream => _eventStreamController.stream;

  int get numOfDivisions => divisions.length;

  void animateTo(List<int> newDivisions) {
    final oldDivisions = this.divisions;
    this.divisions = newDivisions;
    _eventStreamController.add(AnimateTo(from: oldDivisions, to: newDivisions));
  }

  void close() => _eventStreamController.close();
}
