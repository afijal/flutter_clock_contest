// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' show radians;
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class DrawnHand extends StatefulWidget {
  final Color color;
  final double size;
  final double startDegrees;
  final double endDegrees;
  final double thickness;

  final ClockModel model;

  const DrawnHand(
      {Key key,
      this.color,
      this.size,
      this.startDegrees,
      this.endDegrees,
      this.thickness,
      this.model})
      : super(key: key);

  @override
  _DrawnHandState createState() => _DrawnHandState();
}

class _DrawnHandState extends State<DrawnHand> {
  Timer _timer;
  double _currentDegrees;
  var _startBigger = false;

  @override
  void initState() {
    super.initState();
    _setInitData();
    _updateDegrees();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setInitData() {
    if (widget.startDegrees > widget.endDegrees) {
      _startBigger = true;
    } else {
      _startBigger = false;
    }
    _currentDegrees = widget.startDegrees;
  }

  @override
  void didUpdateWidget(DrawnHand oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startDegrees != oldWidget.startDegrees ||
        widget.endDegrees != oldWidget.endDegrees) {
      _setInitData();
      _updateDegrees();
    }
  }

  void _updateDegrees() {
    setState(() {
      if (_startBigger) {
        if (_currentDegrees > widget.endDegrees + 360.0) {
          _currentDegrees = widget.endDegrees + 360.0;
          return;
        }
      } else {
        if (_currentDegrees > widget.endDegrees) {
          _currentDegrees = widget.endDegrees;
          return;
        }
      }
      _currentDegrees += 1.0;
      // Update in 60 fps
      _timer = Timer(
        Duration(milliseconds: (1000 / 60).floor()),
        _updateDegrees,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            handSize: widget.size,
            lineWidth: widget.thickness,
            angleRadians: radians(_currentDegrees),
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws a clock hand.
class _HandPainter extends CustomPainter {
  _HandPainter({
    @required this.handSize,
    @required this.lineWidth,
    @required this.angleRadians,
    @required this.color,
  })  : assert(handSize != null),
        assert(lineWidth != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double lineWidth;
  double angleRadians;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;
    final length = size.shortestSide * 0.38 * handSize;
    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(center, position, linePaint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
