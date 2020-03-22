import 'route.dart' as Route;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Fine',
      theme: CupertinoThemeData(
        barBackgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MyHomePage(title: 'Fine'),
      routes: Route.Route.routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _listKey = GlobalKey<AnimatedListState>();

  Map<String, WidgetBuilder> routeMap = Map<String, WidgetBuilder>();

  @override
  void initState() {
    routeMap = Route.Route.routes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18.5,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      child: AnimatedList(
        key: _listKey,
        initialItemCount: routeMap.length,
        physics: BouncingScrollPhysics(),
        controller: ScrollController(),
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation
                .drive(CurveTween(curve: Curves.elasticInOut))
                .drive(Tween<Offset>(
                  begin: Offset(-1, 0),
                  end: Offset(0, 0),
                )),
            child: listItemBuilder(index),
          );
        },
      ),
    );
  }

  Widget listItemBuilder(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(routeMap.keys.elementAt(index));
      },
      child: Text(
        routeMap.keys.elementAt(index),
        style: TextStyle(
          fontSize: 50,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
