import 'package:flutter/material.dart';
import 'postApi.dart';
import 'app_style.dart' as Style;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pide Facil',
      theme: Style.AppTheme,
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

  void _tappedMenu(String texto) {
    setState(() {
        _responseApi= texto;
      });
  }
  /*void _sumIntegersGetApi() {
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
  }*/

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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pide Facil'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
            'El Hambriento',
            style: new TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            ),
          ),
          ListTile(
          title: Text('Entradas'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => _tappedMenu('Entradas'),
          ),
          ListTile(
          title: Text('Platos fuertes'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => _tappedMenu('Platos fuertes'),
          ),
          ListTile(
          title: Text('Bebidas'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => _tappedMenu('Bebidas'),
          ),
          ListTile(
          title: Text('Vinos'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => _tappedMenu('Vinos'),
          ),
          ListTile(
          title: Text('Postres'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => _tappedMenu('Postres'),
          ),
          Text(
            '$_responseApi',
            style: TextStyle(
              fontSize: 18.0,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
      /*body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'El Hambriento',
              style: new TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            ListView(
              children: const <Widget>[
                Card(child: ListTile(title: Text('One-line ListTile'))),
                Card(
                  child: ListTile(
                    leading: FlutterLogo(),
                    title: Text('One-line with leading widget'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('One-line with trailing widget'),
                    trailing: Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          ],
        ) ,
      ),*/
      /*floatingActionButton:
          FloatingActionButton(
            // When the user presses the button, post two integers to sum
            onPressed: () async => _sumIntegersPostApi(num1Controller.text, num2Controller.text),
            tooltip: 'Add two numbers!',
            child: Icon(Icons.add),
          ),*/
    );
  }
}