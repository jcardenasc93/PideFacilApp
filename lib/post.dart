import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostApi {
  final int idRestaurante;
  final int idMesa;
  final int precioTotal;
  final List ordenListJson;

  PostApi(
      {this.idRestaurante, this.idMesa, this.precioTotal, this.ordenListJson});

  Map<String, dynamic> toJson() => _bodyToJson(this);

  String encodeBodyJson(PostApi body){
    final dyn = body.toJson();
    return json.encode(dyn);
  }

  Map<String, dynamic> _bodyToJson(PostApi body) {
    return {
      "id_restaurante": body.idRestaurante,
      "id_mesa": body.idMesa,
      "precio_total": body.precioTotal,
      "orden_id": ordenListJson,
    };
  }
}
