import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../model/lyric.dart';

class LyricsProvider with ChangeNotifier{
  
  int _currentIndex = 0;

  late List<LyricItem> _lyricItemList;
  List<LyricItem> get lyricItemList => _lyricItemList;

  late List<LyricItemWidget> _lyricItemWidgetList;
  List<LyricItemWidget> get lyricItemWidgetList => _lyricItemWidgetList;

  Color _fontColor = const Color(0xffffffff);
  Color get fontColor => _fontColor;

  double _fontSize = 60;
  double get fontSize => _fontSize;

  Future<void> init() async {
    final Lyric lyric = await _parseLyric();
    _lyricItemList = lyric.lyricItemList;
    generateLyricItemWidgetList();
    
    notifyListeners();
  }

  void generateLyricItemWidgetList() {
    // Only created on the first load and refresh the lyric list page.
    _lyricItemWidgetList = List<LyricItemWidget>.filled(_lyricItemList.length, normalLyricItemWidget());

    _lyricItemWidgetList[_currentIndex] = activeLyricItemWidget();
  }

  LyricItemWidget normalLyricItemWidget() {
    return LyricItemWidget(_fontColor.withOpacity(0.3), _fontSize);
  }

  LyricItemWidget activeLyricItemWidget() {
    return LyricItemWidget(_fontColor, _fontSize + 6);
  }

  void onCurrentIndexChanged(int oldIndex, int newIndex) {
    _lyricItemWidgetList[oldIndex] = normalLyricItemWidget();
    _lyricItemWidgetList[newIndex] = activeLyricItemWidget();
  }

  void setCurrentIndex(int index) {
    onCurrentIndexChanged(_currentIndex, index);
    _currentIndex = index;
    notifyListeners();
  }

  Duration getNextDuration() {
    final Duration Function(int index) getDuration = 
      (int index) => _lyricItemList[index].duration;
    return getDuration(_currentIndex + 1) - getDuration(_currentIndex);
  }

  bool isLast() => _currentIndex >= _lyricItemWidgetList.length - 1;

  void setDecoration({Color? fontColor, double? fontSize}) {
    if (fontColor == null && fontSize == null) {
      return;
    }
    
    _fontColor = fontColor ?? _fontColor;
    _fontSize = fontSize ?? _fontSize;
    generateLyricItemWidgetList();
    
    notifyListeners();
  }

  Future<Lyric> _parseLyric() async {
    final String lyricStr = await rootBundle.loadString('assets/lyrics/Mojito.lrc');
    final RegExp regExp = RegExp(
      r'\[(?<min>\d{2}):(?<sec>\d{2}).(?<mil>\d{2})](?<text>.*)', 
      multiLine: true,
    );
    final Lyric lyric = Lyric(lyricItemList: <LyricItem>[]);

    regExp.allMatches(lyricStr).forEach((RegExpMatch element) { 
      lyric.lyricItemList.add(LyricItem(
        duration: Duration(
          minutes: int.parse(element.namedGroup('min')!),
          seconds: int.parse(element.namedGroup('sec')!),
          milliseconds: int.parse(element.namedGroup('mil')!) * 10,
        ),
        text: element.namedGroup('text')!,
      ));
    });

    return lyric;
  }

}

class LyricItemWidget {
  const LyricItemWidget(this.fontColor, this.fontSize);

  final Color fontColor;
  final double fontSize;
}