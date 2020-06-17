import 'dart:async';

import 'package:flutter/widgets.dart';

class GoldfingerRaceProvider with ChangeNotifier {
  int _clickedCount = 0;
  int get clickedCount => _clickedCount;

  CurrentState _state = CurrentState.none;
  CurrentState get state => _state;
  bool get isStart => _state == CurrentState.start;

  Duration _duration = Duration.zero;
  Duration get duration => _duration;

  void start(Duration duration) {
    setDuration(duration);
    _state = CurrentState.start;
    Timer(duration, () {
      _state = CurrentState.end;
    });
    notifyListeners();
  }

  void setDuration(Duration duration) {
    _duration = duration;
  }

  void addCount() {
    if (_state == CurrentState.start) {
      _clickedCount++;
      notifyListeners();
    }
  }
}

enum CurrentState {
  none,
  start,
  end,
}