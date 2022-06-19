import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'base_page.dart';
import 'creative_stitching_view.dart';

class PickMultipleImagePage extends StatefulWidget {
  const PickMultipleImagePage({Key? key}) : super(key: key);

  @override
  _PickMultipleImagePageState createState() => _PickMultipleImagePageState();
}

class _PickMultipleImagePageState extends State<PickMultipleImagePage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      topBar: TopBar(
        nextAction: () {
          Navigator.of(context).pushReplacementNamed('preview');
        },
      ),
      body: FutureBuilder<List<String>>(
        future: pickAssets(),
        builder:
            (BuildContext context, AsyncSnapshot<List<String>> asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            CreativeStitching.of(context)!.multipleImagePathList =
                asyncSnapshot.data;
            return GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              children: asyncSnapshot.data!
                  .map<Widget>((String filePath) => Image.file(
                        File(filePath),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.none,
                      ))
                  .toList(),
            );
          } else {
            return Container(
              color: Colors.white,
            );
          }
        },
      ),
    );
  }

  Future<List<String>> pickAssets() async {
    final List<String> imageList = <String>[];

    final List<AssetEntity>? multipleImageList = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(maxAssets: 18),
    );

    await Future.forEach(multipleImageList!, (AssetEntity assetEntity) async {
      imageList.add((await assetEntity.file)!.path);
    });
    return imageList;
  }
}
