import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

import '../qr_model.dart';
import './menus_list.dart';

class HomePage extends StatefulWidget {
  MainPage createState() => MainPage();
}

/// First page of the app that access to the camera to scan QR code.
class MainPage extends State<HomePage> {
  String homeMsj =
      'Bienvenido a Pide Fácil. Para comenzar presiona el botón y escanea el código QR de tus restaurantes favoritos.';

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      List<String> listS = qrResult.split('":');
      String urlApi = listS[listS.length - 1].replaceAll('"', '').replaceAll('}', '');
      _getMenu(urlApi);
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
  void _getMenu(String urlApiGetIdRest) {
    setState(() {
      // Change view.
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MenusListPage(
                    urlApiGet: urlApiGetIdRest,
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
          child: Container(
        child: Text(
          homeMsj,
          style: new TextStyle(fontSize: 18.0, color: Color(0xFF666666)),
        ),
        width: 350.0,
        height: 400.0,
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
