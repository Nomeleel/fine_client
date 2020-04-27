import 'package:awesome_flutter/widget/GridPaperExp.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/sudoku_manual_provider.dart';
import '../../helper/flushbar_helper.dart';

 class SudokuManualView extends StatefulWidget {
   SudokuManualView({Key key}) : super(key: key);

   @override
   SudokuManualViewState createState() => SudokuManualViewState();
 }

class SudokuManualViewState extends State<SudokuManualView> {
  Dio _dio;
  SudokuManualProvider _provider;

  @override
  void initState() {
   super.initState();

   _dio = Dio();
  }

  @override
  Widget build(BuildContext context) {
    _provider = SudokuManualProvider(fillSudokuStr: ModalRoute.of(context)?.settings?.arguments?.toString());

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 100, 10, 35),
            child: AspectRatio(
              aspectRatio: 1,
              child: GridPaperExp(
                color: Color.fromARGB(255, 22, 46, 109),
                strokeWidth: 2.7,
                interval: (MediaQuery.of(context).size.width - 20),
                divisions: 3,
                subdivisions: 3,
                child: ChangeNotifierProvider.value(
                  value: _provider,
                  child: Selector<SudokuManualProvider, List<SudokuCell>>(
                    selector: (context, provider) => provider.sudokuCellList,
                    builder: (BuildContext context, List value, Widget child) {
                      return GridView.count(
                        crossAxisCount: 9,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(_provider.sudokuCellList.length, (index) {
                          return Selector<SudokuManualProvider, SudokuCell>(
                            selector: (context, provider) => provider.sudokuCellList[index],
                            builder: (context, value, child) => sudoKuCell(value),
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
            children: List.generate(10, (index) => digitButton(index)),
          ),
          Expanded(
            child: CupertinoButton(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.618,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(
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
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: InkWell(
        child: Container(
          width: 35,
          height: 50,
          alignment: Alignment.center,
          child: digit == 0 ? 
            Icon(
              Icons.clear,
              color: Colors.red,
              size: 30,
            ) : 
            Text(
              digit.toString(),
              style: TextStyle(
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
        child: cell.digit == 0 ? null : Center(
          child: Text(
            cell.digit.toString(),
            style: TextStyle(
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

  void uploadSudokuStr() {
    _dio.post(
      'http://192.168.1.9:8160/sudoku',
      data: FormData.fromMap({
        "sudokuStr": _provider.sudokuStr,
      }),
    ).then((response) {
      if (response.statusCode == 200) {
        FlushBarHelper.showSuccess(
          context: context,
          message: response.data['solved'] ? '已解决数独！' : '未解决数独！',
        );
      } else {
        FlushBarHelper.showError(
          context: context,
          message: '上传失败！',
        );
      }
    }).catchError((e){
      FlushBarHelper.showError(
        context: context,
        message: '网络异常！',
      );
    });
  }

}
