import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/platos_model.dart';
import '../styles/menu_style.dart';
import '../styles/app_style.dart';
import '../managers/menus_manager.dart';
import '../models/restaurante_model.dart';
import './order_view.dart';
import '../models/qr_model.dart';
import '../config/config.dart';
import '../pages/home.dart';

/// Page that list all the menus of a restaurant.
class MenusListPage extends StatefulWidget {
  /// The QR scan result
  final QRobject qrResult;
  // MenusListPage constructor
  MenusListPage({this.qrResult});

  /// Returns an [Restaurante] object if the API request is successful
  Future<Restaurante> getRestaurante() async {
    /// The response of the API get request.
    String requestURL =
        '${Environment().config.apiHost}/restaurante/${qrResult.idRestaurante}';
    final response = await http
        .get(Uri.parse(requestURL), headers: {"Accept": "application/json"});
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

  var appTextStyle = AppTextStyle();

  /// Store the order.
  List<Plato> order = [];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showFinalOrderCallback;
  // _MenusListState constructor.
  _MenusListState({this.restaurante});

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
    Color orderColor = AppColorPalette["primaryGreen"];
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

  FutureBuilder<Restaurante> _appBarManager() {
    return FutureBuilder<Restaurante>(
      future: restaurante,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var restaurantImage = '';
          if (snapshot.data.urlImagRestaurante != '') {
            restaurantImage = snapshot.data.urlImagRestaurante;
          } else if (snapshot.data.externalImage != '') {
            restaurantImage = snapshot.data.externalImage;
          }
          if (restaurantImage != '') {
            return Container(
                height: 55,
                //child: Image.network(
                //snapshot.data.urlImagRestaurante)),
                child: Image.network(
                  snapshot.data.urlImagRestaurante,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Container(
                        height: 55,
                        child: Center(
                            child: Text(snapshot.data.nombreRestaurante,
                                style: appTextStyle.appBarTitle)));
                  },
                ));
          } else {
            return Container(
                height: 55,
                child: Center(
                    child: Text(snapshot.data.nombreRestaurante,
                        style: appTextStyle.appBarTitle)));
          }
          //return Image.network(snapshot.data.urlImagRestaurante);
        } else if (snapshot.hasError) {
          return Icon(
            Icons.warning,
            color: AppColorPalette["defaultAccent"],
          );
        }
        // While get image returns nothing.
        return new SizedBox();
      },
    );
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

  /// Refresh page when an can't get restaurant from the API service
  void _refreshPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MenusListPage(
                  qrResult: widget.qrResult,
                )));
  }

  @override
  void initState() {
    super.initState();
    // Disable action on the button.
    _showFinalOrderCallback = _showOrderFun;
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

    // WillPopScope disables back action on Android devices.
    return new WillPopScope(
        onWillPop: () async => false,
        child: MaterialApp(
          theme: menuTheme,
          home: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              // Add 'scan QR' button on top left.
              leading: IconButton(
                  icon: new Icon(const IconData(0xe900, fontFamily: 'Qrcode'),
                      color: AppColorPalette["defaultAccent"]),
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          transitionDuration: Duration.zero,
                          pageBuilder: (_, __, ___) => HomePage()))),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(2.0),
                      // Display restaurant Image on top center.
                      child: _appBarManager())
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
                  return new Center(
                      child: Container(
                    height: ScreenUtil.instance.setHeight(250.0),
                    width: ScreenUtil.instance.setHeight(330.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          child: Icon(
                            Icons.cloud_off,
                            color: AppColorPalette["defaultAccent"],
                            size: ScreenUtil.instance.setSp(40.0),
                          ),
                          padding: EdgeInsets.only(
                              bottom: ScreenUtil.instance.setWidth(15.0)),
                        ),
                        Text(
                          'Lo sentimos! No podemos procesar tu solicitud. ' +
                              'Verifica tu conexión e inténtalo de nuevo',
                          style: new TextStyle(
                            color: AppColorPalette["defaultAccent"],
                            fontSize: ScreenUtil.instance.setSp(16.0),
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Padding(
                          child: IconButton(
                            icon: Icon(
                              Icons.refresh,
                            ),
                            color: AppColorPalette["defaultAccent"],
                            iconSize: ScreenUtil.instance.setSp(35.0),
                            onPressed: () {
                              _refreshPage();
                            },
                          ),
                          padding: EdgeInsets.only(
                              top: ScreenUtil.instance.setWidth(10.0)),
                        )
                      ],
                    ),
                  ));
                }
                // While get the menus list displays a circular progress indicator.
                return new Center(
                  child: SizedBox(
                    child: new CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          AppColorPalette["defaultAccent"]),
                      strokeWidth: 3.0,
                    ),
                    height: ScreenUtil.instance.setWidth(40.0),
                    width: ScreenUtil.instance.setWidth(40.0),
                  ),
                );
              },
            ),
            floatingActionButton: _manageButton(),
          ),
        ));
  }
}
