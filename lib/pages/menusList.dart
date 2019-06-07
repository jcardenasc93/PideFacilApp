import 'package:flutter/material.dart';
import '../styles/menu_style.dart';
import '../menus_manager.dart';

class MenusListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: menuTheme,
      home: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Image.network(
                    'https://st2.depositphotos.com/8301258/11963/v/950/depositphotos_119634124-stock-illustration-restaurant-logo-cutlery-design.jpg',
                  ),
                ),
                new Text(
                  'El Hambriento',
                  style: new TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF666666)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: MenusManager()),
    );
  }
}
