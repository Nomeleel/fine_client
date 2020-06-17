import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../provider/goldfinger_race_provider.dart';

class GoldfingerRaceView extends StatefulWidget {
  const GoldfingerRaceView({Key key}) : super(key: key);

  @override
  _GoldfingerRaceViewState createState() => _GoldfingerRaceViewState();
}

class _GoldfingerRaceViewState extends State<GoldfingerRaceView> {
  final GoldfingerRaceProvider _provider = GoldfingerRaceProvider();
  
  VoidCallback _onClick;

  @override
  void initState() {
    _onClick = start;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoldfingerRaceProvider>.value(
      value: _provider,
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
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  alignment: Alignment.topLeft,
                  height: 20,
                  color: Colors.purple.withOpacity(0.7),
                  child: Consumer<GoldfingerRaceProvider>(
                    builder: (BuildContext context, GoldfingerRaceProvider value, Widget child) {
                      return AnimatedContainer(
                        duration: value.duration,
                        width: value.isStart ? 0 : MediaQuery.of(context).size.width - 14,
                        decoration: BoxDecoration(
                          color: value.isStart ? Colors.red : Colors.purple,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Consumer<GoldfingerRaceProvider>(
                  builder: (BuildContext context, GoldfingerRaceProvider value, Widget child) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
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
                        '${value.clickedCount}',
                        key: ValueKey<int>(value.clickedCount),
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.purple,
                          fontSize: 100.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ), 
              ),
              RaisedButton(
                onPressed: _onClick,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void start() {
    _provider.start(const Duration(seconds: 6));
    addCount();
    _onClick = addCount;
  }

  void addCount() {
    _provider.addCount();
  }
}
