import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SolitaireView extends StatefulWidget {
  const SolitaireView({Key key}) : super(key: key);

  @override
  _SolitaireViewState createState() => _SolitaireViewState();
}

class _SolitaireViewState extends State<SolitaireView> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomPaint(
        size: Size.infinite,
        painter: SolitairePainter(
          AnimationController(
            duration: const Duration(
              hours: 2,
              seconds: 18,
            ),
            vsync: this,
          )..forward(),
          List<Solitaire>.generate(10, (int i) => Solitaire(Offset(0, i * 0.01))),
        ),
      ),
    );
  }
}

class SolitairePainter extends CustomPainter {
  SolitairePainter(this.repaint, this.solitaireList) : super(repaint: repaint);

  final AnimationController repaint;

  final List<Solitaire> solitaireList;

  Size canvasSize;
  Offset get sourcePosition => Offset(canvasSize.width / 2, canvasSize.height);

  @override
  void paint(Canvas canvas, Size size) {
    canvasSize ??= size;
    canvas.translate(0.0, size.height / 2.0);

    solitaireList.forEach((Solitaire solitaire) {
      solitaire.trajectory.trajectory.forEach((e) {
        canvas.drawRect(e & const Size(10, 20), Paint()..color = Colors.pink);
      });
      solitaire.trajectory.update();
    });
  }

  @override
  bool shouldRepaint(SolitairePainter oldDelegate) => false;
}

class Solitaire {
  Solitaire(Offset position) : trajectory = Trajectory(position);
  final Trajectory trajectory;
}

class Trajectory {
  Trajectory(Offset position) : trajectory = <Offset>[position];

  final List<Offset> trajectory;

  Offset offset = const Offset(100.0, 200.0);

  void update() {
    if (offset.dy <= 1.0) {
      return;
    }

    final double x = trajectory.last.dx + 2.0;
    final double progress = (offset.dx - x) / offset.dy;
    final Offset point = Offset(x, -offset.dy * math.sin(progress * math.pi));
    if (progress > 0.0) {
      trajectory.add(point);
    } else {
      final double dy = offset.dy * 0.7;
      offset = Offset(x + dy, dy);
    }
  }
}
