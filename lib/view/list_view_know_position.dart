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
  List<GlobalKey> keyList;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    listViewKey = GlobalKey();
    list = <Widget>[];
    keyList = <GlobalKey>[];
    List<void>.generate(10, (int index) {
      list.add(Container(
        height: 1000.0,
        color: Colors.primaries[index],
        alignment: Alignment.center,
        child: Text('$index'),
      ));
      final GlobalKey key = GlobalKey();
      keyList.add(key);
      list.add(Container(
        key: key,
        height: 0.0,
        color: Colors.black,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          ListView.builder(
            key: listViewKey,
            controller: controller,
            padding: EdgeInsets.zero,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) => list[index],
          ),
          const Text('A'),
          Container(
            alignment: Alignment.center,
            child: RaisedButton(
              child: const Text('Go'),
              onPressed: () {
                print('------controller-------');
                print(controller.offset);
                print('-----------------------');
                // ignore: avoid_function_literals_in_foreach_calls
                keyList.forEach((GlobalKey e) {
                  try {
                    print(e.currentContext.findRenderObject().paintBounds);
                    print(e.currentContext.findAncestorWidgetOfExactType<ListView>());
                    // ignore: empty_catches
                  } catch (e) {}
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
