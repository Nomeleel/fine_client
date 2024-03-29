import 'dart:async';

import 'package:flutter/widgets.dart';

class GoldfingerRaceProvider with ChangeNotifier {
  GoldfingerRaceProvider() {
    _init();
  }

  late int _clickedCount;
  int get clickedCount => _clickedCount;

  late CurrentState _state;

  bool get isStart => _state != CurrentState.none;

  late Duration _duration;
  Duration get duration => _duration;

  late VoidCallback _onClick;
  VoidCallback get onClick => _onClick;

  void _init() {
    _clickedCount = 0;
    _state = CurrentState.none;
    _duration = const Duration(seconds: 30);
    _onClick = _start;
  }

  void _start() {
    _state = CurrentState.start;
    _onClick = _addCount;
    _clickedCount = 1;
    Timer(duration, () {
      //_onClick = _end;
      _onClick = _reStart;
      _state = CurrentState.end;
      notifyListeners();
    });
    notifyListeners();
  }

  void _reStart() {
    _init();
    notifyListeners();
  }

  void setDuration(Duration duration) {
    _duration = duration;
  }

  void _addCount() {
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
