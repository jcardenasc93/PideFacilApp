import 'package:flutter/material.dart';
import '../dishes_manager.dart';
import '../menu_model.dart';
import './order_view.dart';
import '../platos_model.dart';

/// Page that list all dishes of a menu.
class DishesPage extends StatefulWidget {
  /// The menu name.
  final String menuText;

  /// Menu object to be render.
  final Menu menu;

  /// The order.
  final List<Plato> orden;
  // Constructor
  DishesPage({this.menuText, this.orden, this.menu});

  @override
  State<StatefulWidget> createState() {
    return DishesPageState(orderUpdated: orden);
  }
}

class DishesPageState extends State<DishesPage> {
  List<Plato> orderUpdated;
  DishesPageState({this.orderUpdated});
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showFinalOrderCallback;

  /// Back to Menu's view and pass the last order update.
  _backToMenus(BuildContext context) {
    Navigator.pop(context, orderUpdated);
  }

  ///Update the order with a given value.
  updateOrder(newOrder) {
    setState(() {
      newOrder.forEach((d) => orderUpdated.add(d));
      // Delete repeated items in the order.
      orderUpdated = orderUpdated.toSet().toList();
    });
  }

  /// Controls button behavior in function of empty order.
  FloatingActionButton _manageButton() {
    FloatingActionButton ordenButton;
    Color emptyColor = new Color(0xFFEAECEF);
    Color orderColor = new Color(0xFF00E676);
    // Search for dishes with quantity major to zero.
    var orden = orderUpdated.where((d) => d.cantidad > 0);
    // If orden is empty disable button.
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
        onPressed: _showFinalOrderCallback,
      );
    }
    return ordenButton;
  }

  @override
  void initState() {
    super.initState();
    // Disable action on the button.
    _showFinalOrderCallback = _showOrderFun;
  }

  /// Controls the callback of the bottom sheet
  void _showOrderFun() {
    /// Give a init state to the callback.
    setState(() {
      _showFinalOrderCallback = null;
    });
    // Create the OrderView in the showBottomSheet in the current context.
    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return OrderView(orden: orderUpdated);
        })
        .closed
        .whenComplete(() {
          // Once complete check if still mounted and update callback value.
          if (mounted) {
            setState(() {
              _showFinalOrderCallback = _showOrderFun;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        // Add back button.
        leading: IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Color(0xFF666666),
          ),
          onPressed: () {
            _backToMenus(context);
          },
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
