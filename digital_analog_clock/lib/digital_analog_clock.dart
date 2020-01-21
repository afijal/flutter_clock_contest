// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'digit.dart';

/// Digital clock made of analog clocks
class DigitalAnalogClock extends StatefulWidget {
  const DigitalAnalogClock(this.model);

  final ClockModel model;

  @override
  _DigitalAnalogClockState createState() => _DigitalAnalogClockState();
}

// TODO: add temperature (idk what about temperatures below 0 or higher than 99)
class _DigitalAnalogClockState extends State<DigitalAnalogClock> {
  var _now;
  var _prev;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _prev = _now;
      _now = DateTime.now();
      // Update once per 10 seconds is enough.
      _timer = Timer(
        Duration(seconds: 10) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  //gets nth number from time e.g. _getNumberFromTime(2, 21:34) -> 3
  int _getNumberFromTime(int ordinal, DateTime time) {
    if (time == null) {
      return -1;
    }
    switch (ordinal) {
      case 0:
        return (time.hour / 10).floor();
      case 1:
        return time.hour % 10;
      case 2:
        return (time.minute / 10).floor();
      case 3:
        return time.minute % 10;
      default:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hms().format(DateTime.now());
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            primaryColor: Colors.white,
            accentColor: Colors.black87,
            backgroundColor: Colors.amber[400],
          )
        : Theme.of(context).copyWith(
            primaryColor: Colors.black54,
            accentColor: Colors.white60,
            backgroundColor: Colors.black87,
          );

    return Semantics.fromProperties(
        properties: SemanticsProperties(
          label: 'Analog clock with time $time',
          value: time,
        ),
        child: Center(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.only(top: 120, bottom: 120),
              color: customTheme
                  .backgroundColor, //TODO: color based on theme brightness
              child: Row(
                children: <Widget>[
                  Digit(customTheme, _getNumberFromTime(0, _prev),
                      _getNumberFromTime(0, _now)),
                  Digit(customTheme, _getNumberFromTime(1, _prev),
                      _getNumberFromTime(1, _now)),
                  Digit(customTheme, _getNumberFromTime(2, _prev),
                      _getNumberFromTime(2, _now)),
                  Digit(customTheme, _getNumberFromTime(3, _prev),
                      _getNumberFromTime(3, _now))
                ],
              )),
        ));
  }
}
