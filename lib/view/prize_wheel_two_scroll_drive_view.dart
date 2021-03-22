import 'dart:math' as math;

import 'package:awesome_flutter/widget/absorb_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'body_mass_index/body_mass_index_painter.dart';

class PrizeWheelTwoScrollDriveView extends StatefulWidget {
  const PrizeWheelTwoScrollDriveView({Key key}) : super(key: key);

  @override
  _PrizeWheelTwoScrollDriveViewState createState() => _PrizeWheelTwoScrollDriveViewState();
}

class _PrizeWheelTwoScrollDriveViewState extends State<PrizeWheelTwoScrollDriveView> with SingleTickerProviderStateMixin {
  ScrollController turnsV;
  ScrollController turnsH;

  double get turnsOffsetV => !turnsV.hasClients ? .0 : turnsV.offset;
  double get turnsOffsetH => !turnsH.hasClients ? .0 : turnsH.offset;

  ValueNotifier<double> turnsValue;

  double paintWidth;

  @override
  void initState() {
    super.initState();
    turnsV = ScrollController()..addListener(scrollListener);
    turnsH = ScrollController()..addListener(scrollListener);

    turnsValue = ValueNotifier<double>(0.0);

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      paintWidth = MediaQuery.of(context).size.width - 5.0;
      setState(() {});
      turnsH.jumpTo(2.0);
    });
  }

  void scrollListener() {
    turnsValue.value = math.sqrt(math.pow(2, turnsOffsetV / 260.0) + math.pow(2, turnsOffsetH / 260.0));
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
                child: AbsorbStack(
                  absorbIndex: 1,
                  children: <Widget>[
                    AnimatedBuilder(
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
                        size: Size.square(paintWidth ?? .0),
                        painter: BodyMassIndexPainter(),
                      ),
                    ),
                    ListWheelScrollView.useDelegate(
                      controller: turnsV,
                      physics: const BouncingScrollPhysics(),
                      itemExtent: 77.77,
                      diameterRatio: 3.14,
                      perspective: 0.01,
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.primaries[index % 15].withOpacity(.2),
                            ),
                          );
                        },
                      ),
                    ),
                    ListView.builder(
                      controller: turnsH,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemExtent: 77.77,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.primaries[index % 15].withOpacity(.2),
                          ),
                        );
                      },
                    )
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
