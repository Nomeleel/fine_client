import 'package:flutter/material.dart';

import 'view/sudokuView.dart';

class Route{

  static Map<String, WidgetBuilder> routes = {
    'sudoku': (BuildContext context) => SudokuView(),
  };

}