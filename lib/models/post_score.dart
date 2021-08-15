import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class PostScore {
  /// Score given by the user
  final double score;

  /// Comments
  final String comments;

  /// Order id
  final int orderId;

  PostScore({this.score, this.comments, this.orderId});

  String urlPost = '${Environment().config.apiHost}/score/';

  /// Encode the [toJson] string in json format
  String encodeBodyJson(PostScore body) {
    final dyn = body.toJson();
    return json.encode(dyn);
  }

  /// Serialize this [PostScore] object.
  Map<String, dynamic> toJson() => _bodyToJson(this);

  /// Create json body with desired structure.
  Map<String, dynamic> _bodyToJson(PostScore body) {
    return {
      "score": body.score.toInt(),
      "comment": body.comments,
      "id_orden": body.orderId
    };
  }

  /// Make the post request to the API to load the [PostScore] object in DB.
  Future<bool> postRequest(PostScore body) async {
    final response = await http.post(Uri.parse(Uri.encodeFull(urlPost)),
        body: encodeBodyJson(body),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        });
    if (response.statusCode < 200 || response.statusCode > 400 || json == null)
      throw Exception("Cannot post data to API");

    return true;
  }
}
