import 'package:flutter/material.dart';
import '../styles/menu_style.dart';
import '../menus_manager.dart';
import '../restaurante_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class MenusListPage extends StatefulWidget {
  final String urlApiGet;

  MenusListPage({this.urlApiGet});

  Future<Restaurante> getRestaurante() async {
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
  final Future<Restaurante> restaurante;
  _MenusListState({this.restaurante});

  String imageUrl =
      'https://laherradura.com.co/wp-content/uploads/2017/08/frisby-logo.png';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: menuTheme,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
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
                child: FutureBuilder<Restaurante>(
                  future: restaurante,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.network(imageUrl);
                      //return Image.network(snapshot.data.urlImagRestaurante);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return new SizedBox(
                      child: Container(),
                      height: 25.0,
                      width: 25.0,
                    );
                  },
                ),
              ),
              FutureBuilder<Restaurante>(
                future: restaurante,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data.nombreRestaurante,
                      style: new TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF666666)),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return new SizedBox(
                    child: new CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Color(0xFF666666)),
                      strokeWidth: 3.0,
                    ),
                    height: 25.0,
                    width: 25.0,
                  );
                },
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<Restaurante>(
          future: restaurante,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MenusManager(
                list: snapshot.data.menus,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
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
