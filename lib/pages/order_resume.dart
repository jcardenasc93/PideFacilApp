import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import '../platos_model.dart';

class OrderResume extends StatelessWidget {
  /// The list of dishes in final order.
  final List<Plato> orden;
  /// The restaurante id taked from QR code.
  /// TODO: Pasar el id como parametro
  final int idRestaurante = 3;
  /// The mesa id taked from QR code.
  /// TODO: Pasar el id como parametro
  final int idMesa = 24;
  /// The total value of the order.
  /// TODO: Pasar el valor total de la orden como parametro.
  final int valorTotal = 0;

  /// The price wiht currency format.
  final formatPrice = new NumberFormat.simpleCurrency(decimalDigits: 0);

  OrderResume({this.orden});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu Orden'),
      ),
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
                              '${formatPrice.format(orden[index].precioTotalPlato)}',
                              style: new TextStyle(
                                color: Color(0xFF66666F),
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            // Display dish quantity.
                            new Container(
                              margin: EdgeInsets.all(5.0),
                              alignment: Alignment(0.0, 0.0),
                              child: new Center(
                                child: Container(
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
                              ),
                            ),
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
      ),
    );
  }
}
