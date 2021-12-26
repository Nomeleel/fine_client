import 'package:awesome_flutter/widget/grid_paper_exp.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helper/flushbar_helper.dart';
import '../../provider/sudoku_manual_provider.dart';

class SudokuManualView extends StatefulWidget {
  const SudokuManualView({Key? key}) : super(key: key);

  @override
  SudokuManualViewState createState() => SudokuManualViewState();
}

class SudokuManualViewState extends State<SudokuManualView> {
  final Dio _dio = Dio();
  late SudokuManualProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = SudokuManualProvider(fillSudokuStr: ModalRoute.of(context)?.settings.arguments?.toString());

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 100, 10, 35),
            child: AspectRatio(
              aspectRatio: 1,
              child: GridPaperExp(
                color: const Color.fromARGB(255, 22, 46, 109),
                strokeWidth: 2.7,
                interval: MediaQuery.of(context).size.width - 20,
                divisions: 3,
                subdivisions: 3,
                child: ChangeNotifierProvider<SudokuManualProvider>.value(
                  value: _provider,
                  child: Selector<SudokuManualProvider, List<SudokuCell>>(
                    selector: (BuildContext context, SudokuManualProvider provider) => provider.sudokuCellList,
                    builder: (BuildContext context, List<SudokuCell> value, Widget? child) {
                      return GridView.count(
                        crossAxisCount: 9,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List<Selector<SudokuManualProvider, SudokuCell>>.generate(
                            _provider.sudokuCellList.length, (int index) {
                          return Selector<SudokuManualProvider, SudokuCell>(
                            selector: (BuildContext context, SudokuManualProvider provider) =>
                                provider.sudokuCellList[index],
                            builder: (BuildContext context, SudokuCell value, Widget? child) => sudoKuCell(value),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List<Widget>.generate(10, (int index) => digitButton(index)),
          ),
          Expanded(
            child: CupertinoButton(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.618,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: const Text(
                  '上传字符串',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: uploadSudokuStr,
            ),
          ),
        ],
      ),
    );
  }

  Widget digitButton(int digit) {
    return Material(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(5.0),
      child: InkWell(
        child: Container(
          width: 35,
          height: 50,
          alignment: Alignment.center,
          child: digit == 0
              ? const Icon(
                  Icons.clear,
                  color: Colors.red,
                  size: 30,
                )
              : Text(
                  digit.toString(),
                  style: const TextStyle(
                    fontSize: 27,
                    color: Colors.white,
                  ),
                ),
        ),
        onTap: () => _provider.setDigit(digit),
      ),
    );
  }

  Widget sudoKuCell(SudokuCell cell) {
    return GestureDetector(
      child: Container(
        color: cell.isSelected ? Colors.purple.withOpacity(0.5) : Colors.transparent,
        child: cell.digit == 0
            ? null
            : Center(
                child: Text(
                  cell.digit.toString(),
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ),
      ),
      onTap: () {
        _provider.selected(cell.index);
      },
    );
  }

  Future<void> uploadSudokuStr() async {
    // final resp = await _dio.post<Response<dynamic>>('http://127.0.0.1:8160/sudoku',
    //     data: {
    //         'sudokuStr': _provider.sudokuStr,
    //       },
    //     );
    // print(resp);
    print(_provider.sudokuStr);
    _dio
        .post<dynamic>(
      'http://127.0.0.1:8160/sudoku',
      data: FormData.fromMap(<String, String>{
        'sudokuStr': _provider.sudokuStr,
      }),
    )
        .then((dynamic response) {
      if (response.statusCode == 200) {
        FlushBarHelper.showSuccess(
          context: context,
          message: response.data['solved'] as bool ? '已解决数独！' : '未解决数独！',
        );
      } else {
        FlushBarHelper.showError(
          context: context,
          message: '上传失败！',
        );
      }
    }).catchError((dynamic e) {
      print(e);
      FlushBarHelper.showError(
        context: context,
        message: '网络异常！',
      );
    });
  }
}
