import 'package:flutter/material.dart';

import './styles/app_style.dart' as main_style;
import './pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Main Widget.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeU',
      theme: main_style.AppTheme,
      home: HomePage(),
    );
  }
}