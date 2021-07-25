import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/platos_model.dart';
import '../models/qr_model.dart';
import '../styles/app_style.dart';

/// Manage the order in the order view.
class OrderManager extends StatefulWidget {
  /// The user's order.
  final List<Plato> order;

  /// The QR object
  final QRobject qrobject;

  /// Function that clear the actual order.
  final Function resetOrder;

  OrderManager({this.order, this.qrobject, this.resetOrder});

  @override
  State<StatefulWidget> createState() {
    return OrderManagerState(orden: order);
  }
}

/// Update state of the order.
class OrderManagerState extends State<OrderManager> {
  /// The user's order.
  List<Plato> orden;
  OrderManagerState({this.orden});
  int _totalValorOrden = 0;

  /// The price wiht currency format.
  final formatPrice = new NumberFormat.simpleCurrency(decimalDigits: 0);

  var appTextStyle = AppTextStyle();

  /// Reduce minus 1 [orden(index).cantidad] if quantity is greater to zero
  void _restCant(int index) {
    setState(() {
      orden[index].cantidad > 0
          ? orden[index].cantidad--
          : orden[index].cantidad = 0;
      //Update the total value of the dish respect to the quantity.
      orden[index].precioTotalPlato =
          orden[index].precioPlato * orden[index].cantidad;
    });
    _updateTotalOrden();
  }

  /// Increases dish quantity [orden(index).cantidad].
  void _addCant(int index) {
    setState(() {
      orden[index].cantidad++;
      //Update the total value of the dish respect to the quantity.
      orden[index].precioTotalPlato =
          orden[index].precioPlato * orden[index].cantidad;
    });
    _updateTotalOrden();
  }

  /// Update the order total value when dishes quantity change.
  void _updateTotalOrden() {
    setState(() {
      _totalValorOrden = 0;
      orden.forEach((d) => _totalValorOrden += d.precioTotalPlato);
    });
  }

  void _addComments(int index, String comments) {
    setState(() {
      orden[index].comment = comments.trim();
    });
  }

  /// Displays a alert dialog to confirm the order deletion.
  Future _agregarObservacion(BuildContext context, int index) async {
    final _commentsController = TextEditingController();
    return showDialog(
        context: context,
        // User must choose an option to close dialog.
        barrierDismissible: false,
        builder: (BuildContext context) {
          /// Create the AlertDialog.
          return AlertDialog(
            title: new Text('Agrega observaciones a tu pedido',
                style: appTextStyle.alertTitle),
            content: new TextField(
                controller: _commentsController,
                decoration: InputDecoration(
                  hintText: 'Escribe tus observaciones aquí',
                  enabledBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColorPalette["primaryGreen"]),
                      borderRadius: new BorderRadius.circular(8.0)),
                  focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColorPalette["primaryGreen"]),
                      borderRadius: new BorderRadius.circular(8.0)),
                ),
                cursorColor: AppColorPalette["primaryGreen"], 
                maxLines: 5,
                maxLength: 100),
            // These are user options.
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'NO, VOLVER',
                  style: appTextStyle.textButton,
                ),
                color: Colors.grey.shade400,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton.icon(
                  color: AppColorPalette["primaryGreen"],
                  icon: Icon(Icons.check_circle_rounded, color: Colors.white),
                  label: Text('OK', style: appTextStyle.textButton),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addComments(index, _commentsController.text);
                  }),
            ],
          );
        });
  }

  /// Displays a alert dialog to confirm the order deletion.
  Future _confimacionEliminarOrden(BuildContext context) async {
    return showDialog(
        context: context,
        // User must choose an option to close dialog.
        barrierDismissible: false,
        builder: (BuildContext context) {
          /// Create the AlertDialog.
          return AlertDialog(
            title: new Text('Eliminar orden', style: appTextStyle.alertTitle),
            content: new Text('¿Estás seguro que quieres eliminar tu orden?'),
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
                  color: Colors.red,
                  icon: Icon(Icons.remove_circle, color: Colors.white),
                  label: Text('ELIMINAR', style: appTextStyle.textButton),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteOrder();
                  }),
            ],
          );
        });
  }

  /// Deletes all items in the actual order and return to [MenuListPage] page.
  _deleteOrder() {
    setState(() {
      orden.forEach((d) => d.cantidad = 0);
      orden.removeWhere((d) => d.nombrePlato != '');
      _totalValorOrden = 0;
    });

    /// Reset order to a clean one.
    widget.resetOrder();
    Navigator.pop(context);
  }

  /// Give the initial value to the final order from previews pages.
  @override
  void initState() {
    setState(() {
      orden.forEach((d) => d.precioTotalPlato = d.precioPlato * d.cantidad);
    });
    _updateTotalOrden();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;

    //* Initialise ScreenUtil instance
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);
    return Scaffold(
      appBar: new PreferredSize(
          preferredSize: Size.fromHeight(ScreenUtil.instance.setWidth(95.0)),
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(top: ScreenUtil.instance.setWidth(3.0)),
                child: Text(
                  "Tu orden",
                  style: new TextStyle(
                    fontSize: ScreenUtil.instance.setSp(18.0),
                    fontWeight: FontWeight.bold,
                    color: AppColorPalette["primaryGreen"]
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Card(
                elevation: ScreenUtil.instance.setWidth(3.5),
                child: ListTile(
                  title: Text('Total', style: appTextStyle.cardTitleStrong),
                  trailing: Text(
                    '${formatPrice.format(_totalValorOrden)}',
                    style: appTextStyle.cardTrailingBig,
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          )),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          // Create a scrollable ListView with the order list.
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: orden.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    // Display dish name.
                    title: new Row(
                      children: [
                        Expanded(
                          child: Text(orden[index].nombrePlato,
                              style: appTextStyle.cardSubtitle),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: ScreenUtil.instance.setWidth(13.5)),
                          child: Container(
                            // Add minus button.
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: new GestureDetector(
                              child: Icon(
                                Icons.message_rounded,
                                color: Colors.grey,
                                size: ScreenUtil.instance.setSp(24.0),
                              ),

                              /// Add comment to the selected dish
                              onTap: () => _agregarObservacion(context, index),
                            ),
                          ),
                        )
                      ],
                    ),
                    trailing: new SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil.instance.setWidth(5.0)),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // Display dish price.
                            new Text(
                              '${formatPrice.format(orden[index].precioTotalPlato)}',
                              style: appTextStyle.cardTrailingTinyStrong,
                              textAlign: TextAlign.end,
                            ),
                            // Display dish quantity control.
                            new Container(
                                margin: EdgeInsets.all(
                                    ScreenUtil.instance.setWidth(5.0)),
                                alignment: Alignment(0.0, 0.0),
                                child: new Center(
                                    child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      // Add minus button.
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        border: Border.all(
                                          color: Colors.redAccent,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new GestureDetector(
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: ScreenUtil.instance.setSp(18.0),
                                        ),

                                        /// Reduce minus 1 [orden(index).cantidad] if quantity is greater to zero
                                        onTap: () => _restCant(index),
                                      ),
                                    ),
                                    Container(
                                      width: ScreenUtil.instance.setWidth(35.0),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.0, vertical: 1.0),
                                        // Display dish quantity.
                                        child: new Text(
                                            orden[index].cantidad.toString(),
                                            textAlign: TextAlign.center,
                                            style:
                                                appTextStyle.cardTrailingTiny),
                                      ),
                                    ),
                                    Container(
                                      // Add plus button.
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        border: Border.all(
                                          color: Colors.greenAccent,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new GestureDetector(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: ScreenUtil.instance.setSp(18.0),
                                        ),

                                        /// Increases dish quantity.
                                        onTap: () => _addCant(index),
                                      ),
                                    )
                                  ],
                                ))),
                          ],
                        ),
                      ),
                      width: ScreenUtil.instance.setWidth(100.0),
                    ),
                  ),
                  margin: EdgeInsets.all(2.0),
                );
              }),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _confimacionEliminarOrden(context);
              },
              tooltip: "Eliminar orden",
              color: Colors.redAccent,
              padding: EdgeInsets.all(2.0),
              iconSize: ScreenUtil.instance.setSp(28.0),
            ),
          )
        ],
      ),
    );
  }
}
