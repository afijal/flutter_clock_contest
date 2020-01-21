// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'drawn_hand.dart';
import 'hand_postions.dart';

class AnalogClock extends StatelessWidget {
  const AnalogClock(this.theme, this.start, this.end);

  final HandPositions start;
  final HandPositions end;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context)
              .size
              .width, //whatever, just maximum available
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
              color: theme.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: theme.accentColor, width: 5)),
        ),
        DrawnHand(
            color: theme.accentColor,
            thickness: 7,
            size: 1,
            startDegrees: start.hour,
            endDegrees: end.hour),
        DrawnHand(
            color: theme.accentColor,
            thickness: 7,
            size: 1,
            startDegrees: start.minutes,
            endDegrees: end.minutes),
      ],
    );
  }
}
