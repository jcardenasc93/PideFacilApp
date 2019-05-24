import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'postApi.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pide Facil',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyCustomForm(),
    );
  }
}

// Define a Custom Form Widget
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class. This class will hold the data related to
// our Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final num1Controller = TextEditingController();
  final num2Controller = TextEditingController();

  String _responseApi = "";

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    num1Controller.dispose();
    num2Controller.dispose();
    super.dispose();
  }

  void _sumIntegersGetApi() {
    var api = new Post();
    api.fetchPost().then((post) {
      setState(() {
        _responseApi= post.result.toString();
      });
    }, onError: (error) {
      setState(() {
        _responseApi = error.toString();
      });
    });
  }

  void _sumIntegersPostApi(String number1, String number2) {
    Post data = new Post(num1: int.parse(number1), num2: int.parse(number2));
    data.postPost(data).then((response){
      if (response.statusCode < 200 || response.statusCode > 400 || json == null)
        throw Exception('Cannot post data to API');
      var _decoder;
      return _decoder.convert(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pide Facil Logic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: num1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter an integer number'),
            ),
            TextField(
              controller: num2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter an integer number'),
            ),
            Text(
              '$_responseApi',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )
          ],
        ) ,
      ),
      floatingActionButton: Column(
        children: <Widget>[
          FloatingActionButton(
            // When the user presses the button, get the result of addition
            onPressed: () => _sumIntegersGetApi(),
            tooltip: 'Add two numbers!',
            child: Icon(Icons.cloud_download),
          ),
          FloatingActionButton(
            // When the user presses the button, post two integers to sum
            onPressed: () async => _sumIntegersPostApi(num1Controller.text, num2Controller.text),
            tooltip: 'Add two numbers!',
            child: Icon(Icons.cloud_upload),
          ),
        ],
      ),
    );
  }
}