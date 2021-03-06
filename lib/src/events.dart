import 'package:flutter/cupertino.dart';

abstract class ControllerEvent {}

class AnimateTo extends ControllerEvent {
  final List<int> to;
  final List<int> from;

  AnimateTo({@required this.from, @required this.to});
}

class UpdateChildren extends ControllerEvent {
  final List<Widget> children;

  UpdateChildren(this.children);
}
