import 'package:flutter/widgets.dart';

class SudokuManualProvider with ChangeNotifier {
  
  SudokuManualProvider({String fillSudokuStr}) {
    bool isFillStr = fillSudokuStr != null && fillSudokuStr.length == 81;
    _sudokuCellList = List.generate(81, (index) => SudokuCell(index, 
      (isFillStr ? int.parse(fillSudokuStr[index]) : 0), false));
  }

  List<SudokuCell> _sudokuCellList;
  get sudokuCellList => _sudokuCellList;

  int _selectedIndex = -1;
  get selectedIndex => _selectedIndex;

  get sudokuStr => _sudokuCellList.map((item) => item.digit).join('');

  selected(int index) {
    if (_selectedIndex == index) {
      unSelected(index);
    } else {
      unSelected(_selectedIndex);
      retSetSudokuCell(index, isSelected: true);
      _selectedIndex = index;
    }

    notifyListeners();
  }

  unSelected(int index) {
    if (index != -1) {
      retSetSudokuCell(index, isSelected: false);
      _selectedIndex = -1;
    }
  }

  setDigit(int digit) {
    if (_selectedIndex != -1) {
      retSetSudokuCell(_selectedIndex, digit: digit);

      notifyListeners();
    }
  }

  retSetSudokuCell(int index, {int digit, bool isSelected}) {
    _sudokuCellList[index] = SudokuCell(
        index,
        (digit ?? _sudokuCellList[index].digit),
        (isSelected ?? _sudokuCellList[index].isSelected));
  }
}

class SudokuCell {
  final int index;
  int digit;
  bool isSelected;

  SudokuCell(this.index, this.digit, this.isSelected);
}
