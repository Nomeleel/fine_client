import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'body_mass_index/body_mass_index_painter.dart';

class PrizeWheelView extends StatefulWidget {
  const PrizeWheelView({Key key}) : super(key: key);

  @override
  _PrizeWheelViewState createState() => _PrizeWheelViewState();
}

class _PrizeWheelViewState extends State<PrizeWheelView> with SingleTickerProviderStateMixin {
  double paintWidth = .0;
  Offset centerPoint = Offset.zero;
  double speed = .0;

  ValueNotifier<double> turnsValue;

  @override
  void initState() {
    super.initState();

    turnsValue = ValueNotifier<double>(.0);

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      paintWidth = MediaQuery.of(context).size.width - 10.0;
      centerPoint = Offset(paintWidth / 2, paintWidth / 2);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prize Wheel View'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.cyan,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                top: 50.0,
                left: 5.0,
                right: 5.0,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Listener(
                  onPointerDown: (PointerDownEvent event) {
                    speed = .0;
                  },
                  onPointerMove: (PointerMoveEvent event) {
                    final Offset endPoint = event.position;
                    final Offset startPoint = endPoint - event.delta;
                    final double acos = math.acos(cosA(startPoint - centerPoint, endPoint - centerPoint, event.delta));
                    //final double direction;
                    if (acos > speed) {
                      speed = acos;
                    }
                    turnsValue.value += acos;
                  },
                  onPointerUp: (PointerUpEvent event) {
                    print(speed);
                  },
                  child: AnimatedBuilder(
                    animation: turnsValue,
                    builder: (BuildContext context, Widget child) {
                      final Matrix4 transform = Matrix4.rotationZ(turnsValue.value);
                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                    child: CustomPaint(
                      size: Size.square(paintWidth),
                      painter: BodyMassIndexPainter(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.deepOrange,
            ),
          )
        ],
      ),
    );
  }
}

double cosA(
  Offset ab,
  Offset ac,
  Offset bc,
) {
  return (ab.distanceSquared + ac.distanceSquared - bc.distanceSquared) / (2 * ab.distance * ac.distance);
}
