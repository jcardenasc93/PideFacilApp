import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

import './menus_list.dart';
import '../models/qr_model.dart';

class HomePage extends StatefulWidget {
  MainPage createState() => MainPage();
}

/// First page of the app that access to the camera to scan QR code.
class MainPage extends State<HomePage> {
  /// Homepage welcome message.
  String homeMsj =
      'Bienvenido a Pide Fácil. Para comenzar presiona el botón y escanea el código QR de tus restaurantes favoritos.';

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
        setState(() {
          homeMsj = "Camera permission was denied";
        });
      } else {
        setState(() {
          homeMsj = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        homeMsj = homeMsj;
      });
    } catch (ex) {
      setState(() {
        homeMsj = "Unknown Error $ex";
      });
    }
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

  @override
  Widget build(BuildContext context) {
    // TODO: Mejorar el look & feeling del msj de bienvenida.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pide Facil',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(45.0),
            child: Container(
              child: Text(
                homeMsj,
                style: new TextStyle(fontSize: 18.0, color: Color(0xFF666666)),
              ),
              width: 350.0,
              height: 200.0,
            ),
          ),
          RaisedButton(
            child: Text('Carga menus'),
            onPressed: () => _getMenu(
                QRobject(urlAPIGet: 'https://pidefacil-back.herokuapp.com/api/restaurante/3/')),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF00E676),
        onPressed: _scanQR,
        child: new Icon(
          const IconData(0xe900, fontFamily: 'Qrcode'),
          color: Colors.white,
        ),
        tooltip: 'Scan QR',
      ),
    );
  }
}
