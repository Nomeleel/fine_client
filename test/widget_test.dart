// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fine_client/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  test('parseLyric', () {
    print('start prase');
    //final String lyricStr = await rootBundle.loadString('assets/lyrics/Mojito.lrc');
    const String lyricStr = '''[00:16.80]麻烦给我的爱人来一杯Mojito
    [00:20.98]我喜欢阅读她微醺时的眼眸
    [00:25.10]而我的咖啡糖不用太多
    ''';
    //print(lyricStr);
    final RegExp regExp = RegExp(r'\[(?<min>\d{2}):(?<sec>\d{2}).(?<mil>\d{2})](?<str>.*)', multiLine: true);
    //print(regExp.stringMatch(lyricStr));

    regExp.allMatches(lyricStr).forEach((RegExpMatch element) {
      print(int.parse(element.namedGroup('min')!));
    });

 
  });
}
