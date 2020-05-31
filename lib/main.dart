import 'package:awesome_flutter/widget/app_store_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_scan/route/view_routes.dart';

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
      home: const MyHomePage(title: 'Fine'),
      routes: viewRoutes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  Map<String, WidgetBuilder> routeMap = <String, WidgetBuilder>{};

  @override
  void initState() {
    routeMap = viewRoutes;
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
        physics: const BouncingScrollPhysics(),
        controller: ScrollController(),
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          return SlideTransition(
            position: animation
                .drive(CurveTween(curve: Curves.elasticInOut))
                .drive(Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: const Offset(0, 0),
                )),
            child: listItemBuilder(index),
          );
        },
      ),
    );
  }

  Widget listItemBuilder(int index) {
    return AppStoreCard(
      key: ValueKey<String>('$index'),
      elevation: 7,
      radius: const BorderRadius.all(Radius.circular(20)),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      showBackgroundWidget: Image.asset('assets/images/SaoSiMing.jpg'),
      detailWidget: viewRoutes.values.elementAt(index)(context),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
