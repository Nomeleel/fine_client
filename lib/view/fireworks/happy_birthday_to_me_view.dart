import 'package:awesome_flutter/custom/painter/fireworks_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HappyBirthdayToMeView extends StatefulWidget {
  const HappyBirthdayToMeView({Key key}) : super(key: key);

  @override
  _HappyBirthdayToMeViewState createState() => _HappyBirthdayToMeViewState();
}

class _HappyBirthdayToMeViewState extends State<HappyBirthdayToMeView> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomPaint(
        size: Size.infinite,
        painter: FireworksPainter(AnimationController(
          duration: const Duration(
            hours: 2,
            seconds: 18,
          ),
          vsync: this,
        )..forward()),
      ),
    );
  }
}
