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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Color(0xFF666666),
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              menuText,
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
            new Divider(
              color: Colors.grey,
              height: 1.5,
              indent: 5.5,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: MenuManager(
        menuText: menuText,
        listPlatos: menu.platoMenu,
      ),
    );
  }
}
