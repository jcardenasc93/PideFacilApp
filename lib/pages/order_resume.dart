import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../models/platos_model.dart';
import '../pages/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderResume extends StatefulWidget {
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

  OrderResume(
      {this.idRestaurante,
      this.idMesa,
      this.orden,
      this.valorTotal,
      this.orderID});

  @override
  State<StatefulWidget> createState() {
    return OrderResumeState(orden: orden);
  }
}

class OrderResumeState extends State<OrderResume> {
  List<Plato> orden;
  OrderResumeState({this.orden});

  /// The price wiht currency format.
  final formatPrice = new NumberFormat.simpleCurrency(decimalDigits: 0);

  /// The rate value given by the user
  double rate = 5.0;

  void _returnHome(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;

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
                      Text(
                        'TOTAL: ${formatPrice.format(widget.valorTotal)}',
                        style: TextStyle(
                          color: Color(0xFF66666F),
                          fontSize: ScreenUtil.instance.setSp(38.0),
                        ),
                      ),
                      Text(
                        'Tu orden ha sido confirmada',
                        style: TextStyle(
                            fontSize: ScreenUtil.instance.setSp(18.0),
                            color: Color(0xFF66666F)),
                      ),
                    ],
                  ),
                ),
              ),
              // Custom divider.
              Padding(
                padding:
                    EdgeInsets.only(bottom: ScreenUtil.instance.setWidth(3.0)),
                child: Container(
                    width: _mediaQueryData.size.width,
                    height: ScreenUtil.instance.setWidth(25.0),
                    color: Color(0xFF00E676),
                    child: Center(
                      child: Text(
                        'Orden No.${widget.orderID}',
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
                      title: new Text(
                        orden[index].nombrePlato,
                        style: new TextStyle(
                          fontSize: ScreenUtil.instance.setSp(16.0),
                        ),
                      ),
                      trailing:
                          // Display dish price.
                          new Text(
                        'x${orden[index].cantidad}  ${formatPrice.format(orden[index].precioTotalPlato)}',
                        style: new TextStyle(
                          color: Color(0xFF66666F),
                          fontSize: ScreenUtil.instance.setSp(14.0),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    );
                  }),
              Padding(
                padding:
                    EdgeInsets.only(top: ScreenUtil.instance.setHeight(25.0)),
                // Acknowledgment text
                child: Text(
                  'Gracias por usar nuestro servicio',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF66666F),
                      fontSize: ScreenUtil.instance.setSp(18.0),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: // Rate mechanism.
                    SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (r) {
                    rate = r;
                    setState(() {});
                  },
                  starCount: 5,
                  rating: rate,
                  size: ScreenUtil.instance.setSp(35.0),
                  color: Color(0xFF00E676),
                  borderColor: Color(0xFF00E676),
                  spacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: new Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil.instance.setWidth(8.0)),
            child: RaisedButton(
              onPressed: () {
                _returnHome(context);
              },
              child: Text(
                'Nueva Orden',
                style: TextStyle(
                  color: Color(0xFF00E676),
                  fontSize: ScreenUtil.instance.setSp(20.0),
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
