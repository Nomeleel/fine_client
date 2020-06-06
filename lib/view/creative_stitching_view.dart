import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:awesome_flutter/creative/creative_stitching.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CreativeStitchingView extends StatefulWidget {
  const CreativeStitchingView({Key key}) : super(key: key);

  @override
  _CreativeStitchingViewState createState() => _CreativeStitchingViewState();
}

class _CreativeStitchingViewState extends State<CreativeStitchingView> {
  final PageController _pageController = PageController();
  String _mainImagePath;
  final GlobalKey<ExtendedImageEditorState> _mainImageEditKey =
      GlobalKey<ExtendedImageEditorState>();
  Rect _mainImageCropRect;
  List<String> _multipleImagePathList;
  StreamController<List<String>> _streamController;
  List<ByteData> _finalByteDataList;

  @override
  void initState() {
    _multipleImagePathList = <String>[];
    _streamController = StreamController<List<String>>();
    _streamController.add(_multipleImagePathList);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          pickMainImageView(),
          pickMultipleImageView(),
          previewView(),
        ]
      ),
    );
  }

  Widget baseView(Widget topBar, Widget mainView) {
    return Column(
      children: <Widget>[
        topBar,
        Expanded(
          child: mainView,
        ),
      ],
    );
  }

  Widget pickMainImageView() {
    return Container(
      color: Colors.white,
      child: _mainImagePath == null
          ? introductionView(
              actionLabel: '选择图片',
              action: () async {
                _mainImagePath =
                    (await ImagePicker.pickImage(source: ImageSource.gallery))
                        .path;
                setState(() {});
              })
          : baseView(
              topBar(backAction: () {
                setState(() {
                  _mainImagePath = null;
                });
              }, beforeNextAction: () {
                _mainImageCropRect =
                    _mainImageEditKey.currentState.getCropRect();
              }, afterNextAction: () {
                pickAssets();
              }),
              ExtendedImage.file(
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
            ),
    );
  }

  Widget introductionView({
    String actionLabel,
    VoidCallback action,
  }) {
    return Center(
      child: CupertinoButton(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.618,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
          ),
          child: Text(
            actionLabel,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: action,
      ),
    );
  }

  Widget pickMultipleImageView() {
    return baseView(
      topBar(afterNextAction: () {
        // Activate Stream.fromFuture in preview view.
        setState(() {});
      }),
      StreamBuilder<List<String>>(
          stream: _streamController.stream,
          initialData: _multipleImagePathList,
          builder: (BuildContext context,
              AsyncSnapshot<List<String>> asyncSnapshot) {
            if ((asyncSnapshot.connectionState == ConnectionState.active ||
                    asyncSnapshot.connectionState == ConnectionState.done) &&
                asyncSnapshot.data != null) {
              return GridView.count(
                padding: EdgeInsets.zero,
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: asyncSnapshot.data
                    .map<Widget>((String filePath) => Image.file(
                          File(filePath),
                          fit: BoxFit.cover,
                        ))
                    .toList(),
              );
            }

            return introductionView(
                actionLabel: '重新选择',
                action: () async {
                  await pickAssets();
                });
          }),
    );
  }

  Widget previewView() {
    return baseView(
      topBar(
          description: '预览',
          nextActionLabel: '导出',
          nextAction: () async {
            if (_finalByteDataList != null) {
              for (final ByteData imageByteData in _finalByteDataList) {
                await ImageGallerySaver.saveImage(
                    imageByteData.buffer.asUint8List());
                print('Save complete.');
              }
            }
          }),
      Center(
        child: StreamBuilder<List<ByteData>>(
            stream: _multipleImagePathList.isNotEmpty
                ? Stream<List<ByteData>>.fromFuture(creativeStitchingByFilePath(
                    _mainImagePath, _multipleImagePathList,
                    mainImageCropRect: _mainImageCropRect))
                : null,
            builder: (BuildContext context,
                AsyncSnapshot<List<ByteData>> asyncSnapshot) {
              switch (asyncSnapshot.connectionState) {
                case ConnectionState.done:
                  if (asyncSnapshot.data != null) {
                    _finalByteDataList = asyncSnapshot.data;
                    return GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      children: _finalByteDataList
                          .map<Widget>((ByteData bytes) => heroWidget(
                              Image.memory(bytes.buffer.asUint8List(),
                                  fit: BoxFit.cover)))
                          .toList(),
                    );
                  } else {
                    return const Center(
                      child: Text('Please retry!'),
                    );
                  }
                  break;
                default:
                  return CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                  );
              }
            }),
      ),
    );
  }

  Widget topBar({
    Function backAction,
    String description,
    String nextActionLabel = '下一步',
    Function beforeNextAction,
    Function nextAction,
    Function afterNextAction,
  }) {
    return Container(
      color: const Color(0xFF232323),
      height: 40 + MediaQueryData.fromWindow(window).padding.top,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 7.0),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: 60,
            height: 30,
            child: GestureDetector(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.arrow_back_ios),
              ),
              onTap: () {
                if (backAction == null) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  backAction();
                }
              },
            ),
          ),
          Expanded(
            child: Text(
              description ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            height: 30,
            child: CupertinoButton(
              child: Text(
                nextActionLabel,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              color: Colors.green[500],
              padding: EdgeInsets.zero,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              onPressed: () {
                if (beforeNextAction != null) {
                  beforeNextAction();
                }

                if (nextAction == null) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  nextAction();
                }

                if (afterNextAction != null) {
                  afterNextAction();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickAssets() async {
    final List<AssetEntity> multipleImageList = await AssetPicker.pickAssets(
      context,
      maxAssets: 18,
    );

    if (multipleImageList != null && multipleImageList.isNotEmpty) {
      _multipleImagePathList.clear();
      await Future.wait(multipleImageList?.map((AssetEntity assetEntity) async {
        _multipleImagePathList.add((await assetEntity.file).path);
      }));
      _streamController.add(_multipleImagePathList);
      multipleImageList.clear();
    }
  }

  Widget heroWidget(Widget widget) {
    final String uniqueTag =
        DateTime.now().toString() + math.Random().nextInt(77).toString();
    return GestureDetector(
      child: Hero(
        tag: uniqueTag,
        child: widget,
      ),
      onTap: () {
        Navigator.of(context).push<dynamic>(PageRouteBuilder<dynamic>(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Hero(
              tag: uniqueTag,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    widget,
                  ],
                ),
              ),
            );
          },
        ));
      },
    );
  }

  @override
  void dispose() {
    _streamController.close();

    super.dispose();
  }
}
