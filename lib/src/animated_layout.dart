import 'package:animated_layout/animated_layout.dart';
import 'package:animated_layout/src/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AnimatedLayout extends StatefulWidget {
  final AnimatedLayoutController controller;
  final Axis direction;

  AnimatedLayout({
    Key key,
    @required this.controller,
    @required this.direction,
  })  : assert(controller != null),
        super(key: key);

  @override
  _AnimatedLayoutState createState() => _AnimatedLayoutState();
}

class _AnimatedLayoutState extends State<AnimatedLayout>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _listen(animatedLayoutController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double dimension =
            isHorizontal ? constraints.maxWidth : constraints.maxHeight;
        return Flex(direction: widget.direction, children: <Widget>[
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  children: <Widget>[
                    for (int i = 0; i < children.length; i++)
                      AnimatedContainer(
                        duration: animatedLayoutController.duration,
                        curve: animatedLayoutController.curve,
                        width: isHorizontal
                            ? _getConstraint(
                                animatedLayoutController.divisions[i],
                                dimension,
                              )
                            : null,
                        height: !isHorizontal
                            ? _getConstraint(
                                animatedLayoutController.divisions[i],
                                dimension,
                              )
                            : null,
                        child: animatedLayoutController.children[i],
                      ),
                  ],
                );
              },
            ),
          ),
        ]);
      },
    );
  }

  AnimatedLayoutController get animatedLayoutController => widget.controller;

  List<Widget> get children => animatedLayoutController.children;

  bool get isHorizontal => widget.direction == Axis.horizontal;

  double _getConstraint(num part, num availableSpace) {
    final total = animatedLayoutController.divisions
        .reduce((value, element) => value + element);
    final percentage = _toPercentage(part, total);
    return _toPixels(percentage, availableSpace);
  }

  double _toPercentage(value, total) => value / total;

  double _toPixels(value, totalPixels) => value * totalPixels;

  void _listen(AnimatedLayoutController animatedLayoutController) async {
    animatedLayoutController.eventStream.listen((event) {
      if (event is AnimateTo) {
        setState(() {});
      } else if (event is UpdateChildren) {
        setState(() {});
      }
    });
  }
}
