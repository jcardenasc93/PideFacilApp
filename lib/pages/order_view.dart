import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pide_facil/scale_ui.dart';

import '../managers/order_manager.dart';
import '../models/platos_model.dart';
import './order_resume.dart';
import '../models/qr_model.dart';
import '../models/post.dart';

/// The view order for the user.
class OrderView extends StatefulWidget {
  /// The user's order.
  final List<Plato> orden;

  /// The QR object
  final QRobject qrobject;

  // OrderView constructor.
  OrderView({this.orden, this.qrobject});

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
                child: Text('NO, VOLVER'),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text('SI'),
                  color: Color(0xFF00E676),
                  onPressed: () {
                    // Hide dialog box.
                    Navigator.of(context).pop();
                    _ordenar();
                  })
            ],
          );
        });
  }

  /// Shows alert message when the user confirm an empty order.
  Future _ordenVaciaMsj(BuildContext context) async {
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

  /// Shows alert message when the system cannot post the order.
  Future _errorPost(BuildContext context) async {
    /// Creates alert dialog.
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              'Error de envío',
              style: TextStyle(
                color: Color(0xFF666666),
              ),
            ),
            content: new Text(
                'Lo sentimos. No pudimos enviar tu orden, verifica tu conexión a internet e inténtalo nuevamente'),
            actions: <Widget>[
              FlatButton(
                child: Center(
                  child: Text('OK'),
                ),
                color: Color(0xFF00E676),
                // Back when pressed.
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  /// Shows alert message when the system cannot post the order.
  Future _networkFail(BuildContext context) async {
    /// Creates alert dialog.
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              'Error de envío',
              style: TextStyle(
                color: Color(0xFF666666),
              ),
            ),
            content: new Text(
                'Lo sentimos. No pudimos enviar tu orden, verifica tu conexión a internet e inténtalo nuevamente'),
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

  /// Shows alert message when the system post the order successfully.
  Future _postSuccess(BuildContext context) async {
    /// Creates alert dialog.
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              'Success',
              style: TextStyle(
                color: Color(0xFF00E676),
              ),
            ),
            content: new Text('Tu orden fue enviada correctamente'),
            actions: <Widget>[
              FlatButton(
                child: Center(
                  child: Text('OK'),
                ),
                color: Color(0xFF00E676),
                // Back when pressed.
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  /// Shows alert message while system post the order
  static _postingOrder(BuildContext context) {
    /// Creates alert dialog.
    try {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  new CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Color(0xFF00E676)),
                    strokeWidth: 3.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Flexible(
                      flex: 8,
                      child: Text(
                        'Estamos enviando tu orden',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }

  /// Send the final order to start cook the dishes.
  void _ordenar() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Only the dishes with quantity greater than zero are passed.
        var ordenF = order.where((d) => d.cantidad > 0);
        List<Plato> ordenFinal = [];
        // Check if the order is empty
        if (ordenF.isNotEmpty) {
          _postingOrder(context);
          // Create json data to post the order
          PostApi post = _createPostRequest();
          // Make the POST request to the API
          int orderID = await _makePost(post);
          if (orderID != 0) {
            // Add each dish to the final order.
            ordenF.forEach((d) => ordenFinal.add(d));
            // Calcs total value
            int _totalValorOrden = 0;
            ordenF.forEach((d) => _totalValorOrden += d.precioTotalPlato);
            // Change view to order resume.
            _postSuccess(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => OrderResume(
                          idRestaurante: widget.qrobject.idRestaurante,
                          idMesa: widget.qrobject.idMesa,
                          orden: ordenFinal,
                          valorTotal: _totalValorOrden,
                          orderID: orderID,
                        )));
          } else {
            _errorPost(context);
          }
        } else {
          _ordenVaciaMsj(context);
        }
      }
    } on SocketException catch (_) {
      _networkFail(context);
    }
  }

  /// Create a [PostApi] object to create the json body.
  PostApi _createPostRequest() {
    // Calc the order total price.
    var _precioTotal = 0;
    // Transform the order list to a json
    List jsonOrden = Plato.encodeToJson(order);

    order.forEach((d) => _precioTotal += d.precioTotalPlato);
    // Create the [PostApi] object with the data.
    PostApi data = PostApi(
        idRestaurante: widget.qrobject.idRestaurante,
        idMesa: widget.qrobject.idMesa,
        precioTotal: _precioTotal,
        ordenListJson: jsonOrden);
    return data;
  }

  /// Make the post request to the API.
  Future<int> _makePost(PostApi data) {
    // var to check the result of the post
    var postResult = data.postRequest(data);
    return postResult;
  }

  void clearOrder() {
    setState(() {
      order = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    ScaleUI().init(context);
    return Scaffold(
        backgroundColor: Color(0xFF00E676),
        //backgroundColor: Colors.white12,

        /// Custom appBar for change size.
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(ScaleUI.blockSizeVertical * 5.0),
          // AppBar title.
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.drag_handle,
                  color: Colors.white,
                ),
              ]),
        ),
        // Create the order manager for updates.
        body: OrderManager(
          order: order,
          qrobject: widget.qrobject,
          resetOrder: clearOrder,
        ),
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
                  fontSize: ScaleUI.safeBlockHorizontal * 5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Colors.white,
              highlightColor: Colors.white54,
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
