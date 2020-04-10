import 'package:flutter/material.dart';
import 'package:tojuwa/screens/homepage.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              primarySwatch: Colors.indigo,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Toju wa',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: Home(),
          );
        });
  }
}
