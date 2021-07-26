import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './styles/app_style.dart' as main_style;
import './config/config.dart';
import './pages/home.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  String environment = dotenv.env["ENVIRONMENT"];
  Environment().initConfig(environment);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Main Widget.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pide Facil',
      theme: main_style.appTheme,
      home: HomePage(),
    );
  }
}
