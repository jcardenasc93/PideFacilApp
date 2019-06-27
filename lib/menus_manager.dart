import 'package:flutter/material.dart';

import './pages/dishes_list.dart';
import './menu_model.dart';
import './platos_model.dart';

/// Manage the rendering of menus.
class MenusManager extends StatefulWidget {
  /// The list of menus.
  final List<Menu> listMenus;

  /// Inherited order.
  final List<Plato> orden;

  /// Function to update order.
  final Function(List<Plato>) getOrder;
  // MenusManager constructor.
  MenusManager({this.listMenus, this.orden, this.getOrder});

  @override
  State<StatefulWidget> createState() {
    return _MenusManagerState(listOfMenus: listMenus);
  }
}

/// State class for MenusManager.
class _MenusManagerState extends State<MenusManager> {
  /// The list of menus to be displayed.
  final List<Menu> listOfMenus;
  // Store order changes.
  List<Plato> ordenAct;
  // _MenusManagerState constructor.
  _MenusManagerState({this.listOfMenus});

  /// Displays the dishes list of the [menu] tapped and wait for order changes.
  void _tappedMenu(String texto, Menu menu, BuildContext context) async {
    /// Pass context to updates order values.
    final updatedOrder = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DishesPage(
                  menuText: texto,
                  menu: menu,
                  orden: widget.orden,
                )));

    /// Updates the order with last changes.
    setState(() {
      widget.getOrder(updatedOrder);
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
                  onTap: () => _tappedMenu(listOfMenus[index].nombreMenu,
                      listOfMenus[index], context),
                ),
                margin: EdgeInsets.all(2.0),
              );
            }),
      ],
    );
  }
}
