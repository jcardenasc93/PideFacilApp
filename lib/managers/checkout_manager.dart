import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import '../models/platos_model.dart';
import '../pages/order_resume.dart';
import '../models/qr_model.dart';
import '../models/post.dart';
import '../models/comments.dart';
import '../models/user_location.dart';

class CheckoutManager extends StatefulWidget {
  final List<Plato> orden;
  CheckoutManager({this.orden});

  @override
  State<StatefulWidget> createState() {    
    return CheckoutManagerState(orden: orden);
  }  
}

class CheckoutManagerState extends State<CheckoutManager> {
  final List<Plato> orden;
  CheckoutManagerState({this.orden});
  // Create a unique global key for the form
  final _dataformKey = GlobalKey<FormState>();

  Future _datosPedido(BuildContext context) async {
    // Future<List<Ubicacion>> locations = getLocations();
    // print('********************');
    // List<String> ubicaciones = [];
    // locations.then((places) => {
    //   places.forEach((p) => print(p.place))
    // });
    String dropDownVal;
    final TextEditingController _nameFieldController = TextEditingController();
    final TextEditingController _addressFieldController =
        TextEditingController();
    final TextEditingController _phoneFieldController = TextEditingController();
    final TextEditingController _commentsFieldController =
        TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              'Ingresa tus datos para el envío',
              style: TextStyle(
                color: Color(0xFF666666),
              ),
            ),
            content: Form(
                key: _dataformKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: TextFormField(
                          // Add no empty validation
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            return null;
                          },
                          controller: _nameFieldController,
                          decoration:
                              InputDecoration(hintText: 'Ingresa tu nombre'),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                          child: new DropdownButtonFormField<String>(
                            hint: Text('Punto de referencia'),
                            onChanged: (String newValue) {
                              setState(() {
                                dropDownVal = newValue;
                              });
                            },
                            value: dropDownVal,
                            items: <String>[
                              'U. de los Andes',
                              'U. del Rosario',
                              'U. Javeriana',
                              'U. Central'
                            ]
                                .map((value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Selecciona un punto de referencia';
                              }
                              return null;
                            },
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: TextFormField(
                          // Add no empty validation
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            return null;
                          },
                          controller: _addressFieldController,
                          decoration: InputDecoration(
                              hintText: 'Ingresa la dirección de envío'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: TextFormField(
                          // Add no empty validation
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            return null;
                          },
                          controller: _phoneFieldController,
                          decoration: InputDecoration(
                              hintText: 'Ingresa el número de celular'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: TextFormField(
                          // Max number of lines
                          maxLines: 15,
                          controller: _commentsFieldController,
                          decoration: new InputDecoration(
                            hintText: 'Agrega tus comentarios para la orden',
                            // Muestra borde del campo de texto
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF666666), width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF666666), width: 1.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF666666), width: 1.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            actions: <Widget>[
              FlatButton(
                child: Text('VOLVER'),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text('CONFIRMAR'),
                  color: Color(0xFF00E676),
                  onPressed: () {
                    if (_dataformKey.currentState.validate()) {
                      // Hide dialog box.
                      Navigator.of(context).pop();
                      //_ordenar(
                      //    _nameFieldController.text,
                      //    _addressFieldController.text,
                      //    _phoneFieldController.text,
                      //    _commentsFieldController.text,
                      //    dropDownVal);
                    }
                  })
            ],
          );
        });
  }

  


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Text('Hi there')
      ],
    );
  }

}