import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class GithubTrendingView extends StatefulWidget {
  const GithubTrendingView({Key? key}) : super(key: key);

  @override
  _GithubTrendingViewState createState() => _GithubTrendingViewState();
}

class _GithubTrendingViewState extends State<GithubTrendingView> {
  final Dio _dio = Dio();
  late List<TrendingItem> _trendingList = <TrendingItem>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 100.0,
            alignment: Alignment.center,
            child: TextButton(
              child: const Text('Go'),
              onPressed: () async {
                _trendingList = await getTrendingList();
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _trendingList.length,
              itemBuilder: (BuildContext context, int index) {
                final TrendingItem item = _trendingList[index];
                return Container(
                  height: 50.0,
                  color: Color(item.languageHexColor ?? 0xffffffff),
                  alignment: Alignment.centerLeft,
                  child: Text(item.repository ?? ''),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1.0,
                  thickness: 1.0,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.black.withOpacity(0.7),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<List<TrendingItem>> getTrendingList() async {
    final Response<dynamic> html = await _dio.get<dynamic>('https://github.com/trending');
    final dom.Document document = parser.parse(html.data);
    print(document.getElementsByTagName('article').length);
    final List<dom.Element> elements = document.getElementsByTagName('article');
    print('----------------------------Found ${elements.length} repositories--------------------------------');
    elements.forEach(parseArticle);

    return _trendingList;
  }

  void parseArticle(dom.Element article) {
    final TrendingItem trendingItem = TrendingItem();
    // Repo
    trendingItem.repository = article.getElementsByTagName('a')[1].attributes['href']?.substring(1);
    // Description
    final List<dom.Element> description = article.getElementsByTagName('p');
    if (description.isNotEmpty) {
      trendingItem.description = description.first.text.trim();
    }
    // Language
    final List<dom.Element> lang = article.getElementsByClassName('repo-language-color');
    if (lang.isNotEmpty) {
      trendingItem.languageHexColor = int.parse(lang[0].attributes['style']!.split(' ')[1].replaceFirst('#', '0xff'));
      trendingItem.language = lang[0].nextElementSibling?.text.trim();
    }
    // Start & Fork
    final List<dom.Element> startFork = article.getElementsByClassName('muted-link d-inline-block mr-3');
    trendingItem.startStr = startFork[0].text.trim();
    trendingItem.forkStr = startFork[1].text.trim();
    // Trending
    trendingItem.trending = article.getElementsByClassName('d-inline-block float-sm-right')[0].text.trim();
    print(trendingItem);
    _trendingList.add(trendingItem);
    print('------------------------------------------------------------');
  }
}

class TrendingItem {
  TrendingItem({
    this.repository,
    this.description,
    this.languageHexColor,
    this.language,
    this.startStr,
    this.forkStr,
    this.trending,
  });

  String? repository;
  String? description;
  int? languageHexColor;
  String? language;
  String? startStr;
  String? forkStr;
  String? trending;

  @override
  String toString() {
    return 'Repository: $repository;\nDescription: $description;\nLanguage: $languageHexColor-$language;\nStart: $startStr;\nFork: $forkStr;\nTrending: $trending;';
  }
}
