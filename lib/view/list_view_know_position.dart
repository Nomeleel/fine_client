import 'dart:async';

import 'package:flutter/material.dart';

class ListViewKnowPosition extends StatefulWidget {
  const ListViewKnowPosition({Key? key}) : super(key: key);

  @override
  _ListViewKnowPositionState createState() => _ListViewKnowPositionState();
}

class _ListViewKnowPositionState extends State<ListViewKnowPosition> {
  final ScrollController controller = ScrollController();
  final GlobalKey listViewKey = GlobalKey();
  final List<Widget> list = List<Widget>.generate(10, (int index) {
    return Container(
      key: ValueKey<int>(index),
      height: 1500.0,
      color: Colors.primaries[index],
      alignment: Alignment.center,
      child: Text('$index'),
    );
  });
  final Map<String, GlobalKey> keyMap = <String, GlobalKey>{};
  late int listIndex = 0;
  final StreamController<int> streamController = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        NotificationListener<ScrollNotification>(
          child: ListView.builder(
            key: listViewKey,
            controller: controller,
            padding: EdgeInsets.zero,
            itemCount: list.length,
            cacheExtent: 0.0,
            itemBuilder: (BuildContext context, int index) {
              final Widget item = list[index];
              final int value = (item.key as ValueKey<int>).value;
              if (value != listIndex) {
                listIndex = value;
                streamController.add(value);
              }
              debugPrint('-----------$value----------');
              return item;
            },
          ),
          onNotification: (ScrollNotification notification) {
            // print(notification.metrics.pixels);
            // print(notification is ScrollStartNotification);
            // print(notification is ScrollEndNotification);
            if (notification is ScrollEndNotification) {
              keyMapForeach();
            }
            return true;
          },
        ),
        StreamBuilder<int>(
          stream: streamController.stream,
          initialData: listIndex,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            debugPrint(snapshot.connectionState.toString());
            if (snapshot.connectionState == ConnectionState.active || snapshot.data != null) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  '${snapshot.data}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 50.0,
                    decoration: TextDecoration.none,
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        // Container(
        //   alignment: Alignment.center,
        //   child: RaisedButton(
        //     child: const Text('Go'),
        //     onPressed: () {
        //       print('------controller-------');
        //       print(controller.offset);
        //       print('-----------------------');
        //       keyMapForeach();
        //     },
        //   ),
        // )
      ],
    );
  }

  void keyMapForeach() {
    // ignore: avoid_function_literals_in_foreach_calls
    keyMap.forEach((String key, GlobalKey e) {
      // 应该有方法判断listview现在正在显示的item，这个通过catch的方法太蠢了
      try {
        debugPrint(e.currentContext?.findRenderObject()?.getTransformTo(null).getTranslation().y.toString());
        debugPrint('------------$key-----------');
        debugPrint(e.currentContext?.findAncestorWidgetOfExactType<ListView>().toString());
        // ignore: empty_catches
      } catch (e) {}
    });
  }
}

// extension ValueKeyExtension on ValueKey {
//   int getIntValue() {
//     return 1;
//   }
// }
