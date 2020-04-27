import 'package:flutter/material.dart';

import 'view/sudoku/sudoku_view.dart';
import 'view/sudoku/sudoku_image_view.dart';
import 'view/sudoku/sudoku_manual_view.dart';

class Route {
  static Map<String, WidgetBuilder> routes = {
    'sudoku': (BuildContext context) => SudokuView(),
    'sudokuImage': (BuildContext context) => SudokuImageView(),
    'sudokuManual': (BuildContext context) => SudokuManualView(),
  };
}
