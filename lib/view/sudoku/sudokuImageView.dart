import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SudokuImageView extends StatefulWidget {
  SudokuImageView({Key key}) : super(key: key);

  @override
  SudokuImageViewState createState() => SudokuImageViewState();
}

class SudokuImageViewState extends State<SudokuImageView> {
  File _image;
  Dio _dio;

  @override
  void initState() {
    _dio = Dio();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Padding(
              padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: imagePickPart(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: CupertinoButton(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.618,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _image == null
                      ? CupertinoColors.quaternarySystemFill
                      : Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(
                  '上传图片',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: _image == null ? null : uploadImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget imagePickPart() {
    return _image == null
        ? CupertinoButton(
            child: Container(
              width: 200,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Text(
                '选择图片',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            onPressed: pickImage,
          )
        : Stack(
            children: <Widget>[
              Image.file(
                _image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                right: -5,
                top: -5,
                child: CupertinoButton(
                  child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Icon(
                        Icons.clear,
                        size: 35,
                      )),
                  onPressed: clearImage,
                ),
              ),
            ],
          );
  }

  Future pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  void clearImage() {
    setState(() {
      _image = null;
    });
  }

  Future uploadImage() async {
    if (_image == null) {
      return;
    }

    await _dio.post(
      'http://192.168.1.9:8160/sudoku',
      data: FormData.fromMap({
        "image": await MultipartFile.fromFile(
          _image.path,
        ),
      }),
    ).then((response) {
      if (response.statusCode == 200) {
        if (response.data['solved']) {
          FlushbarHelper.createSuccess(message: '已解决数独！').show(context);
          clearImage();
        } else {
          FlushbarHelper.createAction(
            message: '图片识别有误, 请尝试手动输入模式！',
            button: FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('routeName', arguments: response.data['sudokuStr']);
              }, 
              child: Text('转到'),
            )
          ).show(context);
        }
      } else {
        FlushbarHelper.createError(message: '上传失败！').show(context);
      }
    }).catchError((){
      FlushbarHelper.createError(message: '网络异常！').show(context);
    });
  }
}
