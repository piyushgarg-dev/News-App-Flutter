import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:expandable/expandable.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/web_view.dart';

String url;
void main() {
  runApp(MyNewsApp());
}

class MyNewsApp extends StatefulWidget {
  @override
  _MyNewsAppState createState() => _MyNewsAppState();
}

class _MyNewsAppState extends State<MyNewsApp> {
  bool darkMode = false;
  List articles = [];

  final apiurl =
      'https://newsapi.org/v2/everything?q=apple&from=2019-11-23&to=2019-11-23&sortBy=popularity&apiKey=fc47c3569df9477780b539cfd3a578a3';

  Future getData() async {
    http.Response response = await http.get(this.apiurl);
    Map<String, dynamic> resbody = await json.decode(response.body);
    // print(resbody['articles'][0]['source']['name']);

    setState(() {
      articles = resbody['articles'];
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return MaterialApp(
      title: 'News Buddy',
      debugShowCheckedModeBanner: false,
      theme: darkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('News Buddy'),
        ),
        body: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (BuildContext cntx, int index) {
            return NewsCard(
                articles[index]['author'],
                articles[index]['title'],
                articles[index]['description'],
                articles[index]['urlToImage'],
                articles[index]['url']);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              darkMode = !darkMode;
            });
          },
          child: darkMode
              ? Icon(FontAwesomeIcons.cloudSun)
              : Icon(FontAwesomeIcons.cloudMoon),
        ),
      ),
    );
  }
}

class NewsCard extends StatefulWidget {
  String author, title, content, imageurl, url;
  NewsCard(this.author, this.title, this.content, this.imageurl, this.url);
  @override
  _NewsCardState createState() => _NewsCardState(
      this.author, this.title, this.content, this.imageurl, this.url);
}

class _NewsCardState extends State<NewsCard> {
  String author, title, content, imageurl, url;
  _NewsCardState(
      this.author, this.title, this.content, this.imageurl, this.url);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MyWebView(this.url),
          ));
        },
        child: Container(
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                      borderRadius: new BorderRadius.circular(8.0),
                      child: Image.network(
                          this.imageurl != null ? this.imageurl : '')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpandablePanel(
                    header: Text(
                      this.title != null ? this.title : '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    collapsed: Text(
                      this.content != null ? this.content : '',
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Text(
                      this.content != null ? this.content : '',
                      softWrap: true,
                    ),
                    tapHeaderToExpand: true,
                    hasIcon: true,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
