import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:awesome_flutter/creative/creative_stitching.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CreativeStitchingView extends StatefulWidget {
  CreativeStitchingView({Key key}) : super(key: key);

  @override
  _CreativeStitchingViewState createState() => _CreativeStitchingViewState();
}

class _CreativeStitchingViewState extends State<CreativeStitchingView> {

  PageController _pageController = PageController();
  File _mainImage;
  final GlobalKey<ExtendedImageEditorState> _mainImageEditKey = GlobalKey<ExtendedImageEditorState>();
  Rect _mainImageCropRect;
  List<File> _multipleImageList;
  StreamController _streamController;
  List<ByteData> _finalByteDataList;

  @override
  void initState() {
    _multipleImageList = List<File>();
    _streamController = StreamController<List<File>>.broadcast();
    _streamController.sink.add(_multipleImageList);
    
    super.initState();
  }

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
            controller: _pageController,
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

  Widget baseView(Widget topBar, Widget mainView) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget> [
          topBar,
          Expanded(
            child: mainView,
          ),
        ],
      ),
    );
  }

  Widget pickMainImageView() {
    return Container(
      color: Colors.white,
      child: _mainImage == null ?
        introductionView(
          actionLabel: '选择图片',
          action: () async {
            _mainImage = await ImagePicker.pickImage(source: ImageSource.gallery);
            setState(() { });
          }
        ) : 
        baseView(
          topBar(
            backAction: () {
              setState(() {
                _mainImage = null;
              });
            },
            beforeNextAction: () {
              _mainImageCropRect = _mainImageEditKey.currentState.getCropRect();
            },
            afterNextAction: () async {
              await pickAssets();
            }
          ),
          ExtendedImage.file(
            _mainImage,
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
        ),
    );
  }

  Widget introductionView({
    String actionLabel,
    Function action,
  }) {
    return Center(
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
      topBar(
        afterNextAction: () {
          _streamController.sink.close();
          // Activate Stream.fromFuture in preview view.
          setState(() { });
        }
      ),
      StreamBuilder(
        stream: _streamController.stream,
        initialData: _multipleImageList,
        builder: (context, asyncSnapshot) {
          if ((asyncSnapshot.connectionState == ConnectionState.active ||
            asyncSnapshot.connectionState == ConnectionState.done) && asyncSnapshot.data != null) {
            return GridView.count(
              crossAxisCount: 3,
              children: asyncSnapshot.data.map<Widget>((file) => Image.file(
                file,
                fit: BoxFit.cover,
              )).toList(),
            );
          }

          return introductionView(
            actionLabel: '重新选择',
            action: () async {
              await pickAssets();
              //setState(() {});
            }
          );
        }
      ),
      /*
      _multipleImageList.length == 0 ?
      introductionView(
        actionLabel: '重新选择',
        action: () async {
          await pickAssets();
          setState(() {});
        }
      ) :
      GridView.count(
        crossAxisCount: 3,
        children: _multipleImageList.map<Widget>((file) => Image.file(
          file,
          fit: BoxFit.cover,
        )).toList(),
      )
      */
    );
  }

  Widget previewView() {
    return baseView(
      topBar(
        description: '预览',
        nextActionLabel: '导出',
      ),
      Center(
        child: StreamBuilder(
          stream: Stream.fromFuture(
            creativeStitchingByFile(
              _mainImage,
              _multipleImageList,
              mainImageCropRect: _mainImageCropRect
            )
          ),
          builder: (context, asyncSnapshot) {
            switch (asyncSnapshot.connectionState) {
              case ConnectionState.done:
                if (asyncSnapshot.data != null) {
                  _finalByteDataList = asyncSnapshot.data;
                  return GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    children: _finalByteDataList.map<Widget>((bytes) => 
                      heroWidget(Image.memory(
                        bytes.buffer.asUint8List(),
                        fit: BoxFit.cover
                      )
                    )).toList(),
                  );
                } 
                else {
                  return Center(
                    child: Text('Please retry!'),
                  );
                }
                break;
              default:
                return CircularProgressIndicator(
                  backgroundColor: Colors.white,
                );
            }
          }
        ),  
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
      color: Color(0xFF232323),
      height: 45,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: 7.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget> [
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
                } 
                else {
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
            )
          ),
          SizedBox(
            width: 60,
            height: 30,
            child: CupertinoButton(
              child: Text(
                nextActionLabel,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              color: Colors.green[500],
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              onPressed: () {
                if (beforeNextAction != null) {
                  beforeNextAction();
                }

                if (nextAction == null) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300), 
                    curve: Curves.easeInOut,
                  );
                }
                else {
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

  pickAssets() async {
    List<AssetEntity> multipleImageList = await AssetPicker.pickAssets(
      context,
      maxAssets: 18,
    );

    if (multipleImageList != null && multipleImageList.length > 0) {
      _multipleImageList.clear();
      await Future.wait(multipleImageList?.map((assetEntity) async {
        _multipleImageList.add(await assetEntity.file);
      }));
      _streamController.sink.add(_multipleImageList);
    }
  }

  Widget heroWidget(Widget widget) {
    var uniqueTag = DateTime.now().toString() + math.Random().nextInt(77).toString();
    return GestureDetector(
      child: Hero(
        tag: uniqueTag,
        child: widget,
      ),
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return Hero(
              tag: uniqueTag,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget> [
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

  // static Future<List<ByteData>> creativeStitching(Map<String, dynamic> map) async {
  //   return await creativeStitchingByFile(
  //     map['file'],
  //     map['fileList'],
  //     mainImageCropRect: map['rect'],
  //   );
  // }

  @override
  void dispose() {
    _streamController.close();

    super.dispose();
  }
}
