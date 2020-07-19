import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'pick_main_image_page.dart';
import 'pick_multiple_image_page.dart';
import 'preview_page.dart';

// ignore: must_be_immutable
class CreativeStitching extends InheritedWidget {
  CreativeStitching({Key key, Widget child}) : super(key: key, child: child);

  String mainImagePath;
  Rect mainImageCropRect;

  List<String> multipleImagePathList;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static CreativeStitching of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CreativeStitching>();
  }
}

class CreativeStitchingView extends StatelessWidget {
  const CreativeStitchingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreativeStitching(
      child: Navigator(
        initialRoute: 'main',
        onGenerateRoute: (RouteSettings settings) {
          Widget page;
          switch (settings.name) {
            case 'main':
              page = const PickMainImagePage();
              break;
            case 'multiple':
              page = const PickMultipleImagePage();
              break;
            case 'preview':
              page = const PreviewPage();
              break;
            default:
              page = Container(
                child: const Center(
                  child: Text('☹'),
                ),
              );
              break;
          }
          return CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) => page,
          );
        },
      ),
    );
  }
}
