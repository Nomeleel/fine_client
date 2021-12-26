import 'package:flutter/widgets.dart';

class SudokuManualProvider with ChangeNotifier {
  SudokuManualProvider({String? fillSudokuStr}) {
    final bool isFillStr = fillSudokuStr != null && fillSudokuStr.length == 81;
    _sudokuCellList = List<SudokuCell>.generate(
        81,
        (int index) => SudokuCell(
            index, isFillStr ? int.parse(fillSudokuStr[index]) : 0, false));
  }

  late List<SudokuCell> _sudokuCellList;
  List<SudokuCell> get sudokuCellList => _sudokuCellList;

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  String get sudokuStr =>
      _sudokuCellList.map((SudokuCell item) => item.digit).join('');

  void selected(int index) {
    if (_selectedIndex == index) {
      unSelected(index);
    } else {
      unSelected(_selectedIndex);
      retSetSudokuCell(index, isSelected: true);
      _selectedIndex = index;
    }

    notifyListeners();
  }

  void unSelected(int index) {
    if (index != -1) {
      retSetSudokuCell(index, isSelected: false);
      _selectedIndex = -1;
    }
  }

  void setDigit(int digit) {
    if (_selectedIndex != -1) {
      retSetSudokuCell(_selectedIndex, digit: digit);

      notifyListeners();
    }
  }

  void retSetSudokuCell(int index, {int? digit, bool? isSelected}) {
    _sudokuCellList[index] = SudokuCell(
        index,
        digit ?? _sudokuCellList[index].digit,
        isSelected ?? _sudokuCellList[index].isSelected);
  }
}

class SudokuCell {
  SudokuCell(this.index, this.digit, this.isSelected);
  final int index;
  int digit;
  bool isSelected;
}
