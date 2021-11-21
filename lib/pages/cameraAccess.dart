import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';

import '../models/qr_model.dart';
import './menus_list.dart';
import '../styles/app_style.dart';

class CameraAccess extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CameraAccessState();
  }
}

class CameraAccessState extends State<CameraAccess> {
  /// Scan QR code. First time request access to the camera of the device.
  /// If scan a valid Qr code charge the restaurant's menu.
  Future _scanQR() async {
    try {
      var cameraStatus = await Permission.camera.status;

      if(cameraStatus.isGranted) {
        String qrResult = await scanner.scan();
        print(qrResult);
        var qrobj = json.decode(qrResult);
        QRobject qrobject = QRobject(
            idMesa: qrobj['id_mesa'],
            idRestaurante: qrobj['id_restaurante']);
        _getMenu(qrobject);
      }

      else {
        var cameraGranted = await Permission.camera.request();
        if(cameraGranted.isGranted){
          String qrResult = await scanner.scan();
          print(qrResult);
          var qrobj = json.decode(qrResult);
          QRobject qrobject = QRobject(
              idMesa: qrobj['id_mesa'],
              idRestaurante: qrobj['id_restaurante']);
          _getMenu(qrobject);
        }
      }

    } on PlatformException catch (ex) {
       _errorAlert(ex.toString());
    } on FormatException {
      Navigator.of(context).pop();
      //Navigator.popUntil(context, ModalRoute.withName('home'));
    } catch (ex) {
      Navigator.of(context).pop();
      _errorAlert(ex.toString());
    }
  }

  /// Shows Alert dialog when camera permission was denied.
  Future _cameraDeniedAlert() {
    var appTextStyle = AppTextStyle();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Text(
              'El acceso a la cámara fue negado. Habilita el acceso para continuar',
              style: appTextStyle.body
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
    var appTextStyle = AppTextStyle();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Text(
              error,
              style: appTextStyle.body
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

  void _getMenu(QRobject qrobj) {
    setState(() {
      // Change view.
      Navigator.push(
          context,
          MaterialPageRoute(
              settings: RouteSettings(name: "cameraQR"),
              builder: (BuildContext context) => MenusListPage(
                    qrResult: qrobj,
                  )));
    });
  }

  @override
  void initState() {
    super.initState();
    _scanQR();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
