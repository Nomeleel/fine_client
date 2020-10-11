import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'body_mass_index_painter.dart';

class BodyMassIndexView extends StatefulWidget {
  const BodyMassIndexView({Key key}) : super(key: key);

  @override
  _BodyMassIndexViewState createState() => _BodyMassIndexViewState();
}

class _BodyMassIndexViewState extends State<BodyMassIndexView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.cyan,
            padding: const EdgeInsets.only(
              top: 50.0,
              left: 5.0,
              right: 5.0,
            ),
            child: CustomPaint(
              size: const Size.fromHeight(50),
              painter: BodyMassIndexPainter(),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.deepOrange,
          ),
        )
      ],
    );
  }
}
