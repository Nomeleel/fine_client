import 'package:awesome_flutter/template/app_store_card_description.dart';
import 'package:awesome_flutter/widget/app_store_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'route/view_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fine',
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MyHomePage(title: 'Fine'),
      routes: viewRoutes,
      debugShowCheckedModeBanner: false,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18.5,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: viewRoutes.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => listItemBuilder(index),
      ),
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }

  Widget listItemBuilder(int index) {
    final String viewName = viewRoutes.keys.elementAt(index);
    return AppStoreCard(
      key: ValueKey<String>('$index'),
      elevation: 7,
      radius: const BorderRadius.all(Radius.circular(20)),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      showBackgroundWidget: Image.asset('assets/images/$viewName.jpg'),
      showForegroundWidget: AppStoreCardDescription(
        data: getDescriptionDataByViewName(viewName),
      ),
      detailWidget: viewRoutes.values.elementAt(index)(context),
      isAlwayShow: false,
    );
  }

  AppStoreCardDescriptionData getDescriptionDataByViewName(String viewName) {
    final List<String> viewNameList = viewName.split('_')..removeLast();
    return AppStoreCardDescriptionData(
      label: viewNameList.join(' ').toUpperCase(),
    );
  }
}
