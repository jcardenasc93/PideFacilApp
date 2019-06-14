import 'package:flutter/material.dart';
import '../dishes_manager.dart';
import '../menu_model.dart';

/// Page that list all dishes of a menu.
class DishesPage extends StatelessWidget {
  /// The menu name.
  final String menuText;
  /// Menu object to be render.
  final Menu menu;
  // Constructor
  DishesPage({this.menuText, this.menu});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        // Add back button.
        leading: IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Color(0xFF666666),
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        // Display menu name on top center.
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
      // Render dishes in body.
      body: DishManager(
        //menuText: menuText,
        listPlatos: menu.platoMenu,
      ),
    );
  }
}
