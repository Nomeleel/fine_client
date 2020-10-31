import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class GithubTrendingView extends StatefulWidget {
  const GithubTrendingView({Key key}) : super(key: key);

  @override
  _GithubTrendingViewState createState() => _GithubTrendingViewState();
}

class _GithubTrendingViewState extends State<GithubTrendingView> {
  Dio _dio;
  List<String> _trendingList;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _trendingList = <String>[];
  }

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
            child: RaisedButton(
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
                return Container(
                  height: 50.0,
                  color: Colors.primaries[index % 15],
                  alignment: Alignment.centerLeft,
                  child: Text(_trendingList[index]),
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

  Future<List<String>> getTrendingList() async {
    final Response<dynamic> html = await _dio.get<dynamic>('https://github.com/trending');
    final dom.Document document = parser.parse(html.data);
    print(document.getElementsByTagName('article').length);
    final List<dom.Element> elements = document.getElementsByTagName('article');
    print('----------------------------Found ${elements.length} repositories--------------------------------');
    elements.forEach(parseArticle);

    return _trendingList;
  }

  void parseArticle(dom.Element article) {
    // Repo
    final String repo = article.getElementsByTagName('a')[1].attributes['href'].substring(1);
    print('Repo: $repo');
    _trendingList.add(repo);
    // Description
    final List<dom.Element> description = article.getElementsByTagName('p');
    if (description.isNotEmpty) {
      print('Description: ${description.first.text.trim()}');
    }
    // Language
    final List<dom.Element> lang = article.getElementsByClassName('repo-language-color');
    if (lang.isNotEmpty) {
      print('Language: ${lang[0].attributes["style"].split(" ")[1] + "-" + lang[0].nextElementSibling.text.trim()}');
    }
    // Start & Fork
    final List<dom.Element> startFork = article.getElementsByClassName('muted-link d-inline-block mr-3');
    print('Start: ${startFork[0].text.trim()}');
    print('Fork: ${startFork[1].text.trim()}');
    // Trending
    print(article.getElementsByClassName('d-inline-block float-sm-right')[0].text.trim());
    print('------------------------------------------------------------');
  }
}
