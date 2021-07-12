import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pide_facil/pages/cameraAccess.dart';

class HomePage extends StatefulWidget {
  MainPage createState() => MainPage();
}

/// First page of the app that access to the camera to scan QR code.
class MainPage extends State<HomePage> {
  /// List that stores the text that chages in header.
  List<String> _msj = ["Fácil", "Fácil", "Rápido", "Ahora", "Ya"];

  /// index of the above list.
  int _pos = 0;

  /// [Timer] object that handles the time between text updates.
  Timer _timermsj;

  /// Header text.
  String _header = '';

  /// [TextField] handler that stores the input text.
  final _manualCode = TextEditingController();

  /// Homepage welcome message.
  String _bodyMsj = 'Escanea el código QR o ingresa ' +
      'el código de tus restaurantes favoritos' +
      ' y empieza ordenar lo que más te gusta. Pide fácil atenderá tu orden.';

  /// Scan QR code. First time request access to the camera of the device.
  /// If scan a valid Qr code charge the restaurant's menu.
  void _scanQR() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => CameraAccess()));
  }

  /// Init the timer count down to change text in header.
  void _changeText(Timer timer) {
    // Updates the text value.
    setState(() {
      if (_pos < _msj.length)
        _pos = _pos + 1;
      else
        _pos = 0;
      _header = _msj[_pos];
    });
  }

  @override
  void initState() {
    /// Asign a task to run when the period is complete
    _timermsj = Timer.periodic(new Duration(seconds: 2), _changeText);
    super.initState();
  }

  @override
  void dispose() {
    _timermsj.cancel();
    super.dispose();
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
                        text: 'Pide ',
                        style: TextStyle(
                            fontSize: ScreenUtil.instance.setSp(28.0),
                            //fontSize: ScaleUI.safeBlockVertical * 4.0,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: _header,
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
                      fontSize: ScreenUtil.instance.setSp(18.0),
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
                    Container(
                      width: ScreenUtil.instance.setHeight(230.0),
                      height: ScreenUtil.instance.setHeight(40.0),
                      // TextField to handle input text form user.
                      child: TextField(
                        // Uppercase the input text.
                        textCapitalization: TextCapitalization.characters,
                        textAlign: TextAlign.center,
                        // Add style.
                        style: new TextStyle(
                            fontSize: ScreenUtil.instance.setSp(13.0),
                            color: new Color(0xFF666666)),
                        // Assign value to the handler var.
                        controller: _manualCode,
                        // Disable autocrrect.
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              fontSize: ScreenUtil.instance.setSp(13.0)),
                          // Preset hint.
                          labelText: 'Ingresa el código',
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil.instance.setWidth(5.0),
                            bottom: ScreenUtil.instance.setWidth(10.0)),
                        // The QR button.
                        child: Container(
                          width: ScreenUtil.instance.setHeight(230.0),
                          height: ScreenUtil.instance.setHeight(40.0),
                          child: FlatButton.icon(
                            color: Color(0xFF00E676),
                            onPressed: _scanQR,
                            icon: new Icon(
                              const IconData(0xE900, fontFamily: 'Qrcode'),
                              color: Color(0xFFFFFFFF),
                              size: ScreenUtil.instance.setSp(13.0),
                            ),
                            label: Text(
                              "ESCANEAR CODIGO QR",
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
