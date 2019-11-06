import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  // User position
  Position _currentPosition;
  // Geolocator object
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  // Map controller
  GoogleMapController mapController;

  // Create a unique global key for the form
  final _dataformKey = GlobalKey<FormState>();
  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _addressFieldController = TextEditingController();
  final TextEditingController _phoneFieldController = TextEditingController();
  final TextEditingController _commentsFieldController =
      TextEditingController();

  CameraPosition _initMapPosition = CameraPosition(
    target: LatLng(4.601404, -74.066061),
    zoom: 17.0,
  );

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

  /// get user location method
  Future _getCurrentLocation() async {
    Position position;
    try {
      position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      position = null;
    }

    setState(() {
      _currentPosition = position;
      // Update initial Map position
      _initMapPosition = CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        zoom: 17.0,
      );
    });
    // Moves the camera to the initial position.
    mapController?.moveCamera(CameraUpdate.newCameraPosition(_initMapPosition));
  }

  @override
  void initState() {
    super.initState();
    // Updates initial position on init page
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;

    //* Initialise ScreenUtil instance
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil.instance.setWidth(15.0),
              left: ScreenUtil.instance.setWidth(15.0),
              right: ScreenUtil.instance.setWidth(15.0),
              bottom: ScreenUtil.instance.setWidth(5.0)),
          child: Text(
            'Lugar de envío',
            textAlign: TextAlign.left,
            style: new TextStyle(
              color: Color(0xFF66666F),
              fontSize: ScreenUtil.instance.setSp(15.0),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(
                bottom: ScreenUtil.instance.setWidth(5.0),
                left: ScreenUtil.instance.setWidth(15.0),
                right: ScreenUtil.instance.setWidth(15.0)),
            child: Divider(
              color: Color(0xFF66666F),
            )),
        Padding(
            padding: EdgeInsets.only(
                bottom: ScreenUtil.instance.setWidth(15.0),
                left: ScreenUtil.instance.setWidth(15.0),
                right: ScreenUtil.instance.setWidth(15.0)),
            child: Container(
                width: ScreenUtil.instance.setWidth(600.0),
                height: ScreenUtil.instance.setHeight(200.0),
                child: Stack(
                  children: <Widget>[
                    // Create GoogleMap Widget
                    GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      initialCameraPosition: _initMapPosition,
                      circles: null,
                    ),
                  ],
                ))),
        Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil.instance.setWidth(15.0),
                right: ScreenUtil.instance.setWidth(15.0)),
            child: Form(
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
                              hintText: 'Ingresa tu número de celular'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: TextFormField(
                          // Max number of lines
                          maxLines: 5,
                          controller: _commentsFieldController,
                          decoration: new InputDecoration(
                            hintText: 'Agrega tus comentarios',
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
                ))),
      ],
    ));
  }
}
