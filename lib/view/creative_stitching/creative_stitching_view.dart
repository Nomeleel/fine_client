import 'package:flutter/cupertino.dart';

import 'pick_main_image_page.dart';
import 'pick_multiple_image_page.dart';
import 'preview_page.dart';

// ignore: must_be_immutable
class CreativeStitching extends InheritedWidget {
  CreativeStitching({Key? key, required Widget child}) : super(key: key, child: child);

  String? mainImagePath;
  Rect? mainImageCropRect;

  List<String>? multipleImagePathList;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static CreativeStitching? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CreativeStitching>();
  }
}

// TODO(Nomeleel): 下一步 之前 check
class CreativeStitchingView extends StatelessWidget {
  const CreativeStitchingView({Key? key}) : super(key: key);

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
              page = const Center(child: Text('☹'));
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
