import 'package:flutter/material.dart';
import './pages/menu.dart';
import './menu_model.dart';

class MenusManager extends StatefulWidget {
  final List<Menu> list;
  MenusManager({this.list});

  @override
  State<StatefulWidget> createState() {
    return _MenusManagerState(listOfMenus: list);
  }
}

class _MenusManagerState extends State<MenusManager> {
  final List<Menu> listOfMenus;

  _MenusManagerState({this.listOfMenus});

  @override
  void initState() {
    super.initState();
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
                  onTap: () => _tappedMenu('Entradas'),
                ),
                margin: EdgeInsets.all(2.0),
              );
            }),
      ],
    );
  }
}
