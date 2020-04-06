import 'dart:async';

import 'package:animated_layout/src/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class AnimatedLayoutController {
  StreamController _eventStreamController =
      StreamController<ControllerEvent>.broadcast();
  List<Widget> _children;

  List<int> _percentages;

  Duration duration;
  final Curve curve;

  List<Widget> get children => _children;

  AnimatedLayoutController({
    @required List<int> initialDivisions,
    @required this.duration,
    @required List<Widget> children,
    this.curve = Curves.linear,
  })  : assert(duration != null),
        assert(children != null),
        _children = children,
        assert(initialDivisions.length == children.length),
        assert(curve != null),
        _percentages = initialDivisions;

  List<int> get divisions => _percentages;

  set divisions(List<int> divisions) {
    assert(numOfDivisions == _children.length);
    _percentages = divisions;
  }

  Stream<ControllerEvent> get eventStream => _eventStreamController.stream;

  int get numOfDivisions => divisions.length;

  void animateTo(List<int> newDivisions) {
    final oldDivisions = this.divisions;
    this.divisions = newDivisions;
    _eventStreamController.add(AnimateTo(from: oldDivisions, to: newDivisions));
  }

  void updateChildren(List<Widget> children) {
    assert(children.length == divisions.length);
    _children = children;
    _eventStreamController.add(UpdateChildren(children));
  }

  void close() => _eventStreamController.close();
}
