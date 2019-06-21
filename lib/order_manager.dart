import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import './platos_model.dart';

/// Manage the order in the order view.
class OrderManager extends StatefulWidget {
  /// The user's order.
  final List<Plato> order;

  OrderManager({this.order});

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

  /// The price wiht currency format.
  final formatPrice = new NumberFormat.simpleCurrency(decimalDigits: 0);

  /// Reduce minus 1 [orden(index).cantidad] if quantity is greater to zero
  void _restCant(int index) {
    setState(() {
      orden[index].cantidad > 0
          ? orden[index].cantidad--
          : orden[index].cantidad = 0;
      //Update the total value of the dish respect to the quantity.
      orden[index].precioPlato =
          orden[index].precioPlato * orden[index].cantidad;
    });
    //_addDishesToOrder();
  }

  /// Increases dish quantity [orden(index).cantidad].
  void _addCant(int index) {
    setState(() {
      orden[index].cantidad++;
      //Update the total value of the dish respect to the quantity.
      orden[index].precioPlato =
          orden[index].precioPlato * orden[index].cantidad;
    });
    //_addDishesToOrder();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
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
                  title: new Text(
                    orden[index].nombrePlato,
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  trailing: new SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Display dish price.
                          new Text(
                            '${formatPrice.format(orden[index].precioPlato * orden[index].cantidad)}',
                            style: new TextStyle(
                              color: Color(0xFF66666F),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          // Display dish quantity control.
                          new Container(
                              margin: EdgeInsets.all(5.0),
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
                                        size: 18.0,
                                      ),

                                      /// Reduce minus 1 [orden(index).cantidad] if quantity is greater to zero
                                      onTap: () => _restCant(index),
                                    ),
                                  ),
                                  Container(
                                    width: 35.0,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.0, vertical: 1.0),
                                      // Display dish quantity.
                                      child: new Text(
                                        orden[index].cantidad.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
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
                                        size: 18.0,
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
                    width: 100.0,
                  ),
                ),
                margin: EdgeInsets.all(2.0),
              );
            }),
      ],
    );
  }
}
