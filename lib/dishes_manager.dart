import "package:intl/intl.dart";
import 'package:flutter/material.dart';

import './pages/dishes_list.dart';
import './platos_model.dart';

/// Manage the dishes rendering.
class DishManager extends StatefulWidget {
  /// The dishes list.
  final List<Plato> listPlatos;
  // DishManager constructor.
  DishManager({this.listPlatos});

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
  _DishManagerState({this.listOfPlatos});

  /// Add dish element to the order.
  void _addDishToOrder(String texto, int cant) {
    setState(() {
      // TODO: push notification of item added to the order
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  title: new Text(
                    listOfPlatos[index].nombrePlato,
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  // Display dish description.
                  subtitle: new Text(
                    listOfPlatos[index].descripcionPlato,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF66666F),
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
                            '${formatPrice.format(listOfPlatos[index].precioPlato)}',
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
                                      /// Reduce minus 1 [listOfPlatos(index).cantidad] if quantity is greater to zero
                                      onTap: () => setState(() =>
                                          listOfPlatos[index].cantidad > 0
                                              ? listOfPlatos[index].cantidad--
                                              : listOfPlatos[index].cantidad =
                                                  0),
                                    ),
                                  ),
                                  Container(
                                    width: 35.0,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.0, vertical: 1.0),
                                      // Display dish quantity.
                                      child: new Text(
                                        listOfPlatos[index].cantidad.toString(),
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
                                      onTap: () => setState(
                                          () => listOfPlatos[index].cantidad++),
                                    ),
                                  )
                                ],
                              ))),
                        ],
                      ),
                    ),
                    width: 100.0,
                  ),
                  // Enable three line to dish description.
                  isThreeLine: true,
                ),
                margin: EdgeInsets.all(2.0),
              );
            }),
      ],
    );
  }
}
