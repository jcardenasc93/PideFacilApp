import 'package:flutter/material.dart';

import './menus_list.dart';

class HomePage extends StatefulWidget {
  MainPage createState() => MainPage();
}

/// First page of the app that access to the camera to scan QR code.
class MainPage extends State<HomePage> {
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
    //TODO: Implementar acceso a la camara para scanner de QR
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pide Facil',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: new Center(
          child: new RaisedButton(
            child: Text('Carga menus'),
            onPressed: () => _getMenu(
                'https://pidefacil-back.herokuapp.com/api/restaurante/3/'),
          ),
        ));
  }
}
