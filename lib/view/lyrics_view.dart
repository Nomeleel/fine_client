import 'dart:async';
import 'dart:ui';

import 'package:awesome_flutter/widget/color_picker.dart';
import 'package:awesome_flutter/widget/preferred_orientations.dart';
import 'package:awesome_flutter/widget/side_panel.dart';
import 'package:awesome_flutter/wrapper/cupertino_slider_wrapper.dart';

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
  Widget build(BuildContext context) {
    print('root build');
    return Scaffold(
      body: PreferredOrientations(
        orientations: const <DeviceOrientation>[DeviceOrientation.landscapeRight,],
        child: scaffold(
          child: ChangeNotifierProvider<LyricsProvider>.value(
            value: _provider..init(),
            child: Selector<LyricsProvider, List<LyricItemWidget>>(
              selector: (BuildContext context, LyricsProvider provider) => provider.lyricItemWidgetList,
              builder: (BuildContext context, List<LyricItemWidget> list, Widget child) {
                return list == null ? activityIndicator() : () {
                  _mainTimer = Timer(const Duration(seconds: 1), start);
                  return lyricsListView();
                }();
              },
            ),
          ),
          control: controlPanel(),
        ), 
      ),
    );
  }

  // build ui
  Widget scaffold({Widget child, Widget control}) {
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
            child: child,
          ),
          control,
        ],
      ),
    );
  }

  Widget activityIndicator() {
    return const Center(
      child: CupertinoActivityIndicator(radius: 15,),
    );
  }

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
            print('${DateTime.now()} build: $index');
            return Container(
              alignment: Alignment.center,
              //color: Colors.purple,
              child: Text(
                _provider.lyricItemList[index].text,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.fontColor,
                  height: 1.0,
                  //decoration: TextDecoration.none,
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
        RaisedButton(
          onPressed: () => _provider.setDecoration(fontColor: Colors.black),
          child: const Text('Color'),
        ),
        CupertinoSliderWrapper(
          value: _provider.fontSize,
          min: 10,
          max: 80,
          activeColor: Colors.purple,
          onChanged: (double value) => _provider.setDecoration(fontSize: value),
        ),
      ],
    );
  }

  Widget controlPanel() {
    return SidePanel(
      mainAxisHeight: 330,
      orientation: SidePanelOrientation.end,
      onSwitched: (bool isOpen) {
        isOpen ? cancel() : start();
      },
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          left: 15,
          right: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.8),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            const Text(
              '字体颜色',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            ColorPicker(
              color: _provider.fontColor,
              onColorChanged: (Color color) {
                _provider.setDecoration(fontColor: color);
              },
            ),
            const Text(
              '字体大小',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            CupertinoSliderWrapper(
              value: _provider.fontSize,
              min: 10,
              max: 120,
              activeColor: Colors.purple,
              onChanged: (double value) => _provider.setDecoration(fontSize: value),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> animateToNext() async {
    await _controller.animateToItem(
      ((_controller.hasClients ? _controller.selectedItem : 0) + 1) % _provider.lyricItemWidgetList.length,
      duration: const Duration(seconds: 1),
      curve: Curves.ease,
    );
  }

  void start() {
    if (_mainTimer == null || !_mainTimer.isActive) {
      nextTimer();
    }
  }

  void nextTimer() {
    if (!_provider.isLast()) {
      _mainTimer.cancel();
      _mainTimer = Timer(_provider.getNextDuration(), () async {
        await animateToNext();
        nextTimer();
      });
    }
  }

  void cancel() {
    _mainTimer.cancel();
  }

}
