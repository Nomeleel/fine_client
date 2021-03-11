import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:extended_image/extended_image.dart';
import 'package:image_picker/image_picker.dart';

import 'base_page.dart';
import 'creative_stitching_view.dart';

class PickMainImagePage extends StatefulWidget {
  const PickMainImagePage({Key key}) : super(key: key);

  @override
  _PickMainImagePageState createState() => _PickMainImagePageState();
}

class _PickMainImagePageState extends State<PickMainImagePage> {
  final GlobalKey<ExtendedImageEditorState> _mainImageEditKey =
      GlobalKey<ExtendedImageEditorState>();
  String _mainImagePath;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      topBar: TopBar(nextAction: () {
        CreativeStitching.of(context).mainImagePath = _mainImagePath;
        CreativeStitching.of(context).mainImageCropRect =
            _mainImageEditKey.currentState.getCropRect();
        Navigator.of(context).pushNamed('multiple');
      }),
      body: _mainImagePath == null
          ? introduction(actionLabel: '选择图片')
          : ExtendedImage.file(
              File(_mainImagePath),
              fit: BoxFit.contain,
              mode: ExtendedImageMode.editor,
              extendedImageEditorKey: _mainImageEditKey,
              initEditorConfigHandler: (ExtendedImageState state) {
                return EditorConfig(
                    maxScale: 8.0,
                    cropRectPadding: const EdgeInsets.all(0.0),
                    hitTestSize: 50.0,
                    cropAspectRatio: 1.0);
              },
            ),
    );
  }

  Widget introduction({String actionLabel}) {
    return Center(
      child: CupertinoButton(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.618,
          height: 50,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: () async {
          _mainImagePath =
              (await ImagePicker().getImage(source: ImageSource.gallery)).path;
          setState(() {});
        },
      ),
    );
  }
}
