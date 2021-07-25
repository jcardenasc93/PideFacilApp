import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../managers/dishes_manager.dart';
import '../models/menu_model.dart';
import './order_view.dart';
import '../models/platos_model.dart';
import '../models/qr_model.dart';
import '../styles/app_style.dart';

/// Page that list all dishes of a menu.
class DishesPage extends StatefulWidget {
  /// The menu name.
  final String menuText;

  /// Menu object to be render.
  final Menu menu;

  /// The order.
  final List<Plato> orden;

  /// The QR object
  final QRobject qrobject;
  // Constructor
  DishesPage({this.menuText, this.orden, this.menu, this.qrobject});

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
      var orden = orderUpdated.where((d) => d.cantidad > 0);
      orderUpdated = [];
      orden.forEach((d) => orderUpdated.add(d));
    });
  }

  /// Clear the actual order.
  clearOrder() {
    setState(() {
      orderUpdated = [];
    });
  }

  /// Controls button behavior in function of empty order.
  FloatingActionButton _manageButton() {
    FloatingActionButton ordenButton;
    Color emptyColor = new Color(0xFFEAECEF);
    Color orderColor = AppColorPalette["primaryGreen"];
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
          return OrderView(orden: orderUpdated, qrobject: widget.qrobject);
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
    // WillPopScope disables back action on Android devices.
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;

    //* Initialise ScreenUtil instance
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            // Add back button.
            leading: IconButton(
              icon: new Icon(
                Icons.arrow_back,
                color: AppColorPalette["defaultAccent"],
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
                      fontSize: ScreenUtil.instance.setSp(18.0),
                      fontWeight: FontWeight.bold,
                      color: AppColorPalette["defaultAccent"]),
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
            clearOrder: clearOrder,
            order: orderUpdated,
          ),
          floatingActionButton: _manageButton(),
        ));
  }
}
