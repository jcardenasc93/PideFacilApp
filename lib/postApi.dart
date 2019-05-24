import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class Post {
  final int num1;
  final int num2;
  final int result;

  String url = 'http://192.168.0.12:9000/suma/?format=json';

  Post({this.num1, this.num2, this.result});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      num1: json['num1'],
      num2: json['num2'],
      result: json['result'],

    );
  }

  String postToJson(Post data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }

  Map<String, dynamic> toJson() => {
    "num1": num1,
    "num2": num2,
  };

  Future<Post> fetchPost() async {
    final response =
    await http.get(url);

    if (response.statusCode == 200) {
      // If request is successful, decode the JSON response
      final resp = json.decode(response.body);
      return Post.fromJson(resp[2]);
    }
    else
      throw Exception('Cannot get response from API');
  }

  Future<dynamic> postPost(Post body) async{
    final response = await http
        .post(
          Uri.encodeFull(url),
          body: postToJson(body),
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
        );
  }
}






