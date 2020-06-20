import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
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
  Lyric _lyric;
  bool get _isCancel => _controller.selectedItem >= _lyric.lyricItemList.length - 1;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeRight,
    ]);
    _controller = FixedExtentScrollController();
    Future<void>.delayed(Duration.zero, () async {
      _lyric = await parseLyric();
      setState(() {

      });
    });
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
            child: _lyric == null ?
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
        _lyric.lyricItemList.length,
        (int index) => Container(
          alignment: Alignment.center,
          //color: Colors.purple,
          child: Text(
            _lyric.lyricItemList[index].text,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              fontSize: 66,
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
      final Duration duration = _lyric.lyricItemList[_controller.selectedItem + 1].duration - 
        _lyric.lyricItemList[_controller.selectedItem].duration;
      _mainTimer = Timer(duration, () {
        animateToNext();
        nextTimer();
      });
    }
  }

  void cancel() {
    _mainTimer.cancel();
  }

  Future<Lyric> parseLyric() async {
    final String lyricStr = await rootBundle.loadString('assets/lyrics/Mojito.lrc');
    final RegExp regExp = RegExp(
      r'\[(?<min>\d{2}):(?<sec>\d{2}).(?<mil>\d{2})](?<text>.*)', 
      multiLine: true,
    );
    final Lyric lyric = Lyric(lyricItemList: <LyricItem>[]);

    regExp.allMatches(lyricStr).forEach((RegExpMatch element) { 
      lyric.lyricItemList.add(LyricItem(
        duration: Duration(
          minutes: int.parse(element.namedGroup('min')),
          seconds: int.parse(element.namedGroup('sec')),
          milliseconds: int.parse(element.namedGroup('mil')) * 10,
        ),
        text: element.namedGroup('text'),
      ));
    });

    return lyric;
  }

  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    //   DeviceOrientation.portraitUp,
    // ]);

    super.dispose();
  }
}

class Lyric {
  Lyric({this.lyricItemList});

  final List<LyricItem> lyricItemList;
}

class LyricItem {
  const LyricItem({this.duration, this.text});

  final Duration duration;
  final String text;
}