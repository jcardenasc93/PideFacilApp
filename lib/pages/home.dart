import 'package:flutter/material.dart';
import './menusList.dart';

class HomePage extends StatefulWidget {
  MainPage createState() => MainPage();
}

class MainPage extends State<HomePage> {
  void _changeView() {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MenusListPage()));
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
            onPressed: _changeView,
          ),
        ));
  }
}
