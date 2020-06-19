import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LyricsView extends StatefulWidget {
  const LyricsView({Key key}) : super(key: key);

  @override
  _LyricsViewState createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  
  FixedExtentScrollController _controller;
  Timer _mainTimer;
  List<String> _lyricsList;
  bool get _isCancel => _controller.selectedItem >= _lyricsList.length - 1;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeRight,
    ]);
    _controller = FixedExtentScrollController();
    _lyricsList = List<String>.generate(5, (int index) => '$index $index $index');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/images/SaoSiMing.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 7,
              sigmaY: 7,
            ),
            child: Stack(
              children: <Widget>[
                lyricsListView(),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQueryData.fromWindow(window).padding.bottom,
                  child: controlBar(),
                ),
              ],
            ),
          ),
        ],
      ), 
    );
  }

  // build ui
  Widget lyricsListView() {
    return ListWheelScrollView(
      controller: _controller,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.0001,
      itemExtent: MediaQuery.of(context).size.height / 3,
      children: List<Widget>.generate(
        _lyricsList.length,
        (int index) => Container(
          alignment: Alignment.center,
          //color: Colors.purple,
          child: Text(
            _lyricsList[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 3,
              color: ((_controller.hasClients ? _controller.selectedItem : 0) == index) ? 
                Colors.white : 
                Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ),
      onSelectedItemChanged: (int index) {
        setState(() {
          
        });
      },
    );
  }


  Widget controlBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget> [
        RaisedButton(
          onPressed: animateToNext,
          child: const Text('Next'),
        ),
        RaisedButton(
          onPressed: start,
          child: const Text('Start'),
        ),
        RaisedButton(
          onPressed: cancel,
          child: const Text('End'),
        ),
      ],
    );
  }

  void animateToNext() {
    if (_isCancel) {
      cancel();
    } else {
      _controller.animateToItem(
        _controller.selectedItem + 1,
        duration: const Duration(seconds: 1),
        curve: Curves.ease,
      );
    }
  }

  void start() {
    if (_mainTimer == null || !_mainTimer.isActive) {
      nextTimer();
    }
  }

  void nextTimer() {
    if (!_isCancel) {
      _mainTimer = Timer(Duration(seconds: Random().nextInt(5)), () {
        animateToNext();
        nextTimer();
      });
    }
  }

  void cancel() {
    _mainTimer.cancel();
  }

  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    //   DeviceOrientation.portraitUp,
    // ]);

    super.dispose();
  }
}
