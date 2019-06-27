import 'package:flutter/material.dart';

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
    return OrderViewState(order: orden);
  }
}

/// Update state of the view.
class OrderViewState extends State<OrderView> {
  /// The user's order.
  List<Plato> order;
  // OrderViewState constructor
  OrderViewState({this.order});

  /// Displays a alert dialog to confirm the order.
  Future _confimacionOrden(BuildContext context) async {
    return showDialog(
        context: context,
        // User must choose an option to close dialog.
        barrierDismissible: false,
        builder: (BuildContext context) {
          /// Create the AlertDialog.
          return AlertDialog(
            title: new Text(
              'Confirma tu orden',
              style: TextStyle(
                color: Color(0xFF666666),
              ),
            ),
            content: new Text('¿Tu orden esta completa?'),
            // These are user options.
            actions: <Widget>[
              FlatButton(
                child: Text('NO. VOLVER'),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text('SI'),
                  color: Color(0xFF00E676),
                  onPressed: () {
                    // TODO: Cambiar a la vista de resumen de orden.
                    Navigator.of(context).pop();
                    _ordenar();
                  })
            ],
          );
        });
  }

  /// Shows alert message when the user confirm an empty order.
  _ordenVaciaMsj(BuildContext context) {
    /// Creates alert dialog.
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              'Tu orden esta vacía',
              style: TextStyle(
                color: Color(0xFF666666),
              ),
            ),
            content: new Text(
                'Lo sentimos. No podemos procesar tu pedido porque tu orden no tiene platos. Por favor verifica tu orden.'),
            actions: <Widget>[
              FlatButton(
                child: Center(
                  child: Text('OK'),
                ),
                color: Color(0xFF00E676),
                // Back when pressed.
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  /// Send the final order to start cook the dishes.
  _ordenar() {
    print('-' * 20);
    // Only the dishes with quantity greater than zero are passed.
    var ordenFinal = order.where((d) => d.cantidad > 0);
    // Check if the order is empty
    if (ordenFinal.isNotEmpty)
      ordenFinal.forEach((d) => print(d.nombrePlato));
    else
      _ordenVaciaMsj(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF58B368),

        /// Custom appBar for change size.
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          // AppBar title.
          child: Row(
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
        ),
        // Create the order manager for updates.
        body: OrderManager(order: order),
        // Create the bottom button to order.
        bottomNavigationBar: new Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
              onPressed: () {
                _confimacionOrden(context);
              },
              child: Text(
                'Ordenar',
                style: TextStyle(
                  color: Color(0xFF00E676),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Colors.white,
              highlightColor: Colors.white60,
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: Color(0xFF00E676), width: 2.0),
              ),
            ),
          ),
        ));
  }
}
