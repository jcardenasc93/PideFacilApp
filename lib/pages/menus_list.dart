import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../styles/menu_style.dart';
import '../menus_manager.dart';
import '../restaurante_model.dart';

/// Page that list all the menus of a restaurant.
class MenusListPage extends StatefulWidget {
  /// The API get url.
  final String urlApiGet;
  // MenusListPage constructor
  MenusListPage({this.urlApiGet});

  /// Returns an [Restaurante] object if the API request is successful
  Future<Restaurante> getRestaurante() async {
    /// The response of the API get request.
    final response =
        await http.get(urlApiGet, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      return Restaurante.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to get restaurant info');
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _MenusListState(restaurante: getRestaurante());
  }
}

class _MenusListState extends State<MenusListPage> {
  /// The restaurant object to be displayed
  final Future<Restaurante> restaurante;
  // _MenusListState constructor.
  _MenusListState({this.restaurante});
  // TODO: Delete this variable after assets can be stored on server.
  String imageUrl =
      'https://laherradura.com.co/wp-content/uploads/2017/08/frisby-logo.png';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: menuTheme,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          // Add 'scan QR' button on top left.
          leading: IconButton(
            icon: new Icon(
              const IconData(0xe900, fontFamily: 'Qrcode'),
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
                // Display restaurant Image on top center.
                child: FutureBuilder<Restaurante>(
                  future: restaurante,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.network(imageUrl);
                      //return Image.network(snapshot.data.urlImagRestaurante);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // While get image returns nothing.
                    return new SizedBox();
                  },
                ),
              ),
              // Optional restaurant text to be displayed on top center.
              FutureBuilder<Restaurante>(
                future: restaurante,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      //snapshot.data.nombreRestaurante,
                      '',
                      style: new TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF666666)),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // While get restaurant name display nothing.
                  return new SizedBox();
                },
              ),
            ],
          ),
          centerTitle: true,
        ),
        // Display the menus list of the restaurant.
        body: FutureBuilder<Restaurante>(
          future: restaurante,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MenusManager(
                listMenus: snapshot.data.menus,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // While get the menus list displays a circular progress indicator.
            return new Center(
              child: SizedBox(
                child: new CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xFF666666)),
                  strokeWidth: 3.0,
                ),
                height: 50.0,
                width: 50.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
