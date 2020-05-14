import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<AssetEntity> _multipleImageList;

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
      child: Stack(
        children: <Widget> [
          mainView,
          topBar,
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
            afterNextAction: () {
              AssetPicker.pickAssets(
                context,
                selectedAssets: _multipleImageList,
              );
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
          print('Creative Stitching');
        }
      ),
      _multipleImageList == null ?
      introductionView(
        actionLabel: '重新选择',
        action: () {
          AssetPicker.pickAssets(
            context,
            selectedAssets: _multipleImageList,
          );
        }
      ) :
      Text('Show Image List')
    );
  }

  Widget previewView() {
    return baseView(
      topBar(
        description: '预览'
      ),
      Text(''),
    );
  }

  Widget topBar({
    Function backAction,
    String description, 
    Function beforeNextAction,
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
                '下一步',
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
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300), 
                  curve: Curves.easeInOut,
                );
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

}