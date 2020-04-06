import 'package:flutter/material.dart';

import 'sudokuImageView.dart';
import 'sudokumanualView.dart';

class SudokuView extends StatefulWidget {
  SudokuView({Key key}) : super(key: key);

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
      controller: this._pageController,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
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
