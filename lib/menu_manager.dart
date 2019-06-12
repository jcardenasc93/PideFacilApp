import 'package:flutter/material.dart';
import './pages/menu.dart';
import './platos_model.dart';
import "package:intl/intl.dart";

class MenuManager extends StatefulWidget {
  final String menuText;
  final List<Plato> listPlatos;

  MenuManager({this.menuText, this.listPlatos});

  @override
  State<StatefulWidget> createState() {
    return _MenuManagerState(listOfPlatos: listPlatos);
  }
}

class _MenuManagerState extends State<MenuManager> {
  final List<Plato> listOfPlatos;
  final formatPrice = new NumberFormat.simpleCurrency(decimalDigits: 0);
  _MenuManagerState({this.listOfPlatos});

  void _addPlatoToOrder(String texto) {
    setState(() {
      // TODO: push notification of item added to the order
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: listOfPlatos.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: new Text(
                    listOfPlatos[index].nombrePlato,
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: new Text(
                    listOfPlatos[index].descripcionPlato,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF66666F),
                    ),
                  ),
                  trailing: new SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            '${formatPrice.format(listOfPlatos[index].precioPlato)}',
                            style: new TextStyle(
                              color: Color(0xFF66666F),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          new Container(
                              margin: EdgeInsets.all(5.0),
                              alignment: Alignment(0.0, 0.0),
                              child: new Center(
                                  child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      border: Border.all(
                                        color: Colors.redAccent,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: new GestureDetector(
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 18.0,
                                      ),
                                      onTap: () => setState(() =>
                                          listOfPlatos[index].cantidad > 0
                                              ? listOfPlatos[index].cantidad--
                                              : listOfPlatos[index].cantidad =
                                                  0),
                                    ),
                                  ),
                                  Container(
                                    width: 35.0,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.0, vertical: 1.0),
                                      child: new Text(
                                        listOfPlatos[index].cantidad.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      border: Border.all(
                                        color: Colors.greenAccent,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: new GestureDetector(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 18.0,
                                      ),
                                      onTap: () => setState(
                                          () => listOfPlatos[index].cantidad++),
                                    ),
                                  )
                                ],
                              ))),
                        ],
                      ),
                    ),
                    width: 100.0,
                  ),
                  isThreeLine: true,
                ),
                margin: EdgeInsets.all(2.0),
              );
            }),
      ],
    );
  }
}
