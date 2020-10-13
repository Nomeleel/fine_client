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

    canvas.rotate(-pi * 0.75);

    for (int i = 0; i <= 90; i++) {
      final double width = weightRadius / 195 + (i % 5 == 0 ? 2.0 : 0.0);
      final double height = weightRadius / 27 + (i % 5 == 0 ? 5.0 : 0.0);

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(0, -weightRadius * 0.7 - (height / 2)),
          width: width,
          height: height,
        ),
        Paint()..color = _textColor,
      );

      if (i % 10 == 0) {
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
      }

      canvas.rotate(pi * 2 / 120);
    }

    canvas.rotate(-pi * 2 / 120);
    _drawHeightPanel(canvas);

    canvas.restore();
  }

  void _drawHeightPanel(Canvas canvas) {
    _drawHeightBackground(canvas);

    final double heightRadius = _painterRadius * 0.6;

    canvas.rotate(pi * 0.75);

    for (int i = 0; i <= 60; i++) {
      final double height = heightRadius / 27 + (i % 5 == 0 ? 5.0 : 0.0);

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(0, -heightRadius + (height / 2)),
          width: heightRadius / 195 + (i % 5 == 0 ? 2.0 : 0.0),
          height: height,
        ),
        Paint()..color = _textColor,
      );

      if (i % 10 == 0) {
        final TextPainter painter = TextPainter(
          text: TextSpan(
            text: '$i',
            style: TextStyle(
              color: _textColor,
              fontSize: heightRadius / 9,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        painter.layout();
        painter.paint(
          canvas,
          Offset(
            -painter.width / 2,
            -heightRadius + heightRadius / 7,
          ),
        );
      }

      canvas.rotate(pi * 2 / 120);
    }
  }

  void _drawHeightBackground(Canvas canvas) {
    final double heightPanelRadius = _painterRadius * 0.6;
    final Rect fullCircleRect = Rect.fromCircle(center: Offset.zero, radius: heightPanelRadius);
    final ui.Gradient gradient = ui.Gradient.radial(
      fullCircleRect.center,
      heightPanelRadius,
      <Color>[_backgroundHighlightColor, _backgroundColor],
      const <double>[0, .7],
    );

    final Path sectorPath = Path.combine(
      PathOperation.difference,
      Path()
        ..addArc(Rect.fromCircle(center: Offset.zero, radius: heightPanelRadius * 0.8), 0, -pi * 0.5)
        ..lineTo(0, 0),
      Path()
        ..addArc(Rect.fromCircle(center: Offset.zero, radius: heightPanelRadius * 0.6), 0, -pi * 0.5)
        ..lineTo(0, 0),
    );

    final Path heightPath = Path.combine(PathOperation.difference, Path()..addOval(fullCircleRect), sectorPath);

    canvas.drawPath(
      heightPath,
      Paint()
        ..style = PaintingStyle.fill
        ..shader = gradient,
    );
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
