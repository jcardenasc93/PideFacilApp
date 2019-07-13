import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/platos_model.dart';
import '../styles/menu_style.dart';
import '../managers/menus_manager.dart';
import '../models/restaurante_model.dart';
import './order_view.dart';
import '../models/qr_model.dart';

/// Page that list all the menus of a restaurant.
class MenusListPage extends StatefulWidget {
  /// The QR scan result
  final QRobject qrResult;
  // MenusListPage constructor
  MenusListPage({this.qrResult});

  /// Returns an [Restaurante] object if the API request is successful
  Future<Restaurante> getRestaurante() async {
    /// The response of the API get request.
    final response = await http
        .get(qrResult.urlAPIGet, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      return Restaurante.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to get restaurant info');
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _MenusListState(restaurante: getRestaurante());
  }
}

class _MenusListState extends State<MenusListPage> {
  /// The restaurant object to be displayed
  final Future<Restaurante> restaurante;

  /// Store the order.
  List<Plato> order = [];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showFinalOrderCallback;
  // _MenusListState constructor.
  _MenusListState({this.restaurante});
  // TODO: Delete this variable after assets can be stored on server.
  String imageUrl =
      'https://pbs.twimg.com/profile_images/1280924607/LOGO_400x400.png';

  /// Update changes in the final order.
  getFinalOrder(finalOrder) {
    setState(() {
      order = finalOrder;
    });
  }

  /// Controls button behavior in function of empty order.
  FloatingActionButton _manageButton() {
    FloatingActionButton ordenButton;
    Color emptyColor = new Color(0xFFEAECEF);
    Color orderColor = new Color(0xFF00E676);
    // Search for dishes with quantity major to zero.
    var orden = order.where((d) => d.cantidad > 0);
    // If orden is empty disable button.
    if (orden.isEmpty) {
      ordenButton = FloatingActionButton(
        backgroundColor: emptyColor,
        child: Icon(
          Icons.playlist_add_check,
          color: Colors.white,
        ),
        onPressed: () {},
      );
    } else {
      ordenButton = FloatingActionButton(
          backgroundColor: orderColor,
          child: Icon(
            Icons.playlist_add_check,
            color: Colors.white,
          ),
          onPressed: _showFinalOrderCallback);
    }
    return ordenButton;
  }

  void _showOrderFun() {
    setState(() {
      _showFinalOrderCallback = null;
    });
    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return OrderView(orden: order);
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showFinalOrderCallback = _showOrderFun;
            });
          }
        });
  }

  @override
  void initState() {
    super.initState();
    // Disable action on the button.
    _showFinalOrderCallback = _showOrderFun;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: menuTheme,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          // Add 'scan QR' button on top left.
          leading: IconButton(
            icon: new Icon(
              const IconData(0xe900, fontFamily: 'Qrcode'),
              color: Color(0xFF666666),
            ),
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName('/')),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(2.0),
                // Display restaurant Image on top center.
                child: FutureBuilder<Restaurante>(
                  future: restaurante,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.network(imageUrl);
                      //return Image.network(snapshot.data.urlImagRestaurante);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // While get image returns nothing.
                    return new SizedBox();
                  },
                ),
              ),
              // Optional restaurant text to be displayed on top center.
              FutureBuilder<Restaurante>(
                future: restaurante,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      //snapshot.data.nombreRestaurante,
                      '',
                      style: new TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF666666)),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // While get restaurant name display nothing.
                  return new SizedBox();
                },
              ),
            ],
          ),
          centerTitle: true,
        ),
        // Display the menus list of the restaurant.
        body: FutureBuilder<Restaurante>(
          future: restaurante,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MenusManager(
                listMenus: snapshot.data.menus,
                getOrder: getFinalOrder,
                orden: order,
                qrobject: widget.qrResult,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // While get the menus list displays a circular progress indicator.
            return new Center(
              child: SizedBox(
                child: new CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xFF666666)),
                  strokeWidth: 3.0,
                ),
                height: 50.0,
                width: 50.0,
              ),
            );
          },
        ),
        floatingActionButton: _manageButton(),
      ),
    );
  }
}
