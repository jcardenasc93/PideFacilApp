import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Post {
  final int userID;
  final int id;
  final String title;
  final String body;

  Post({this.userID, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userID: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Future<Post> fetchPost() async {
    final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/1');

    if (response.statusCode == 200)
      // If request is successful, decode the JSON response
      return Post.fromJson(json.decode(response.body));
    else
      throw Exception('Cannot get response from API');
  }
}

