import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

class DevScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget tabBar;

  const DevScaffold(
      {Key key, @required this.body, @required this.title, this.tabBar})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
              title: Text(title),
              elevation: 0,
              centerTitle: true,
              bottom: tabBar != null ? tabBar : null,
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
              ]),
          body: body,
        ),
      ),
    );
  }
}
