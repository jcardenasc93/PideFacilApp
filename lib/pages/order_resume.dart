import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:pide_facil/scale_ui.dart';
import '../models/platos_model.dart';

class OrderResume extends StatelessWidget {
  /// The list of dishes in final order.
  final List<Plato> orden;

  /// The restaurante id taked from QR code.
  final int idRestaurante;

  /// The mesa id taked from QR code.
  final int idMesa;

  /// The total value of the order.
  final int valorTotal;

  /// The price wiht currency format.
  final formatPrice = new NumberFormat.simpleCurrency(decimalDigits: 0);

  OrderResume({this.idRestaurante, this.idMesa, this.orden, this.valorTotal});

  @override
  Widget build(BuildContext context) {
    ScaleUI().init(context);
    return Scaffold(
        // Disable back button on appbar
        body: WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: ListView(
        children: <Widget>[
          // Create a scrollable ListView with the order list.
          Padding(
            padding: EdgeInsets.all(ScaleUI.safeBlockVertical * 4.0),
            // Total order remarkable.
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'TOTAL: ${formatPrice.format(valorTotal)}',
                    style: TextStyle(
                      color: Color(0xFF66666F),
                      fontSize: ScaleUI.safeBlockVertical * 6.0,
                    ),
                  ),
                  Text(
                    'Tu orden ha sido confirmada',
                    style: TextStyle(
                        fontSize: ScaleUI.safeBlockVertical * 2.5,
                        color: Color(0xFF66666F)),
                  ),
                ],
              ),
            ),
          ),
          // Custom divider.
          Padding(
            padding: EdgeInsets.only(bottom: ScaleUI.safeBlockVertical * 2.0),
            child: Container(
              width: ScaleUI.screenWidth,
              height: ScaleUI.blockSizeVertical * 3.5,
              color: Color(0xFF00E676),
              child: Text(
                'Orden No.1234',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScaleUI.blockSizeVertical * 3,
                ),
              ),
            ),
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: orden.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  // Display dish name.
                  title: new Text(
                    orden[index].nombrePlato,
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  trailing:
                      // Display dish price.
                      new Text(
                    'x${orden[index].cantidad}  ${formatPrice.format(orden[index].precioTotalPlato)}',
                    style: new TextStyle(
                      color: Color(0xFF66666F),
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.end,
                  ),
                );
              }),
          // Acknowledgment text
          Text(
            'Gracias por usar nuestro servicio',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF66666F),
              fontSize: ScaleUI.blockSizeVertical * 3,
              fontWeight: FontWeight.bold
            ),
          ),
          // Rate mechanism.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.star_border,
                size: ScaleUI.blockSizeHorizontal * 8,
                color: Color(0xFF00E676)
              ),
              Icon(
                Icons.star_border,
                size: ScaleUI.blockSizeHorizontal * 8,
                color: Color(0xFF00E676)
              ),
              Icon(
                Icons.star_border,
                size: ScaleUI.blockSizeHorizontal * 8,
                color: Color(0xFF00E676)
              ),
              Icon(
                Icons.star_border,
                size: ScaleUI.blockSizeHorizontal * 8,
                color: Color(0xFF00E676)
              ),
              Icon(
                Icons.star_border,
                size: ScaleUI.blockSizeHorizontal * 8,
                color: Color(0xFF00E676)
              )
            ],
          )
        ],
      ),
    ));
  }
}
