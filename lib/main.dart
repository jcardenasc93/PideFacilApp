import 'package:flutter/material.dart';
import 'app_style.dart' as Style;
import './pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pide Facil',
      theme: Style.AppTheme,
      home: HomePage(),
    );
  }
}

// Define a Custom Form Widget
/*class MyCustomForm extends StatefulWidget {
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

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    num1Controller.dispose();
    num2Controller.dispose();
    super.dispose();
  }


  /*void _sumIntegersPostApi(String number1, String number2) {
    Post data = new Post(num1: int.parse(number1), num2: int.parse(number2));
    data.postPost(data).then((post) {
      setState(() {
        _responseApi= post.toString();
      });
    }, onError: (error) {
      setState(() {
        _responseApi = error.toString();
      });
    });
  }
  */*/