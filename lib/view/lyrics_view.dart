import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/lyrics_provider.dart';

class LyricsView extends StatefulWidget {
  const LyricsView({Key key}) : super(key: key);

  @override
  _LyricsViewState createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  final LyricsProvider _provider = LyricsProvider();
  final FixedExtentScrollController _controller = FixedExtentScrollController();
  Timer _mainTimer;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/images/Mojito.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 7,
              sigmaY: 7,
            ),
            child: ChangeNotifierProvider<LyricsProvider>.value(
              value: _provider..init(),
              child: Selector<LyricsProvider, List<LyricItemWidget>>(
                selector: (BuildContext context, LyricsProvider provider) => provider.lyricItemWidgetList,
                builder: (BuildContext context, List<LyricItemWidget> list, Widget child) {
                  return list == null ?
                    const Center(
                      child: CupertinoActivityIndicator(radius: 15,),
                    ) :
                    Stack(
                      children: <Widget>[
                        lyricsListView(),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: MediaQueryData.fromWindow(window).padding.bottom,
                          child: controlBar(context),
                        ),
                      ],
                    );
                }, 
              ),
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
        _provider.lyricItemWidgetList.length,
        (int index) => Selector<LyricsProvider, LyricItemWidget>(
          selector: (BuildContext context, LyricsProvider provider) => _provider.lyricItemWidgetList[index],
          builder: (BuildContext context, LyricItemWidget widget, Widget child) {
            print('build: $index');
            return Container(
              alignment: Alignment.center,
              //color: Colors.purple,
              child: Text(
                widget.lyricItem.text,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.fontColor,
                ),
              ),
            );
          },
        )
      ),
      onSelectedItemChanged: (int index) {
        _provider.setCurrentIndex(index);
      },
    );
  }

  Widget controlBar(BuildContext context) {
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

  Future<void> animateToNext() async {
    if (_provider.isLast()) {
      cancel();
    } else {
      await _controller.animateToItem(
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
    if (!_provider.isLast()) {
      _mainTimer = Timer(_provider.getNextDuration(), () async {
        await animateToNext();
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
