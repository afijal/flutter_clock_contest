import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'analog_clock.dart';
import 'hand_postions.dart';

class Digit extends StatefulWidget {
  const Digit(this.theme, this.previousNumber, this.nextNumber);

  final ThemeData theme;
  final int previousNumber;
  final int nextNumber;

  @override
  _DigitState createState() => _DigitState();
}

class _DigitState extends State<Digit> {
  final blank = HandPositions(135.0, 135.0);
  final oneTop = HandPositions(225.0, 180.0);
  final vertical = HandPositions(180.0, 0.0);
  final top = HandPositions(0.0, 0.0);
  final right = HandPositions(90.0, 90.0);
  final bottom = HandPositions(180.0, 180.0);
  final left = HandPositions(270.0, 270.0);
  final leftBottom = HandPositions(270.0, 180.0);
  final leftTop = HandPositions(270.0, 0.0);
  final rightBottom = HandPositions(90.0, 180.0);
  final rightTop = HandPositions(90.0, 0.0);

  //get clock set for number
  List<HandPositions> mapNumberToHandPositions(int number) {
    switch (number) {
      case 0:
        return [rightBottom, leftBottom, vertical, vertical, rightTop, leftTop];
      case 1:
        return [blank, oneTop, blank, vertical, blank, top];
      case 2:
        return [right, leftBottom, rightBottom, leftTop, rightTop, left];
      case 3:
        return [right, leftBottom, right, vertical, right, leftTop];
      case 4:
        return [bottom, bottom, rightTop, leftTop, blank, top];
      case 5:
        return [rightBottom, left, rightTop, leftBottom, right, leftTop];
      case 6:
        return [rightBottom, left, rightBottom, leftBottom, rightTop, leftTop];
      case 7:
        return [right, leftBottom, blank, vertical, blank, top];
      case 8:
        return [
          rightBottom,
          leftBottom,
          rightBottom,
          leftBottom,
          rightTop,
          leftTop
        ];
      case 9:
        return [rightBottom, leftBottom, rightTop, leftTop, right, leftTop];
      default:
        return [blank, blank, blank, blank, blank, blank];
    }
  }

  @override
  Widget build(BuildContext context) {
    final oldClocks = mapNumberToHandPositions(widget.previousNumber);
    final newClocks = mapNumberToHandPositions(widget.nextNumber);

    List<AnalogClock> clocks = new List();
    for (var i = 0; i < oldClocks.length; i++) {
      clocks.add(AnalogClock(widget.theme, oldClocks[i], newClocks[i]));
    }

    return Container(
        width:
            ((MediaQuery.of(context).size.width - 70) / 4).floor().toDouble(),
        height: 500,
        child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            children: clocks));
  }
}
