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

  // Create the suma var
  int _suma = 0;
  String _responseApi = "";

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    num1Controller.dispose();
    num2Controller.dispose();
    super.dispose();
  }

  void _sumIntegersApi(String num1, String num2) {
    var api = new Post();
    /*FutureBuilder<Post>(
      future: api.fetchPost(),
      builder: (context, snapshot){
        if(snapshot.hasData)
          return Text(snapshot.data.body);
        else if(snapshot.hasError)
          return Text("${snapshot.error}");

        return CircularProgressIndicator();
      },
    );*/

    api.fetchPost().then((post) {
      setState(() {
        _responseApi = post.title;
      });
    }, onError: (error) {
      setState(() {
        _responseApi = error.toString();
      });
    });
    /*setState(() {
      int a = int.parse(num1);
      int b = int.parse(num2);
      _suma = a + b;

      _responseApi = api.fetchPost()

    });*/
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
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog with the
        // result of the addition
        onPressed: () => _sumIntegersApi(num1Controller.text, num2Controller.text),
        tooltip: 'Add two numbers!',
        child: Icon(Icons.add),
      ),
    );
  }
}