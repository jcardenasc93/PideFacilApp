import 'package:flutter/material.dart';
import '../menus_manager.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pide Facil',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: MenusManager(),
    );
  }
}
