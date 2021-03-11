import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  const BasePage({Key key, this.topBar, this.body}) : super(key: key);

  final Widget topBar;

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          topBar,
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar(
      {Key key,
      this.backAction,
      this.title,
      this.nextActionLabel = '下一步',
      this.nextAction})
      : super(key: key);

  final VoidCallback backAction;
  final String title;
  final String nextActionLabel;
  final VoidCallback nextAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF232323),
      height: 40 + MediaQueryData.fromWindow(window).padding.top,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 7.0),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: 60,
            height: 30,
            child: GestureDetector(
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.arrow_back_ios),
              ),
              onTap: () {
                if (backAction == null) {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context
                        .findRootAncestorStateOfType<NavigatorState>()
                        ?.pop();
                  }
                } else {
                  backAction();
                }
              },
            ),
          ),
          Expanded(
            child: Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            height: 30,
            child: CupertinoButton(
              child: Text(
                nextActionLabel,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
              color: Colors.green[500],
              padding: EdgeInsets.zero,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              onPressed: nextAction,
            ),
          ),
        ],
      ),
    );
  }
}
