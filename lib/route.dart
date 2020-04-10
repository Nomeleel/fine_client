import 'package:flutter/material.dart';

import 'view/sudoku/sudokuView.dart';
import 'view/sudoku/sudokuImageView.dart';
import 'view/sudoku/sudokuManualView.dart';

class Route {
  static Map<String, WidgetBuilder> routes = {
    'sudoku': (BuildContext context) => SudokuView(),
    'sudokuImage': (BuildContext context) => SudokuImageView(),
    'sudokuManual': (BuildContext context) => SudokuManualView(),
  };
}
