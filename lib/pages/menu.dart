import 'package:flutter/material.dart';
import '../menu_manager.dart';

class MenuPage extends StatelessWidget {
  final String menuText;
  // Constructor
  MenuPage({this.menuText});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MenuManager(
        menuText: menuText,
      ),
    );
  }
}
