import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/platos_model.dart';
import '../styles/app_style.dart';

class OrderResume extends StatelessWidget {
  /// The list of dishes in final order.
  final List<Plato> orden;

  /// The restaurante id taked from QR code.
  final int idRestaurante;

  /// The mesa id taked from QR code.
  final int idMesa;

  /// The total value of the order.
  final int valorTotal;

  /// The Order ID.
  final int orderID;

  /// The price wiht currency format.
  final formatPrice = new NumberFormat.simpleCurrency(decimalDigits: 0);

  OrderResume(
      {this.idRestaurante,
      this.idMesa,
      this.orden,
      this.valorTotal,
      this.orderID});

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    var appTextStyle = AppTextStyle();

    //* Initialise ScreenUtil instance
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);
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
            padding: EdgeInsets.all(ScreenUtil.instance.setWidth(15.0)),
            // Total order remarkable.
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('TOTAL: ${formatPrice.format(valorTotal)}',
                      style: appTextStyle.homeTitleLight),
                  Text('Tu orden ha sido confirmada',
                      style: appTextStyle.cardTitle),
                ],
              ),
            ),
          ),
          // Custom divider.
          Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil.instance.setWidth(3.0)),
            child: Container(
                width: _mediaQueryData.size.width,
                height: ScreenUtil.instance.setWidth(25.0),
                color: AppColorPalette["primaryGreen"],
                child: Center(
                  child: Text(
                    'Orden No.$orderID',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil.instance.setSp(20.0),
                    ),
                  ),
                )),
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: orden.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  // Display dish name.
                  title: new Text(orden[index].nombrePlato,
                      style: appTextStyle.body),
                  trailing:
                      // Display dish price.
                      new Text(
                    'x${orden[index].cantidad}  ${formatPrice.format(orden[index].precioTotalPlato)}',
                    style: appTextStyle.body,
                    textAlign: TextAlign.end,
                  ),
                );
              }),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(25.0)),
            // Acknowledgment text
            child: Text(
              'Gracias por usar nuestro servicio',
              style: appTextStyle.cardTitleStrong,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(25.0), bottom: ScreenUtil.instance.setHeight(15.0)),
            // Acknowledgment text
            child: Text('Deseas calificar nuestro servicio?',
                textAlign: TextAlign.center,
                style: appTextStyle.cardTitleStrong),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rate mechanism.
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                unratedColor: AppColorPalette["default"],
                itemSize: 30.0,
                itemPadding: EdgeInsets.symmetric(horizontal: 2.5),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  size: 1,
                  color: AppColorPalette["primaryGreen"],
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              )
            ],
          )
        ],
      ),
    ));
  }
}
