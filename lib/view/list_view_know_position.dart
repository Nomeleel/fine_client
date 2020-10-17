import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListViewKnowPosition extends StatefulWidget {
  const ListViewKnowPosition({Key key}) : super(key: key);

  @override
  _ListViewKnowPositionState createState() => _ListViewKnowPositionState();
}

class _ListViewKnowPositionState extends State<ListViewKnowPosition> {
  ScrollController controller;
  GlobalKey listViewKey;
  List<Widget> list;
  Map<String, GlobalKey> keyMap;
  int listIndex;
  StreamController<int> streamController;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    listViewKey = GlobalKey();
    list = <Widget>[];
    keyMap = <String, GlobalKey>{};
    listIndex = 0;
    streamController = StreamController<int>();
    List<void>.generate(10, (int index) {
      list.add(Container(
        key: ValueKey<int>(index),
        height: 1500.0,
        color: Colors.primaries[index],
        alignment: Alignment.center,
        child: Text('$index'),
      ));
      // final GlobalKey key = GlobalKey();
      // keyMap['$index'] = key;
      // list.add(Container(
      //   key: key,
      //   height: 0.0,
      //   color: Colors.black,
      // ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
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
                final int value = (item.key as ValueKey<int>)?.value;
                if (value != listIndex) {
                  listIndex = value;
                  streamController.add(value);
                }
                print('-----------$value----------');
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
              print(snapshot.connectionState);
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
      ),
    );
  }

  void keyMapForeach() {
    // ignore: avoid_function_literals_in_foreach_calls
    keyMap.forEach((String key, GlobalKey e) {
      // 应该有方法判断listview现在正在显示的item，这个通过catch的方法太蠢了
      try {
        print(e.currentContext.findRenderObject().getTransformTo(null).getTranslation().y);
        print('------------$key-----------');
        print(e.currentContext.findAncestorWidgetOfExactType<ListView>());
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
