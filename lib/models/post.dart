import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostApi {
  /// The restaurant id readed from QR.
  final int idRestaurante;
  /// The mesa id readed from QR.
  final int idMesa;
  /// The total value of the order.
  final int precioTotal;
  /// The serialized list of [Platos]
  final List ordenListJson;

  PostApi(
      {this.idRestaurante, this.idMesa, this.precioTotal, this.ordenListJson});

  /// Serialize this [PostApi] object.
  Map<String, dynamic> toJson() => _bodyToJson(this);

  String urlPost = 'https://pidefacil-back.herokuapp.com/api/orden-de-compra/';

  /// Encode the [toJson] string in json format
  String encodeBodyJson(PostApi body) {
    final dyn = body.toJson();
    return json.encode(dyn);
  }

  /// Create json body with desired structure.
  Map<String, dynamic> _bodyToJson(PostApi body) {
    return {
      "id_restaurante": body.idRestaurante,
      "id_mesa": body.idMesa,
      "precio_total": body.precioTotal,
      "orden_id": ordenListJson,
    };
  }

  /// Make the post request to the API to load the [PostApi] object in DB.
  Future<dynamic> postRequest(PostApi body) async {
    final response = await http.post(Uri.encodeFull(urlPost),
        body: encodeBodyJson(body),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        });
    if (response.statusCode < 200 || response.statusCode > 400 || json == null)
      throw Exception("Cannot post data to API");

    final resp = json.decode(response.body);
    return resp;
  }
}