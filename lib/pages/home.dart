import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import './menus_list.dart';
import '../models/qr_model.dart';

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
  String _bodyMsj =
      'Escanea el código QR o ingresa ' + 'el código de tus restaurantes favoritos' +
      ' y empieza ordenar lo que más te gusta. Pide fácil atenderá tu orden.';

  /// Scan QR code. First time request access to the camera of the device.
  /// If scan a valid Qr code charge the restaurant's menu.
  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      print(qrResult);
      var qrobj = json.decode(qrResult);
      QRobject qrobject = QRobject(
          idMesa: qrobj['id_mesa'],
          idRestaurante: qrobj['id_restaurante'],
          urlAPIGet: qrobj['url_get']);
      _getMenu(qrobject);
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        _cameraDeniedAlert();
      } else {
        _errorAlert(ex.toString());
      }
    } on FormatException {
      setState(() {
        _bodyMsj = _bodyMsj;
      });
    } catch (ex) {
      _errorAlert(ex.toString());
    }
  }

  /// Shows Alert dialog when camera permission was denied.
  Future _cameraDeniedAlert() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Text(
              'El acceso a la cámara fue negado. Habilita el acceso para continuar',
              style: TextStyle(color: Color(0xFF666666), fontSize: 18.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Center(
                  child: Text(
                    'OK',
                    style: TextStyle(color: Color(0xFF00E676), fontSize: 18.0),
                  ),
                ),
                // Back when pressed.
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  /// Shows alert dialog when error exists when accesing to the device camera.
  Future _errorAlert(String error) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Text(
              error,
              style: TextStyle(color: Color(0xFF666666), fontSize: 18.0),
            ),
            actions: <Widget>[
              FlatButton(
                child: Center(
                  child: Text(
                    'VOLVER',
                    style: TextStyle(color: Color(0xFF00E676), fontSize: 18.0),
                  ),
                ),
                // Back when pressed.
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  /// Request API get restaurant menu throught [urlApiGetIdRest] and display it.
  void _getMenu(QRobject qrobj) {
    setState(() {
      // Change view.
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MenusListPage(
                    qrResult: qrobj,
                  )));
    });
  }

  /// Init the timer count down to change text in header.
  void _startTimer() {
    /// Asign a task to run when the period is complete
    _timermsj = Timer.periodic(new Duration(seconds: 2), (Timer timer) {
      // Updates the text value.
      setState(() {
        if (_pos < _msj.length)
          _pos = _pos + 1;
        else
          _pos = 0;
        _header = _msj[_pos];
      });
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timermsj.cancel();
    _timermsj = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 65.0, bottom: 20.0),
                child: Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Pide ',
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: _header,
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Color(0xFF00E676),
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25.0),
                child: Container(
                  child: Text(
                    _bodyMsj,
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFF666666),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  width: 325.0,
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    // Access to the assets directory and search for the img file.
                    image: ExactAssetImage('assets/home_img.png'),
                  )),
                  width: 350,
                  height: 350),
              Align(
                // Uses the remaining space in the screen to position the widget on the bottom.
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 228.0,
                      height: 47.0,
                      // TextField to handle input text form user.
                      child: TextField(
                        // Uppercase the input text.
                        textCapitalization: TextCapitalization.characters,
                        textAlign: TextAlign.center,
                        // Add style.
                        style: new TextStyle(
                            fontSize: 18.0, color: new Color(0xFF666666)),
                        // Assign value to the handler var.
                        controller: _manualCode,
                        // Disable autocrrect.
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 12.0),
                          // Preset hint.
                          labelText: 'Ingresa el código',
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 45.0),
                      // The QR button.
                      child: FlatButton.icon(
                        color: Color(0xFF00E676),
                        onPressed: _scanQR,
                        icon: new Icon(
                          const IconData(0xE900, fontFamily: 'Qrcode'),
                          color: Color(0xFFFFFFFF),
                        ),
                        label: Text(
                          "ESCANEAR CODIGO QR",
                          style: new TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side:
                              BorderSide(color: Color(0xFF00E676), width: 2.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ));
  }
}
