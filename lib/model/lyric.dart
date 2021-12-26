class Lyric {
  Lyric({required this.lyricItemList});

  final List<LyricItem> lyricItemList;
}

class LyricItem {
  const LyricItem({required this.duration, required this.text});

  final Duration duration;
  final String text;
}