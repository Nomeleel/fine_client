import 'dart:io';
import 'dart:ui';

import 'package:awesome_flutter/custom/animation/gesture_scale_transition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/goldfinger_race_provider.dart';

// TODO(Nomeleel): 新出的数字先变大更好 不然点击太快 初始太小 看不清楚
class GoldfingerRaceView extends StatelessWidget {
  const GoldfingerRaceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    // ignore: close_sinks
    late Socket? socket;
    int count = 0;
    return ChangeNotifierProvider<GoldfingerRaceProvider>(
      create: (BuildContext context) => GoldfingerRaceProvider(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQueryData.fromWindow(window).padding.top,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.topLeft,
                  height: 20,
                  color: Colors.purple.withOpacity(0.7),
                  child: Selector<GoldfingerRaceProvider, bool>(
                    selector: (BuildContext context, GoldfingerRaceProvider provider) => provider.isStart,
                    builder: (BuildContext context, bool isStart, Widget? child) {
                      return AnimatedContainer(
                        duration: isStart
                            ? Provider.of<GoldfingerRaceProvider>(context, listen: false).duration
                            : Duration.zero,
                        width: isStart ? 0 : MediaQuery.of(context).size.width - 14,
                        decoration: BoxDecoration(
                          color: isStart ? Colors.red : Colors.purple,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Consumer<GoldfingerRaceProvider>(
                  builder: (BuildContext context, GoldfingerRaceProvider provider, Widget? child) {
                    return AnimatedSwitcher(
                      duration: const Duration(seconds: 2),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        '${provider.clickedCount}',
                        key: ValueKey<int>(provider.clickedCount),
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.purple,
                          fontSize: 150.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Selector<GoldfingerRaceProvider, VoidCallback>(
                selector: (BuildContext context, GoldfingerRaceProvider provider) => provider.onClick,
                builder: (BuildContext context, VoidCallback onClick, Widget? child) {
                  return GestureScaleTransition(
                    callBack: onClick,
                    minScale: 0.5,
                    duration: const Duration(milliseconds: 150),
                    child: const Icon(
                      Icons.favorite,
                      size: 77,
                      color: Colors.purple,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 77,
              ),
              ElevatedButton(
                onPressed: () async {
                  socket ??= await Socket.connect('192.168.1.8', 12345);
                  socket?.writeln('${count++}');
                  await socket?.flush();
                },
                child: const Text('Go'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // ignore: close_sinks
                  final Socket socket = await Socket.connect('192.168.1.8', 12345);
                  socket.writeln('${count++}');
                  await socket.flush();
                },
                child: const Text('Go'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
