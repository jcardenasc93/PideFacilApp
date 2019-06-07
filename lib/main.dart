import 'package:flutter/material.dart';
import './styles/app_style.dart' as Style;
import './pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pide Facil',
      theme: Style.AppTheme,
      home: HomePage(),
    );
  }
}