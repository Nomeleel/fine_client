import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:awesome_flutter/creative/creative_stitching.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'base_page.dart';
import 'creative_stitching_view.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key key}) : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  List<ByteData> _finalByteDataList;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      topBar: TopBar(
        title: '预览',
        nextActionLabel: '导出',
        nextAction: () async {
          if (_finalByteDataList != null) {
            await Future.forEach(_finalByteDataList,
                (ByteData imageByteData) async {
              await ImageGallerySaver.saveImage(
                  imageByteData.buffer.asUint8List());
            });

            Scaffold.of(context).showSnackBar(const SnackBar(
              content: Text('导出成功!'),
            ));
          }
        },
      ),
      body: Center(
        child: FutureBuilder<List<ByteData>>(
          future: creativeStitching(),
          builder: (BuildContext context,
              AsyncSnapshot<List<ByteData>> asyncSnapshot) {
            switch (asyncSnapshot.connectionState) {
              case ConnectionState.done:
                if (asyncSnapshot.data != null) {
                  _finalByteDataList = asyncSnapshot.data;
                  return moment();
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
          },
        ),
      ),
    );
  }

  Future<List<ByteData>> creativeStitching() async {
    final CreativeStitching cs = CreativeStitching.of(context);
    return await creativeStitchingByFilePath(
        cs.mainImagePath, cs.multipleImagePathList,
        mainImageCropRect: cs.mainImageCropRect);
  }

  Widget moment() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            child: Image.asset('assets/images/SaoSiMing.jpg',
                height: 45, width: 45, fit: BoxFit.cover),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
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
                children: <Widget>[
                  const Text(
                    '7天前',
                    style: TextStyle(
                      color: Color.fromARGB(255, 170, 170, 170),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.more,
                    size: 23.0,
                    color: const Color.fromARGB(255, 84, 92, 137),
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
    final List<Widget> detailViewList = _finalByteDataList
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

    for (int i = 0; i < _finalByteDataList.length; i++) {
      imageList.add(GestureDetector(
        child: Image.memory(
          _finalByteDataList[i].buffer.asUint8List(),
          fit: BoxFit.cover,
        ),
        onTap: () {
          final WidgetBuilder builder = (BuildContext context) {
            return PageView(
              controller: PageController(
                initialPage: i,
              ),
              physics: const BouncingScrollPhysics(),
              children: detailViewList,
            );
          };

          Navigator.of(context).push<dynamic>(
            Platform.isAndroid
                ? TransparentMaterialPageRoute<dynamic>(builder: builder)
                : TransparentCupertinoPageRoute<dynamic>(builder: builder),
          );
        },
      ));
    }

    return AspectRatio(
      aspectRatio: 3 / (_finalByteDataList.length / 3).ceil(),
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        children: imageList,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
    );
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
}
