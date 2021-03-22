import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'body_mass_index/body_mass_index_painter.dart';

class PrizeWheelScrollDriveView extends StatefulWidget {
  const PrizeWheelScrollDriveView({Key key}) : super(key: key);

  @override
  _PrizeWheelScrollDriveViewState createState() => _PrizeWheelScrollDriveViewState();
}

class _PrizeWheelScrollDriveViewState extends State<PrizeWheelScrollDriveView> with SingleTickerProviderStateMixin {
  ScrollController turns;

  double get turnsValue => !turns.hasClients ? .0 : turns.offset / 260.0;
  double paintWidth;

  @override
  void initState() {
    super.initState();
    turns = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      paintWidth = MediaQuery.of(context).size.width - 5.0;
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
                child: Stack(
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: turns,
                      builder: (BuildContext context, Widget child) {
                        final Matrix4 transform = Matrix4.rotationZ(-turnsValue);
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
                      controller: turns,
                      physics: const BouncingScrollPhysics(),
                      itemExtent: 77.77,
                      diameterRatio: 3.14,
                      perspective: 0.01,
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.primaries[index % 15].withOpacity(.2),
                            ),
                          );
                        },
                      ),
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
