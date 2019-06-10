import 'package:flutter/material.dart';
import './pages/menu.dart';
import './menu_model.dart';
import './platos_model.dart';

class MenusManager extends StatefulWidget {
  final List<Menu> listMenus;

  MenusManager({this.listMenus});

  @override
  State<StatefulWidget> createState() {
    return _MenusManagerState(listOfMenus: listMenus);
  }
}

class _MenusManagerState extends State<MenusManager> {
  final List<Menu> listOfMenus;

  _MenusManagerState({this.listOfMenus});

  void _tappedMenu(String texto, Menu menu) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MenuPage(
                    menuText: texto,
                    menu: menu,
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
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: listOfMenus.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: new Text(listOfMenus[index].nombreMenu),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => _tappedMenu(
                      listOfMenus[index].nombreMenu, listOfMenus[index]),
                ),
                margin: EdgeInsets.all(2.0),
              );
            }),
      ],
    );
  }
}
