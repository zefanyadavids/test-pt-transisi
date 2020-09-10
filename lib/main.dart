import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:employee/listEmployee.dart';
import 'global.dart' as global;
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Employee List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isValid = true;
  final email = TextEditingController();
  final password = TextEditingController();

  validation(_email, _password, _isValid) async {
    Map<String, Object> login = {};
    login['email'] = _email;
    login['password'] = _password;
    var _body = jsonEncode(login);

    String url = 'https://reqres.in/api/register';
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post(url, headers: headers, body: _body);
    print(response.body);

    if(response.statusCode==200) {
      global.user = jsonDecode(response.body);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ListEmployee())
      );
    } else {
      setState(() {
        isValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var loginText = Container(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text("Employee Management", style: TextStyle(fontSize: 24),),
    );

    var fieldEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
      ),
      controller: email,
    );

    var fieldPassword = TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter Password',
      ),
      controller: password,
    );

    var invalidNotice = Container(
      margin: const EdgeInsets.only(top: 30.0),
      child: Text("Incorrect email or password. Please try again!", style: TextStyle(color: Colors.red[700])),
    );

    var raisedButton = Container (
      width: 400,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        color:  Colors.blue[500],
        onPressed: () {
          print(password.text);
          print(email.text);
          validation(email.text, password.text, isValid);
        },
        child: Text('Login', style: TextStyle( color:Colors.white )),
      )
    );

    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(50.0),
          alignment: Alignment.center,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Column(children: <Widget>[
                    loginText,
                    fieldEmail,
                    fieldPassword,
                    isValid ? Container() : invalidNotice,
                    raisedButton,
                  ],),
                )
              ],
            )
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}