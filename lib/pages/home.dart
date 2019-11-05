import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pide_facil/models/qr_model.dart';
import 'package:pide_facil/pages/cameraAccess.dart';
import './menus_list.dart';

class HomePage extends StatefulWidget {
  MainPage createState() => MainPage();
}

/// First page of the app that access to the camera to scan QR code.
class MainPage extends State<HomePage> {
  /// Header text.
  String _header = '';

  /// Homepage welcome message.
  String _bodyMsj = 'Escanea el código QR o ingresa ' +
      'el código de tus restaurantes favoritos' +
      ' y empieza ordenar lo que más te gusta. Pide fácil atenderá tu orden.';

  /// Scan QR code. First time request access to the camera of the device.
  /// If scan a valid Qr code charge the restaurant's menu.
  void _scanQR() {
    QRobject qrobj = QRobject(
        idMesa: 2,
        idRestaurante: 3,
        urlAPIGet: 'https://pidefacil-back.herokuapp.com/api/restaurante/3/');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MenusListPage(
                  qrResult: qrobj,
                )));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Portrait oriantation resstrict.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;

    //* Initialise ScreenUtil instance
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil.instance.setWidth(45.0),
                    bottom: ScreenUtil.instance.setWidth(45.0)),
                child: Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Be',
                        style: TextStyle(
                            fontSize: ScreenUtil.instance.setSp(28.0),
                            //fontSize: ScaleUI.safeBlockVertical * 4.0,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'U',
                            style: TextStyle(
                                fontSize: ScreenUtil.instance.setSp(28.0),
                                color: Color(0xFF00E676),
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ScreenUtil.instance.setWidth(20.0)),
                child: Container(
                  child: Text(
                    _bodyMsj,
                    style: new TextStyle(
                      fontSize: ScreenUtil.instance.setSp(16.0),
                      color: Color(0xFF666666),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  width: ScreenUtil.instance.setHeight(330.0),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          // Access to the assets directory and search for the img file.
                          image: ExactAssetImage('assets/pie_ex.gif'),
                          fit: BoxFit.cover)),
                  width: ScreenUtil.instance.setHeight(330.0),
                  height: ScreenUtil.instance.setHeight(380.0)),
              Align(
                // Uses the remaining space in the screen to position the widget on the bottom.
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil.instance.setWidth(5.0),
                            bottom: ScreenUtil.instance.setWidth(10.0)),
                        // The QR button.
                        child: Container(
                          width: ScreenUtil.instance.setHeight(180.0),
                          height: ScreenUtil.instance.setHeight(40.0),
                          child: FlatButton.icon(
                            color: Color(0xFF00E676),
                            onPressed: _scanQR,
                            icon: new Icon(
                              Icons.list,
                              color: Color(0xFFFFFFFF),
                              size: ScreenUtil.instance.setSp(13.0),
                            ),
                            label: Text(
                              "Ver Menú",
                              style: new TextStyle(
                                fontSize: ScreenUtil.instance.setSp(13.0),
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: Color(0xFF00E676),
                                  width: ScreenUtil.instance.setWidth(2.0)),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          )),
        ));
  }
}
