import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/platos_model.dart';
import '../styles/app_style.dart';

/// Manage the dishes rendering.
class DishManager extends StatefulWidget {
  /// The dishes list.
  final List<Plato> listPlatos;

  /// Function to update the order.
  final Function(List<Plato>) updateOrder;

  /// Function to reset order
  final Function clearOrder;

  /// Function to get order
  final List<Plato> order;

  // DishManager constructor.
  DishManager({this.listPlatos, this.updateOrder, this.clearOrder, this.order});

  @override
  State<StatefulWidget> createState() {
    return _DishManagerState(listOfPlatos: listPlatos);
  }
}

/// State class for DishManager.
class _DishManagerState extends State<DishManager> {
  /// The dishes list to be render.
  final List<Plato> listOfPlatos;

  /// The price wiht currency format.
  final formatPrice = new NumberFormat.simpleCurrency(decimalDigits: 0);
  // Local var to store changes in an order.
  var orderList;
  var appTextStyle = AppTextStyle();

  // _DishManagerState constructor.
  _DishManagerState({this.listOfPlatos, this.orderList});

  /// Add dish element to the order.
  void _addDishesToOrder() {
    /// Update the order only with dishes that have quantity mayor than zero.
    setState(() {
      orderList = listOfPlatos.where((d) => d.cantidad > 0);
      if (orderList.isNotEmpty) {
        List<Plato> order = [];
        orderList.forEach((d) => order.add(d));
        print(order);
        widget.updateOrder(order);
      } else {
        /// When none of the dishes quantity is mayor than zero just return an empty
        /// order to control the order button successfuly.
        List<Plato> order = [];
        widget.updateOrder(order);
      }
    });
  }

  /// Reduce minus 1 [listOfPlatos(index).cantidad] if quantity is greater to zero
  void _restCant(int index) {
    setState(() {
      listOfPlatos[index].cantidad > 0
          ? listOfPlatos[index].cantidad--
          : listOfPlatos[index].cantidad = 0;
    });
    _addDishesToOrder();
  }

  /// Increases dish quantity [listOfPlatos(index).cantidad].
  void _addCant(int index) {
    setState(() {
      listOfPlatos[index].cantidad++;
    });
    _addDishesToOrder();
  }

  /// Clear the order.
  void _resetValues() {
    setState(() {
      listOfPlatos.forEach((f) => f.cantidad = 0);
    });
    _addDishesToOrder();
    widget.clearOrder();
  }

  @override
  void initState() {
    /// Check if the actual order is empty to set quantities to zero.
    super.initState();
    if (widget.order.isEmpty) {
      listOfPlatos.forEach((f) => f.cantidad = 0);
    }
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
    return ListView(
      children: <Widget>[
        // Create a scrollable ListView with the dishes list.
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: listOfPlatos.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  // Display dish name.
                  title: new Text(listOfPlatos[index].nombrePlato,
                      style: appTextStyle.cardTitle),
                  // Display dish description.
                  subtitle: new Text(listOfPlatos[index].descripcionPlato,
                      textAlign: TextAlign.justify,
                      style: appTextStyle.cardSubtitle),
                  trailing: new SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil.instance.setWidth(8.0)),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Display dish price.
                          new Text(
                            '${formatPrice.format(listOfPlatos[index].precioPlato)}',
                            style: appTextStyle.cardTrailingAccent,
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

                                      /// Reduce minus 1 [listOfPlatos(index).cantidad] if quantity is greater to zero
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
                                          listOfPlatos[index]
                                              .cantidad
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: appTextStyle.cardTrailing),
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
                  // Enable three line to dish description.
                  isThreeLine: true,
                ),
                margin: EdgeInsets.all(ScreenUtil.instance.setWidth(3.0)),
              );
            }),
        Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil.instance.setWidth(25.0),
                bottom: ScreenUtil.instance.setWidth(15.0)),
            child: Center(
              child: GestureDetector(
                child: Text('Nueva Orden',
                    textAlign: TextAlign.center,
                    style: appTextStyle.cardSubtitleUnderlined),
                onTap: () => _resetValues(),
              ),
            ))
      ],
    );
  }
}
