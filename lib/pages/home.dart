import 'package:flutter/material.dart';
import './menus_list.dart';

class HomePage extends StatefulWidget {
  MainPage createState() => MainPage();
}

class MainPage extends State<HomePage> {
  void _changeView(String urlApiGetIdRest) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MenusListPage(urlApiGet: urlApiGetIdRest,)));
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
            //onPressed: _changeView(),
            onPressed: () => _changeView('https://pidefacil-back.herokuapp.com/api/restaurante/2/'),
          ),
        ));
  }
}
