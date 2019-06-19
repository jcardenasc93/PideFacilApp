import 'package:flutter/material.dart';

import './pages/dishes_list.dart';
import './menu_model.dart';
import './platos_model.dart';

/// Manage the rendering of menus.
class MenusManager extends StatefulWidget {
  /// The list of menus.
  final List<Menu> listMenus;
  var ordTest = <Plato>[];
  // MenusManager constructor.
  MenusManager({this.listMenus});

  @override
  State<StatefulWidget> createState() {
    return _MenusManagerState(listOfMenus: listMenus);
  }
}

/// State class for MenusManager.
class _MenusManagerState extends State<MenusManager> {
  /// The list of menus to be displayed.
  final List<Menu> listOfMenus;
  // _MenusManagerState constructor.
  _MenusManagerState({this.listOfMenus});

  /// Displays the dishes list of the [menu] tapped.
  void _tappedMenu(String texto, Menu menu) async {
    final updatedOrder = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DishesPage(
                  menuText: texto,
                  menu: menu,
                )));
    setState(() {
      widget.ordTest = updatedOrder;
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
        // Create a scrollable ListView of the menus.
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
