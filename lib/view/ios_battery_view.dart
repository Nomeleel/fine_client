import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IosBatteryView extends StatelessWidget {
  const IosBatteryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final battery = ValueNotifier(77);
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 77,
      fontWeight: FontWeight.bold,
      fontFeatures: [FontFeature.tabularFigures()],
    );

    Widget wrapValueListenableBuilder(Widget Function(int battery) builder) => ValueListenableBuilder<int>(
          valueListenable: battery,
          builder: (context, value, child) => builder(value),
        );

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 150,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  wrapValueListenableBuilder((value) => Text('$value', style: textStyle)),
                  wrapValueListenableBuilder(
                    (value) => ClipRect(
                      clipper: BatteryClipper(value / 100),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: value <= 20 ? Colors.red : Colors.green,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text('$value', style: textStyle.copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            wrapValueListenableBuilder(
              (value) => CupertinoSlider(
                min: 0,
                max: 100,
                value: value.toDouble(),
                onChanged: (value) => battery.value = value.toInt(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BatteryClipper extends CustomClipper<Rect> {
  BatteryClipper(this.battery);
  double battery;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * battery, size.height);
  }

  @override
  bool shouldReclip(BatteryClipper oldClipper) {
    return oldClipper.battery != battery;
  }
}
