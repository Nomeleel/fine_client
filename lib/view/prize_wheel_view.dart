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
  ScrollController turns;
  Widget prizeWheelPaint;

  double get turnsValue => !turns.hasClients ? .0 : turns.offset / 300.0;
  double paintWidth;

  @override
  void initState() {
    super.initState();
    turns = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      paintWidth = MediaQuery.of(context).size.width - 5.0;
      print(paintWidth);
      prizeWheelPaint = CustomPaint(
        size: Size.square(paintWidth),
        painter: BodyMassIndexPainter(),
      );
      turns.jumpTo(12345.0);
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
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                top: 50.0,
                left: 5.0,
                right: 5.0,
              ),
              decoration: const BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.all(
                  Radius.circular(500.0),
                ),
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: turns,
                      builder: (BuildContext context, Widget child) {
                        final Matrix4 transform = Matrix4.rotationZ(turnsValue);
                        return Transform(
                          transform: transform,
                          alignment: Alignment.center,
                          child: prizeWheelPaint,
                        );
                      },
                    ),
                    ListView.builder(
                      controller: turns,
                      itemCount: 777,
                      itemExtent: 77.77,
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.primaries[index % 15].withOpacity(.2),
                          ),
                        );
                      },
                    ),
                  ],
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
