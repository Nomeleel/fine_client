import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../model/lyric.dart';

class LyricsProvider with ChangeNotifier{
  
  int _currentIndex = 0;

  List<LyricItemWidget> _lyricItemWidgetList;
  List<LyricItemWidget> get lyricItemWidgetList => _lyricItemWidgetList;

  final Color fontColor = const Color(0xffffffff);
  final double fontSize = 60;

  Future<void> init() async {
    final Lyric lyric = await _parseLyric();
    _lyricItemWidgetList = lyric.lyricItemList.map<LyricItemWidget>((LyricItem item) {
      return normalLyricItemWidget(item);
    }).toList();
    setCurrentIndex(_currentIndex);
    notifyListeners();
  }

  LyricItemWidget normalLyricItemWidget(LyricItem lyricItem) {
    return LyricItemWidget(lyricItem, fontColor.withOpacity(0.3), fontSize);
  }

  LyricItemWidget activeLyricItemWidget(LyricItem lyricItem) {
    return LyricItemWidget(lyricItem, fontColor, fontSize + 6);
  }

  void onCurrentIndexChanged(int oldIndex, int newIndex) {
    _lyricItemWidgetList[oldIndex] = 
      normalLyricItemWidget(_lyricItemWidgetList[oldIndex].lyricItem);
    _lyricItemWidgetList[newIndex] = 
      activeLyricItemWidget(_lyricItemWidgetList[newIndex].lyricItem);
  }

  void setCurrentIndex(int index) {
    onCurrentIndexChanged(_currentIndex, index);
    _currentIndex = index;
    notifyListeners();
  }

  Duration getNextDuration() {
    final Duration Function(int index) getDuration = 
      (int index) => _lyricItemWidgetList[index].lyricItem.duration;
    return getDuration(_currentIndex + 1) - getDuration(_currentIndex);
  }

  bool isLast() => _currentIndex >= _lyricItemWidgetList.length - 1;

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
          minutes: int.parse(element.namedGroup('min')),
          seconds: int.parse(element.namedGroup('sec')),
          milliseconds: int.parse(element.namedGroup('mil')) * 10,
        ),
        text: element.namedGroup('text'),
      ));
    });

    return lyric;
  }

}

class LyricItemWidget {
  const LyricItemWidget(this.lyricItem, this.fontColor, this.fontSize);

  final LyricItem lyricItem;
  final Color fontColor;
  final double fontSize;
}