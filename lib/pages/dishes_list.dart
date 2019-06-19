import 'package:flutter/material.dart';
import '../dishes_manager.dart';
import '../menu_model.dart';
import '../platos_model.dart';

/// Page that list all dishes of a menu.
class DishesPage extends StatefulWidget {
  /// The menu name.
  final String menuText;

  /// Menu object to be render.
  final Menu menu;
  // Constructor
  DishesPage({this.menuText, this.menu});

  @override
  State<StatefulWidget> createState() {
    return DishesPageState();
  }
}

class DishesPageState extends State<DishesPage> {
  var orderUpdated = <Plato>[];
  _backToMenus(BuildContext context) {
    Navigator.pop(context, orderUpdated);
  }

  updateOrder(newOrder) {
    setState(() {
      newOrder.forEach((d) => orderUpdated.add(d));
    });
  }

  FloatingActionButton _manageButton() {
    FloatingActionButton ordenButton;
    Color emptyColor = new Color(0xFFEAECEF);
    Color orderColor = new Color(0xFF00E676);
    var orden = orderUpdated.where((d) => d.cantidad > 0);
    if (orden.isEmpty) {
      ordenButton = FloatingActionButton(
        backgroundColor: emptyColor,
        child: Icon(
          Icons.playlist_add_check,
          color: Colors.white,
        ),
        onPressed: () {},
      );
    } else {
      ordenButton = FloatingActionButton(
        backgroundColor: orderColor,
        child: Icon(
          Icons.playlist_add_check,
          color: Colors.white,
        ),
        onPressed: () {},
      );
    }
    return ordenButton;
  }

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
          //onPressed: _backToMenus(context),
          onPressed: () {Navigator.pop(context);},
        ),
        // Display menu name on top center.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.menuText,
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
        listPlatos: widget.menu.platoMenu,
        updateOrder: updateOrder,
      ),
      floatingActionButton: _manageButton(),
    );
  }
}
