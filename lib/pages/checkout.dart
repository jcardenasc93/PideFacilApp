import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../models/platos_model.dart';
import '../managers/checkout_manager.dart';


class CheckoutView extends StatefulWidget {
  /// The user's order.
  final List<Plato> orden;

  CheckoutView({this.orden});

  @override
  State<StatefulWidget> createState() {
    return CheckoutViewState(orden: orden);
  }
}

class CheckoutViewState extends State<CheckoutView> {
  /// The user's order.
  List<Plato> orden;
  // OrderViewState constructor
  CheckoutViewState({this.orden});
  

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  _backToOrder(BuildContext context) {
    Navigator.pop(context, orden);
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
        child: Scaffold(
            key: _scaffoldKey,            
            appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: Colors.white,
                centerTitle: true,
                // Add back button.
                leading: IconButton(
                  icon: new Icon(
                    Icons.arrow_back,
                    color: Color(0xFF666666),
                  ),
                  onPressed: () {
                    _backToOrder(context);
                  },
                ),
                // Display menu name on top center.
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Checkout',
                        style: new TextStyle(
                            fontSize: ScreenUtil.instance.setSp(18.0),
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF666666)),
                        textAlign: TextAlign.center,
                      ),
                    ])),
                    body: CheckoutManager(orden: orden,),
                    ));
  }
}
