import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class PostOrder {
  /// The restaurant id readed from QR.
  final int idRestaurante;

  /// The mesa id readed from QR.
  final int idMesa;

  /// The total value of the order.
  final int precioTotal;

  /// The serialized list of [Platos]
  final List ordenListJson;

  PostOrder(
      {this.idRestaurante, this.idMesa, this.precioTotal, this.ordenListJson});

  String urlPost = '${Environment().config.apiHost}/orden-de-compra/';

  /// Encode the [toJson] string in json format
  String encodeBodyJson(PostOrder body) {
    final dyn = body.toJson();
    return json.encode(dyn);
  }

  /// Serialize this [PostOrder] object.
  Map<String, dynamic> toJson() => _bodyToJson(this);

  /// Create json body with desired structure.
  Map<String, dynamic> _bodyToJson(PostOrder body) {
    return {
      "id_restaurante": body.idRestaurante,
      "id_mesa": body.idMesa,
      "precio_total": body.precioTotal,
      "orden_id": ordenListJson,
    };
  }

  /// Make the post request to the API to load the [PostOrder] object in DB.
  Future<int> postRequest(PostOrder body) async {
    final response = await http.post(Uri.parse(Uri.encodeFull(urlPost)),
        body: encodeBodyJson(body),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        });
    if (response.statusCode < 200 || response.statusCode > 400 || json == null)
      throw Exception("Cannot post data to API");

    // Return de orderID when POST is success.
    int orderID = ResponsePost.fromJson(json.decode(response.body)).orderNumber;
    return orderID;
  }
}

class ResponsePost {
  /// The order ID
  final int orderNumber;

  ResponsePost({this.orderNumber});
  // Decode json response and extracts the id_orden value.
  factory ResponsePost.fromJson(Map<String, dynamic> parsedJson) {
    return ResponsePost(orderNumber: parsedJson['serial']);
  }
}
