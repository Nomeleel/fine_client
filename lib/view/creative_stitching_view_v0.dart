import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:awesome_flutter/creative/creative_stitching.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CreativeStitchingViewV0 extends StatefulWidget {
  const CreativeStitchingViewV0({Key? key}) : super(key: key);

  @override
  _CreativeStitchingViewV0State createState() => _CreativeStitchingViewV0State();
}

class _CreativeStitchingViewV0State extends State<CreativeStitchingViewV0> {
  final PageController _pageController = PageController();
  late String? _mainImagePath;
  final GlobalKey<ExtendedImageEditorState> _mainImageEditKey = GlobalKey<ExtendedImageEditorState>();
  late Rect? _mainImageCropRect;
  late List<String> _multipleImagePathList;
  late StreamController<List<String>> _streamController;
  late List<ByteData>? _finalByteDataList;
  final ImagePicker _imagePicker = ImagePicker();

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
        ],
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
              action: () {
                setState(() async {
                  _mainImagePath = (await _imagePicker.pickImage(source: ImageSource.gallery))?.path;
                });
              })
          : baseView(
              topBar(backAction: () {
                setState(() {
                  _mainImagePath = null;
                });
              }, beforeNextAction: () {
                _mainImageCropRect = _mainImageEditKey.currentState!.getCropRect();
              }, afterNextAction: () {
                pickAssets();
              }),
              ExtendedImage.file(
                File(_mainImagePath!),
                fit: BoxFit.contain,
                mode: ExtendedImageMode.editor,
                extendedImageEditorKey: _mainImageEditKey,
                initEditorConfigHandler: (ExtendedImageState? state) {
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
    required String actionLabel,
    required VoidCallback action,
  }) {
    return Center(
      child: CupertinoButton(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.618,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Text(
            actionLabel,
            style: const TextStyle(
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
          builder: (BuildContext context, AsyncSnapshot<List<String>> asyncSnapshot) {
            if ((asyncSnapshot.connectionState == ConnectionState.active ||
                    asyncSnapshot.connectionState == ConnectionState.done) &&
                asyncSnapshot.data != null) {
              return GridView.count(
                padding: EdgeInsets.zero,
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: asyncSnapshot.data!
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
              for (final ByteData imageByteData in _finalByteDataList!) {
                await ImageGallerySaver.saveImage(imageByteData.buffer.asUint8List());
                debugPrint('Save complete.');
              }
            }
          }),
      Center(
        child: StreamBuilder<List<ByteData>>(
            stream: _multipleImagePathList.isNotEmpty
                ? Stream<List<ByteData>>.fromFuture(creativeStitchingByFilePath(_mainImagePath!, _multipleImagePathList,
                    mainImageCropRect: _mainImageCropRect))
                : null,
            builder: (BuildContext context, AsyncSnapshot<List<ByteData>> asyncSnapshot) {
              switch (asyncSnapshot.connectionState) {
                case ConnectionState.done:
                  if (asyncSnapshot.data != null) {
                    _finalByteDataList = asyncSnapshot.data;
                    return momentView();
                  } else {
                    return const Center(
                      child: Text('Please retry!'),
                    );
                  }
                default:
                  return const CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                  );
              }
            }),
      ),
    );
  }

  Widget momentView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            child: Image.asset('assets/images/SaoSiMing.jpg', height: 45, width: 45, fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '少司命',
                style: TextStyle(
                  color: Color.fromARGB(255, 84, 92, 137),
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text('''秋兰兮麋芜，罗生兮堂下。
绿叶兮素华，芳菲菲兮袭予。
夫人兮自有美子，荪何以兮愁苦。
秋兰兮青青，绿叶兮紫茎。
满堂兮美人，忽独与余兮目成。
入不言兮出不辞，乘回风兮载云旗。
悲莫愁兮生别离，乐莫乐兮新相知。
荷衣兮蕙带，倏而来兮忽而逝。
夕宿兮帝郊，君谁须兮云之际。
与女沐兮咸池，晞女发兮阳之阿。
望美人兮未来，临风恍兮浩歌。
孔盖兮翠旌，登九天兮抚慧星。
竦长剑兮拥幼艾，荪独宜兮为民正。''',
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17.5,
                    height: 1.23,
                  )),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  right: 50,
                ),
                child: imageGridView(),
              ),
              Row(
                children: const <Widget>[
                  Text(
                    '7天前',
                    style: TextStyle(
                      color: Color.fromARGB(255, 170, 170, 170),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.more,
                    size: 23.0,
                    color: Color.fromARGB(255, 84, 92, 137),
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget imageGridView() {
    final List<Widget> imageList = <Widget>[];
    final double height = MediaQuery.of(context).size.height;
    final List<Widget> detailViewList = _finalByteDataList!
        .map<Widget>(
          (ByteData byteData) => ExtendedImageSlidePage(
            child: ExtendedImage.memory(
              byteData.buffer.asUint8List(),
              fit: BoxFit.fitHeight,
              height: height,
              enableSlideOutPage: true,
              mode: ExtendedImageMode.gesture,
            ),
          ),
        )
        .toList();

    for (int i = 0; i < _finalByteDataList!.length; i++) {
      imageList.add(GestureDetector(
        child: Image.memory(
          _finalByteDataList![i].buffer.asUint8List(),
          fit: BoxFit.cover,
        ),
        onTap: () {
          builder(BuildContext context) {
            return PageView(
              controller: PageController(
                initialPage: i,
              ),
              physics: const BouncingScrollPhysics(),
              children: detailViewList,
            );
          }

          Navigator.maybeOf(context)?.push<dynamic>(
            Platform.isAndroid 
                ? MaterialPageRoute<dynamic>(builder: builder) 
                : CupertinoPageRoute<dynamic>(builder: builder),
          );
        },
      ));
    }

    return AspectRatio(
      aspectRatio: 3 / (_finalByteDataList!.length / 3).ceil(),
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        children: imageList,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
    );
  }

  Widget topBar({
    Function? backAction,
    String? description,
    String nextActionLabel = '下一步',
    Function? beforeNextAction,
    Function? nextAction,
    Function? afterNextAction,
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
              child: const Align(
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
              style: const TextStyle(
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
              borderRadius: BorderRadius.circular(5),
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
    final List<AssetEntity>? multipleImageList = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(maxAssets: 18),
    );

    if (multipleImageList?.isNotEmpty ?? false) {
      _multipleImagePathList.clear();
      await Future.wait(multipleImageList!.map((AssetEntity assetEntity) async {
        _multipleImagePathList.add((await assetEntity.file)!.path);
      }));
      _streamController.add(_multipleImagePathList);
      multipleImageList.clear();
    }
  }

  Widget heroWidget(Widget widget) {
    final String uniqueTag = DateTime.now().toString() + math.Random().nextInt(77).toString();
    return GestureDetector(
      child: Hero(
        tag: uniqueTag,
        child: widget,
      ),
      onTap: () {
        Navigator.of(context).push<dynamic>(PageRouteBuilder<dynamic>(
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return Hero(
              tag: uniqueTag,
              child: SizedBox(
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
