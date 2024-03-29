import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../../helper/flushbar_helper.dart';

class SudokuImageView extends StatefulWidget {
  const SudokuImageView({Key? key}) : super(key: key);

  @override
  SudokuImageViewState createState() => SudokuImageViewState();
}

class SudokuImageViewState extends State<SudokuImageView> {
  File? _image;
  final Dio _dio = Dio();

  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
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
                  color: _image == null ? CupertinoColors.quaternarySystemFill : Colors.blueAccent,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: const Text(
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
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const Text(
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
                _image!,
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
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: const Icon(
                        Icons.clear,
                        size: 35,
                      )),
                  onPressed: clearImage,
                ),
              ),
            ],
          );
  }

  Future<void> pickImage() async {
    final File image = File((await _imagePicker.pickImage(source: ImageSource.gallery))!.path);

    setState(() {
      _image = image;
    });
  }

  void clearImage() {
    setState(() {
      _image = null;
    });
  }

  Future<void> uploadImage() async {
    if (_image == null) {
      return;
    }

    await _dio
        .post<Response<dynamic>>(
      'http://192.168.1.9:8160/sudoku',
      data: FormData.fromMap(<String, dynamic>{
        'image': await MultipartFile.fromFile(
          _image!.path,
        ),
      }),
    )
        .then((Response<dynamic> response) {
      if (response.statusCode == 200) {
        if (response.data['solved'] as bool) {
          FlushBarHelper.showSuccess(
            context: context,
            message: '已解决数独！',
          );
          clearImage();
        } else {
          FlushBarHelper.showSuccessAction(
            context: context,
            message: '图片识别有误, 请尝试手动输入模式！',
            actionLabel: '转到',
            action: () {
              Navigator.of(context).pushNamed(
                'sudoku_manual_view',
                arguments: response.data['sudokuStr'],
              );
            },
          );
        }
      } else {
        FlushBarHelper.showError(
          context: context,
          message: '上传失败！',
        );
      }
    }).catchError((dynamic e) {
      FlushBarHelper.showError(
        context: context,
        message: '网络异常！',
      );
    });
  }
}
