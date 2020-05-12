import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class CreativeStitchingView extends StatefulWidget {
  CreativeStitchingView({Key key}) : super(key: key);

  @override
  _CreativeStitchingViewState createState() => _CreativeStitchingViewState();
}

class _CreativeStitchingViewState extends State<CreativeStitchingView> {

  File _mainImage;
  final GlobalKey<ExtendedImageEditorState> _mainImageEditKey = GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            top: 0,
          ),
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget> [
              pickMainImageView(),
              pickMultipleImageView(),
              previewView(),
            ]
          ),
        ),
      ),
    );
  }

  Widget pickMainImageView() {
    return Container(
      color: Colors.white,
      child: _mainImage == null ?
        Stack(
          children: <Widget> [
            ExtendedImage.file(
              File('/storage/emulated/0/Download/Sudoku_Error.png'),
              //_mainImage,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.editor,
              extendedImageEditorKey: _mainImageEditKey,
              initEditorConfigHandler: (state) {
                return EditorConfig(
                  maxScale: 8.0,
                  cropRectPadding: EdgeInsets.all(0.0),
                  hitTestSize: 50.0,
                  cropAspectRatio: 1.0
                );
              },
            ),
            Positioned(
              top: 0.0,
              child: Container(
                color: Colors.blueAccent,
                alignment: Alignment.centerRight,
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  right: 10.0,
                ),
                child: RaisedButton(
                  child: Text('确定'),
                  onPressed: () {
                    print(_mainImageEditKey.currentState.getCropRect());
                  }
                ,)
              )
            )
          ],
        ) :
        CupertinoButton(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.618,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _mainImage != null
                  ? CupertinoColors.quaternarySystemFill
                  : Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Text(
              '选择图片',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          onPressed: () async {
            _mainImage = await ImagePicker.pickImage(source: ImageSource.gallery);
            print(_mainImage.path);
            setState(() { });
          },
        ),
    );
  }

  Widget pickMultipleImageView() {
    return Container(
      color: Colors.green,
    );
  }

  Widget previewView() {
    return Container(
      color: Colors.yellowAccent,
    );
  }
}
