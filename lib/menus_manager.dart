import 'package:flutter/material.dart';
import './pages/menu.dart';
import './menu_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MenusManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenusManagerState();
  }
}

class _MenusManagerState extends State<MenusManager> {
  List<Menu> list = List();
  var loading = false;
  String url = 'https://pidefacil-back.herokuapp.com/menu_list/';

  _getMenus() async {
    setState(() {
      loading = true;
    });
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      setState(() {
        list = (json.decode(utf8.decode(response.bodyBytes)) as List)
            .map((data) => new Menu.fromJson(data))
            .toList();
        loading = false;
      });
    } else {
      throw Exception('Failed to get menus');
    }
  }

  @override
  void initState() {
    super.initState();
    _getMenus();
  }

  void _tappedMenu(String texto) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MenuPage(
                    menuText: texto,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        new Divider(
          color: Colors.grey,
          height: 1.5,
          indent: 5.5,
        ),
        loading
            ? new Center(
                child: new Padding(
                padding: const EdgeInsets.all(15.0),
                child: new CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xFF666666)),
                  strokeWidth: 3.0,
                ),
              ))
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: new Text(list[index].nombreMenu),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () => _tappedMenu('Entradas'),
                    ),
                    margin: EdgeInsets.all(2.0),
                  );
                }),
      ],
    );
  }
}
