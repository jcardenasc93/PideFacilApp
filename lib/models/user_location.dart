import 'package:flutter/material.dart';

class UserLocation {
  final double longitude;
  final double latitude;
  final String address;

  UserLocation(
      {@required this.longitude, @required this.latitude, this.address});
}
