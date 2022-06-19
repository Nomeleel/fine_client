import 'dart:math' as math;

import 'package:awesome_flutter/util/math_util.dart';
import 'package:flutter/material.dart';

class SolitaireView extends StatefulWidget {
  const SolitaireView({Key? key}) : super(key: key);

  @override
  _SolitaireViewState createState() => _SolitaireViewState();
}

class _SolitaireViewState extends State<SolitaireView> with SingleTickerProviderStateMixin {
  List<Offset> pointList = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Listener(
        onPointerDown: (PointerDownEvent e) {
          debugPrint('$e');
          pointList.add(e.position);
        },
        onPointerMove: (PointerMoveEvent e) {
          pointList.add(e.position);
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: SolitairePainter(
            AnimationController(
              duration: const Duration(
                hours: 2,
                seconds: 18,
              ),
              vsync: this,
            )..forward(),
            pointList,
          ),
          isComplex: true,
          // willChange: true,
        ),
      ),
    );
  }
}

class SolitairePainter extends CustomPainter {
  SolitairePainter(this.repaint, this.pointList) : super(repaint: repaint);

  final AnimationController repaint;

  final List<Offset> pointList;
  static List<Solitaire> solitaireList = <Solitaire>[];

  late Size canvasSize;
  Offset get sourcePosition => Offset(canvasSize.width / 2, canvasSize.height);

  @override
  void paint(Canvas canvas, Size size) {
    canvasSize = size;
    canvas.translate(0.0, size.height);

    solitaireList.addAll(
      pointList.sublist(solitaireList.length).map(
            (Offset e) => Solitaire(
              Offset(e.dx, canvasSize.height - e.dy),
            ),
          ),
    );

    final int removeCount = solitaireList.length - 150;
    if (removeCount > 0) {
      pointList.removeRange(0, removeCount);
      solitaireList.removeRange(0, removeCount);
    }

    // ignore: avoid_function_literals_in_foreach_calls
    solitaireList.forEach((Solitaire solitaire) {
      // ignore: avoid_function_literals_in_foreach_calls
      // solitaire.trajectory.trajectory.forEach((Offset e) {
      Offset e = solitaire.trajectory.trajectory.last;
      final Rect rect = (e - const Offset(0, 70.0)) & const Size(55, 80);
      canvas.drawRect(rect, Paint()..color = solitaire.color);
      canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke,
      );
      // });
      solitaire.trajectory.update();
    });
  }

  @override
  bool shouldRepaint(SolitairePainter oldDelegate) => false;
}

class Solitaire {
  Solitaire(Offset position)
      : trajectory = Trajectory(position),
        color = Color(randomInt(0, 0xFFFFFFFF));
  final Trajectory trajectory;
  final Color color;
}

class Trajectory {
  Trajectory(Offset position)
      : trajectory = <Offset>[position],
        startProgress = random(0.3, 0.5),
        ratio = random(0.5, 0.7),
        direction = math.pow(-1, randomInt(0, 7));

  final List<Offset> trajectory;
  final double startProgress;
  // x / y
  final double ratio;
  final num direction;

  // end min point
  late Offset offset = initOffset();

  Offset initOffset() {
    final double dy = trajectory.first.dy / math.sin(startProgress * math.pi);
    return Offset(trajectory.first.dx + dy * (1.0 - startProgress) * ratio * direction, dy);
  }

  void update() {
    if (offset.dy <= 1.0) {
      return;
    }

    final double x = trajectory.last.dx + 3.0 * direction;
    final double progress = (offset.dx - x) / (offset.dy * ratio) * direction;
    final Offset point = Offset(x, -offset.dy * math.sin(progress * math.pi));
    if (progress > 0.0) {
      trajectory.add(point);
    } else {
      final double dy = offset.dy * 0.7;
      offset = Offset(x + dy * ratio * direction, dy);
    }
  }
}
