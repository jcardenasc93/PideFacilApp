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
  //final formatPrice = new NumberFormat("COP ###", "en_US");
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            BackButton(
              color: Color(0xFF66666F),
            ),
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
          ],
        ),
        new Divider(
          color: Colors.grey,
          height: 1.5,
          indent: 5.5,
        ),
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
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          '${formatPrice.format(listOfPlatos[index].precioPlato)}',
                          //'COP ${listOfPlatos[index].precioPlato.toString()}',
                          style: new TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        //Container(),
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.remove,
                                size: 16.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child:
                                  Text(listOfPlatos[index].cantidad.toString()),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.add,
                                size: 16.0,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    width: 80.0,
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
