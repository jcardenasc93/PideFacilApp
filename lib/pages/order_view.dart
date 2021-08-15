import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../managers/order_manager.dart';
import '../models/platos_model.dart';
import './order_resume.dart';
import '../models/qr_model.dart';
import '../models/post_order.dart';
import '../styles/app_style.dart';

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

  var appTextStyle = AppTextStyle();

  /// Displays a alert dialog to confirm the order.
  Future _confimacionOrden(BuildContext context) async {
    return showDialog(
        context: context,
        // User must choose an option to close dialog.
        barrierDismissible: false,
        builder: (BuildContext context) {
          /// Create the AlertDialog.
          return AlertDialog(
            title:
                new Text('Confirma tu orden', style: appTextStyle.alertTitle),
            content:
                new Text('¿Tu orden esta completa?', style: appTextStyle.body),
            // These are user options.
            actions: <Widget>[
              FlatButton(
                child: Text('NO, VOLVER', style: appTextStyle.textButton),
                color: Colors.grey.shade400,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton.icon(
                  label: Text('OK', style: appTextStyle.textButton),
                  icon: Icon(Icons.check_circle_rounded, color: Colors.white),
                  color: AppColorPalette["primaryGreen"],
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
            title:
                new Text('Tu orden esta vacía', style: appTextStyle.alertTitle),
            content: new Text(
                'Lo sentimos! No podemos procesar tu pedido porque tu orden no tiene platos. Por favor verifica tu orden.',
                style: appTextStyle.body),
            actions: <Widget>[
              FlatButton(
                child: Center(
                  child: Text('OK', style: appTextStyle.textButton),
                ),
                color: AppColorPalette["primaryGreen"],
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
            title: new Text('Error de envío', style: appTextStyle.alertTitle),
            content: new Text(
                'Lo sentimos no pudimos enviar tu orden. Verifica tu conexión a internet e inténtalo nuevamente',
                style: appTextStyle.body),
            actions: <Widget>[
              FlatButton(
                child: Center(
                  child: Text('OK'),
                ),
                color: AppColorPalette["primaryGreen"],
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
            title: new Text('Error de envío', style: appTextStyle.alertTitle),
            content: new Text(
                'Lo sentimos. No pudimos enviar tu orden, verifica tu conexión a internet e inténtalo nuevamente',
                style: appTextStyle.body),
            actions: <Widget>[
              FlatButton(
                child: Center(
                  child: Text('OK'),
                ),
                color: AppColorPalette["primaryGreen"],
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
              'Completado',
              style: TextStyle(
                color: AppColorPalette["primaryGreen"],
              ),
            ),
            content: new Text('Tu orden fue enviada correctamente',
                style: appTextStyle.body),
            actions: <Widget>[
              FlatButton(
                child: Center(
                  child: Text('OK', style: appTextStyle.textButton),
                ),
                color: AppColorPalette["primaryGreen"],
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
    var appTextStyle = AppTextStyle();
    try {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        AppColorPalette["primaryGreen"]),
                    strokeWidth: 3.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Flexible(
                      flex: 8,
                      child: Text('Estamos enviando tu orden',
                          style: appTextStyle.alertTitle)),
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
          PostOrder post = _createPostRequest();
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

  /// Create a [PostOrder] object to create the json body.
  PostOrder _createPostRequest() {
    // Calc the order total price.
    var _precioTotal = 0;
    // Transform the order list to a json
    List jsonOrden = Plato.encodeToJson(order);

    order.forEach((d) => _precioTotal += d.precioTotalPlato);
    // Create the [PostOrder] object with the data.
    PostOrder data = PostOrder(
        idRestaurante: widget.qrobject.idRestaurante,
        idMesa: widget.qrobject.idMesa,
        precioTotal: _precioTotal,
        ordenListJson: jsonOrden);
    return data;
  }

  /// Make the post request to the API.
  Future<int> _makePost(PostOrder data) {
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
    // WillPopScope disables back action on Android devices.
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;

    //* Initialise ScreenUtil instance
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);
    return Scaffold(
        backgroundColor: AppColorPalette["primaryGreen"],
        //backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,

        /// Custom appBar for change size.
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(ScreenUtil.instance.setHeight(40.0)),
          // AppBar title.
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.drag_handle,
                  color: Colors.white,
                  size: ScreenUtil.instance.setSp(20.0),
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
            padding: EdgeInsets.all(ScreenUtil.instance.setWidth(8.0)),
            child: RaisedButton(
              onPressed: () {
                _confimacionOrden(context);
              },
              child: Text(
                'Ordenar',
                style: TextStyle(
                  color: AppColorPalette["primaryGreen"],
                  fontSize: ScreenUtil.instance.setSp(20.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              color: Colors.white,
              highlightColor: Colors.white54,
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                    color: AppColorPalette["primaryGreen"], width: 2.0),
              ),
            ),
          ),
        ));
  }
}
