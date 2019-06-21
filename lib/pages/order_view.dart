import 'package:flutter/material.dart';
import '../styles/app_style.dart';

import '../order_manager.dart';
import '../platos_model.dart';

/// The view order for the user.
class OrderView extends StatefulWidget {
  /// The user's order.
  final List<Plato> orden;
  // OrderView constructor.
  OrderView({this.orden});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderViewState(order: orden);
  }
}
/// Update state of the view.
class OrderViewState extends State<OrderView> {
  /// The user's order.
  List<Plato> order;

  OrderViewState({this.order});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: AppTheme,
        home: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            // Add back button on top left.
            leading: IconButton(
              icon: new Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Tu orden",
                    style: new TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ]),
            centerTitle: true,
          ),
          // Create the order manager for updates.
          body: OrderManager(order: order),
        ));
  }
}
