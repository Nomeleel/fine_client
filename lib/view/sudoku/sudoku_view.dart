import 'package:flutter/material.dart';

import 'sudoku_image_view.dart';
import 'sudoku_manual_view.dart';

class SudokuView extends StatefulWidget {
  const SudokuView({Key key}) : super(key: key);

  @override
  SudokuViewState createState() => SudokuViewState();
}

class SudokuViewState extends State<SudokuView> {
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const ClampingScrollPhysics(),
      children: const <Widget>[
        SudokuImageView(),
        SudokuManualView(),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }
}
