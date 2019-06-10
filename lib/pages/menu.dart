import 'package:flutter/material.dart';
import '../menu_manager.dart';
import '../menu_model.dart';

class MenuPage extends StatelessWidget {
  final String menuText;
  final Menu menu;
  // Constructor
  MenuPage({this.menuText, this.menu});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MenuManager(
        menuText: menuText,
        listPlatos: menu.platoMenu,
      ),
    );
  }
}
