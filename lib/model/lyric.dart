class Lyric {
  Lyric({this.lyricItemList});

  final List<LyricItem> lyricItemList;
}

class LyricItem {
  const LyricItem({this.duration, this.text});

  final Duration duration;
  final String text;
}