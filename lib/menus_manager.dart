import 'package:flutter/material.dart';
import './pages/menu.dart';

class MenusManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenusManagerState();
  }
}

class _MenusManagerState extends State<MenusManager> {
  String _responseApi = '';

  @override
  void initState() {
    // TODO: implement getApi for first state
    super.initState();
  }

  void _tappedMenu(String texto) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MenuPage(
                    menuText: texto,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'El Hambriento',
            style: new TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF666666)),
            textAlign: TextAlign.center,
          ),
        ),
        new Divider(
          color: Colors.grey,
          height: 1.5,
          indent: 5.5,
        ),
        Card(
          child: ListTile(
            title: Text('Entradas'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _tappedMenu('Entradas'),
          ),
          margin: EdgeInsets.all(2.0),
        ),
        Card(
          child: ListTile(
            title: Text('Platos fuertes'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _tappedMenu('Platos fuertes'),
          ),
          margin: EdgeInsets.all(2.0),
        ),
        Card(
          child: ListTile(
            title: Text('Bebidas'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _tappedMenu('Bebidas'),
          ),
          margin: EdgeInsets.all(2.0),
        ),
        Card(
          child: ListTile(
            title: Text('Vinos'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _tappedMenu('Vinos'),
          ),
          margin: EdgeInsets.all(2.0),
        ),
        Card(
          child: ListTile(
            title: Text('Postres'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _tappedMenu('Postres'),
          ),
          margin: EdgeInsets.all(2.0),
        ),
        Text(
          '$_responseApi',
          style: TextStyle(
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
