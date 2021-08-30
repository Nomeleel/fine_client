import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FunnyPunchView extends StatefulWidget {
  const FunnyPunchView({Key key}) : super(key: key);

  @override
  _FunnyPunchViewState createState() => _FunnyPunchViewState();
}

class _FunnyPunchViewState extends State<FunnyPunchView> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 360.0,
          width: 360.0,
          child: Stack(
            children: <Widget>[
              AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget child) {
                  return Align(
                    alignment: Alignment(-cos(controller.value * 2.0 * pi), cos(controller.value * 4.0 * pi)),
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/images/dog.gif',
                  height: 320.0,
                  width: 320.0,
                  fit: BoxFit.cover,
                ),
              ),
              punchBuilder(flag: 1),
              punchBuilder(flag: -1),
            ],
          ),
        ),
      ),
    );
  }

  Widget punchBuilder({int flag = 1}) {
    final double start = 0.25 - flag / 4.0;
    final Animation<double> animation = CurveTween(curve: Interval(start, start + 0.5)).animate(controller);
    final Alignment align = Alignment(-flag.toDouble(), 1.0);
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        final double value = sin(animation.value * pi);
        return Transform(
          alignment: align,
          transform: Matrix4.rotationZ(flag * value * pi * 0.2).scaled(1.0 + value, 1.0 + value * 1.2),
          child: child,
        );
      },
      child: Align(
        alignment: align,
        child: punch(flip: flag == -1),
      ),
    );
  }

  Widget punch({bool flip = false}) {
    final Transform child = Transform(
      alignment: const Alignment(0.3, 0.3),
      transform: Matrix4.rotationZ(-0.3 * pi),
      child: const Text(
        '👊',
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 100.0,
        ),
      ),
    );
    if (flip) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: child,
      );
    }

    return GestureDetector(
      onTap: () {
        if (controller.isAnimating) {
          controller.stop();
        } else {
          controller.repeat();
        }
      },
      child: child,
    );
  }
}
