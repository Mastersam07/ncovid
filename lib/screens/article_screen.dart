import 'dart:async';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

class ArticleView extends StatefulWidget {
  final String postUrl;
  ArticleView({@required this.postUrl});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: <Widget>[
            CachedNetworkImage(
                imageUrl:
                    "https://img.icons8.com/dusk/64/000000/activity-feed-2.png"),
            Text(
              "Corona",
              style:
                  TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
            ),
            Text(
              "News",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.lightbulb_outline,
            ),
            onPressed: () {
              DynamicTheme.of(context).setBrightness(
                  Theme.of(context).brightness == Brightness.dark
                      ? Brightness.light
                      : Brightness.dark);
              print('changed theme!');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
            ),
            onPressed: () {
              Share.share(
                  "Download the Covid-19 Awareness App and share with your friends and loved ones.\nAwareness App -  https://bit.ly/releasetojuwa");
            },
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: widget.postUrl,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
