import 'dart:async';
import 'dart:math' as math;

import 'package:awesome_flutter/util/math_util.dart';
import 'package:flutter/material.dart';

class SolitaireView extends StatelessWidget {
  const SolitaireView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SolitaireList solitaireList = SolitaireList(screenSize: MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: Colors.green,
      body: Listener(
        onPointerDown: (PointerDownEvent e) => solitaireList.addSolitaire(e.position),
        onPointerMove: (PointerMoveEvent e) {
          if (e.delta.distance > 22.0) {
            solitaireList.addSolitaire(e.position);
          }
        },
        child: AnimatedBuilder(
          animation: solitaireList,
          builder: (_, __) {
            return Stack(
              children: <Widget>[
                Positioned.fill(child: Container(color: Colors.pink)),
                for (Solitaire item in solitaireList.solitaireList) RepaintBoundary(child: item)
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => solitaireList.clear(),
        child: const Text('Clear'),
      ),
    );
  }
}

class SolitaireList extends ChangeNotifier {
  SolitaireList({required this.screenSize});

  final Size screenSize;
  final List<Solitaire> solitaireList = <Solitaire>[];

  void addSolitaire(Offset position) {
    solitaireList.add(Solitaire(Offset(position.dx, screenSize.height - position.dy)));
    if (solitaireList.length > 77) {
      solitaireList.removeRange(0, solitaireList.length - 77);
    }
    notifyListeners();
  }

  void clear() {
    solitaireList.clear();
    notifyListeners();
  }
}

class Solitaire extends StatelessWidget {
  Solitaire(Offset position, {Key? key})
      : trajectory = Trajectory(position),
        color = Color(randomInt(0, 0xFFFFFFFF)),
        super(key: key);

  final Color color;
  final Trajectory trajectory;
  final List<Positioned> positionedList = <Positioned>[];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: trajectory,
      builder: (_, __) {
        positionedList.addAll(trajectory.trajectory.sublist(positionedList.length).map(map));
        final Stack child = Stack(
          children: positionedList,
        );
        scheduleMicrotask(() => trajectory.update());
        return child;
      },
    );
  }

  Positioned map(Offset offset) {
    return Positioned(
      left: offset.dx,
      bottom: offset.dy,
      child: Container(
        width: 55.0,
        height: 80.0,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }
}

class Trajectory extends ChangeNotifier {
  Trajectory(Offset position)
      : trajectory = <Offset>[position],
        startProgress = random(0.3, 0.5),
        ratio = random(0.3, 0.4),
        direction = math.pow(-1, randomInt(1, 7));

  final List<Offset> trajectory;
  final double startProgress;
  // x / y
  final double ratio;
  final num direction;

  // end min point
  Offset? offset;

  void update() {
    if (offset == null) {
      final double dy = trajectory.first.dy / math.sin(startProgress * math.pi);
      offset = Offset(trajectory.first.dx + dy * (1.0 - startProgress) * ratio * direction, dy);
    }

    if (offset!.dy <= 1.0) {
      return;
    }

    final double x = trajectory.last.dx + 3.0 * direction;
    final double progress = (offset!.dx - x) / (offset!.dy * ratio) * direction;
    final Offset point = Offset(x, offset!.dy * math.sin(progress * math.pi));
    if (progress > 0.0) {
      trajectory.add(point);
    } else {
      final double dy = offset!.dy * 0.6;
      offset = Offset(x + dy * ratio * direction, dy);
    }
    notifyListeners();
  }
}
