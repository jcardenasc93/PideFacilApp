import 'package:flutter/material.dart';

class MenuManager extends StatefulWidget {
  final String menuText;

  MenuManager({this.menuText});

  @override
  State<StatefulWidget> createState() {
    return _MenuManagerState();
  }
}

class _MenuManagerState extends State<MenuManager> {
  @override
  void initState() {
    // TODO: implement getApi for get menu's items

    super.initState();
  }

  void _tappedMenu(String texto) {
    setState(() {
      // TODO: push notification of item added to the order
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            widget.menuText,
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
            title: Text('Ceviche de Camaron'),
            subtitle: Text(
              'Frescos camarones bañados en salsa de la casa. Para compartir con los que mas quieres',
              style: TextStyle(
                fontSize: 12.0,
                color: Color(0xFF66666F),
              ),
            ),
            trailing: Icon(
              Icons.add,
              size: 16.0,
            ),
            onTap: () => _tappedMenu('Entradas'),
          ),
          margin: EdgeInsets.all(2.0),
        ),
        Card(
          child: ListTile(
            title: Text('Empanadas de cangrejo'),
            subtitle: Text(
              'Las más deliciosas y recién horneadas empanadas rellenas de queso mozarella y cangrejo seleccionado',
              style: TextStyle(
                fontSize: 12.0,
                color: Color(0xFF66666F),
              ),
            ),
            trailing: Icon(
              Icons.add,
              size: 16.0,
            ),
            onTap: () => _tappedMenu('Entradas'),
          ),
          margin: EdgeInsets.all(2.0),
        ),
        Card(
          child: ListTile(
            title: Text('Deditos Mozarrella'),
            subtitle: Text(
              'Deditos rellenos de mozzarela y trozos de manzana que deleitarán tu paladar',
              style: TextStyle(
                fontSize: 12.0,
                color: Color(0xFF66666F),
              ),
            ),
            trailing: Icon(
              Icons.add,
              size: 16.0,
            ),
            onTap: () => _tappedMenu('Entradas'),
          ),
          margin: EdgeInsets.all(2.0),
        ),
      ],
    );
  }
}
