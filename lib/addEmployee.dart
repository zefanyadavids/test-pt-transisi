import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:employee/listEmployee.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    title: "My Apps", 
    home: new AddEmployee(),
  ));
}

class AddEmployee extends StatefulWidget {
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  String job;
  List jobEnum = ["Head Operation", "Manager", "Supervisior", "Staff"];
  final name = TextEditingController();

  createEmployee(_name, _job) async {
    Map<String, Object> newEmployee = {};
    newEmployee['name'] = _name;
    newEmployee['job'] = _job;
    var _body = jsonEncode(newEmployee);

    if(_name=="" || _name==null || _job==null) {
      String message;

      if(_name=="" || _name==null)
        message = "Error, please fill the name field";
      if(_job==null)
        message = "Error, please choose the job position";
      if(_name=="" && _job==null)
        message = "Error, please fill the field";

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(message, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),)
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Close", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    } else {
      String url = 'https://reqres.in/api/users';
      Map<String, String> headers = {"Content-type": "application/json"};
      http.Response response = await http.post(url, headers: headers, body: _body);
      print(response.body);

      if(response.statusCode==201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Text("Success, employee has been added", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),)
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        ).then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ListEmployee())
          );
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Text("Error, failed to add employee", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),)
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Close", style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var fieldName = ListTile (
      title: TextFormField(
        decoration: InputDecoration(
          labelText: 'Name'
        ),
        controller: name,
      ),
      leading: Icon(
        Icons.person,
        color: Colors.blue[500],
      ),
    );

    var fieldJob = ListTile (
      title: Container(
        width: 400,
        height: 50,
        margin: const EdgeInsets.only(top: 8.0),
        child: DropdownButton(
          isExpanded: true,
          hint: Text("Choose Job Position"),
          value: job,
          items: jobEnum.map((value) {
            return DropdownMenuItem(
              child: Text(value),
              value: "$value",
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              job = value;
            });
          }
        ),
      ),
      leading: Icon(
        Icons.business_center,
        color: Colors.blue[500],
      ),
    );

    var raisedButton = Container (
      width: 400,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        color:  Colors.blue[500],
        onPressed: () {
          createEmployee(name.text, job);
        },
        child: Text('Add', style: TextStyle( color:Colors.white )),
      )
    );

    var registerForm = Container(
      margin: EdgeInsets.all(20.0),
      child: Form(
        child: Column(
          children: [
            fieldName,
            fieldJob,
            raisedButton,
          ],
        )
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: new Text("Add New Employee"),
        backgroundColor: Colors.blue[500],
      ),
      body: Container(
        child: Column(children: <Widget>[
          registerForm
        ],)
      ),
      backgroundColor: Colors.white,
    );
  }
}