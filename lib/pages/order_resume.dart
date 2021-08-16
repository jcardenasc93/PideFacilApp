import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';

import '../models/platos_model.dart';
import '../styles/app_style.dart';
import '../models/post_score.dart';
import 'package:pide_facil/pages/cameraAccess.dart';

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

  final appTextStyle = AppTextStyle();

  /// Create a [PostScore] object to create the json body.
  PostScore _createPostRequest(double score, String comments) {
    // Create the [PostScore] object with the data.
    PostScore data =
        PostScore(score: score, comments: comments, orderId: orderID);
    return data;
  }

  /// Make the post request to the API.
  Future<bool> _makePost(PostScore data) {
    // var to check the result of the post
    var postResult = data.postRequest(data);
    return postResult;
  }

  void _addScore(BuildContext context, double score, String comments) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Create json data to post the order
        PostScore post = _createPostRequest(score, comments);
        // Make the POST request to the API
        bool status = await _makePost(post);
        if (status == true) {
          print(status);
        } else {
          _errorPost(context);
        }
      }
    } on SocketException catch (_) {
      _networkFail(context);
    }
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
                'Lo sentimos. No pudimos enviar tu calificación, verifica tu conexión a internet e inténtalo nuevamente',
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

  /// Shows alert message when the system cannot post the order.
  Future _errorPost(BuildContext context) async {
    /// Creates alert dialog.
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Error de envío', style: appTextStyle.alertTitle),
            content: new Text(
                'Lo sentimos no pudimos enviar tu calificación. Verifica tu conexión a internet e inténtalo nuevamente',
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

  Future _confirmarScore(BuildContext context, double score) async {
    final _commentsController = TextEditingController();
    return showDialog(
        context: context,
        // User must choose an option to close dialog.
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Agrega un comentario',
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
                    _addScore(context, score, _commentsController.text);
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    void _scanQR() {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => CameraAccess()));
    }

    //* Initialise ScreenUtil instance
    var appTextStyle = AppTextStyle();
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
                padding:
                    EdgeInsets.only(bottom: ScreenUtil.instance.setWidth(3.0)),
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
                padding:
                    EdgeInsets.only(top: ScreenUtil.instance.setHeight(25.0)),
                // Acknowledgment text
                child: Text(
                  'Gracias por usar nuestro servicio',
                  style: appTextStyle.cardTitleStrong,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil.instance.setHeight(25.0),
                    bottom: ScreenUtil.instance.setHeight(15.0)),
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
                      _confirmarScore(context, rating);
                      //print(rating);
                    },
                  )
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: AppColorPalette["primaryGreen"],
            onPressed: _scanQR,
            child: new Icon(const IconData(0xE900, fontFamily: 'Qrcode'),
                color: Colors.white, size: ScreenUtil.instance.setSp(20.0))));
  }
}
