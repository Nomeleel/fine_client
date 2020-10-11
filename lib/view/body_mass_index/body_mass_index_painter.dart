import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BodyMassIndexPainter extends CustomPainter {
  double _painterRadius;

  // style
  // 依据转盘结果适当改变颜色
  final Color _textColor = Colors.white;
  final Color _backgroundColor = Colors.blue.withOpacity(0.5);
  final Color _backgroundHighlightColor = Colors.blue;
  final Color _borderColor = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    _painterRadius = size.width / 2;

    canvas.translate(_painterRadius, _painterRadius);
    _drawBackground(canvas);

    final double weightRadius = size.width / 2 * 0.9;

    for (int i = 0; i < 120; i++) {
      final double width = weightRadius / 195 + (i % 5 == 0 ? 2.0 : 0.0);
      final double height = weightRadius / 27 + (i % 5 == 0 ? 5.0 : 0.0);

      canvas.drawRect(
          Rect.fromCenter(
            center: Offset(0, -weightRadius * 0.7 - (height / 2)),
            width: width,
            height: height,
          ),
          Paint()..color = _textColor);

      canvas.rotate(-pi * 2 / 120);
    }

    for (int i = 0; i < 12; i++) {
      final TextPainter painter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            color: _textColor,
            fontSize: weightRadius / 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(
          -painter.width / 2,
          -weightRadius + weightRadius / 18,
        ),
      );

      canvas.rotate(-pi * 2 / 12);
    }

    canvas.restore();
  }

  void _drawBackground(Canvas canvas) {
    final Rect fullCircleRect = Rect.fromCircle(center: Offset.zero, radius: _painterRadius);
    final ui.Gradient gradient = ui.Gradient.radial(
      fullCircleRect.center,
      _painterRadius,
      <Color>[_backgroundHighlightColor, _backgroundColor],
      const <double>[0, .7],
    );

    canvas.drawOval(
        fullCircleRect,
        Paint()
          ..style = PaintingStyle.fill
          ..shader = gradient);

    canvas.drawOval(
        fullCircleRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = _borderColor
          ..strokeWidth = 0.3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
