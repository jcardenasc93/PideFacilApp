import 'package:flutter/material.dart';
import '../styles/menu_style.dart';
import '../menus_manager.dart';

class MenusListPage extends StatelessWidget {
  final String pageTitle;
  final String imageUrl;

  MenusListPage({this.pageTitle, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: menuTheme,
      home: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(
                Icons.camera_alt,
                color: Color(0xFF666666),
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Image.network(imageUrl),
                ),
                new Text(
                  pageTitle,
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
