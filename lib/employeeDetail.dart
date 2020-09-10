import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    title: "My Apps", 
    home: new EmployeeDetail(),
  ));
}

class EmployeeDetail extends StatefulWidget {
  @override
  _EmployeeDetailState createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  var employee = {};
  bool loading = true;

  getEmployeeDetail(employeeNum) async {
    String employeeDetailUri = "https://reqres.in/api/users/" + "$employeeNum";
    var employeeDetailRes = await http.get(employeeDetailUri);
    employee = jsonDecode(employeeDetailRes.body);
    print(employee);

    setState(() {
      loading = false;
    });
  }

  nothing() {

  }

  void initState() {
    super.initState();

    var dataEmployee = {};
    dataEmployee['id'] = 0;
    dataEmployee['first_name'] = "";
    dataEmployee['last_name'] = "";
    dataEmployee['email'] = "";
    dataEmployee['avatar'] = "";
    employee['data'] = dataEmployee;

    var adEmployee = {};
    adEmployee['company'] = "";
    adEmployee['text'] = "";
    employee['ad'] = adEmployee;
  }
  
  @override
  Widget build(BuildContext context) {
    int employeeNum = ModalRoute.of(context).settings.arguments;
    loading ? getEmployeeDetail(employeeNum) : nothing();

    var profileImage = Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Stack (
        children: <Widget>[
          Container(
            color: Colors.black,
            child: SizedBox(
              height: 300,
              width: 600,
            )
          ),
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.transparent],
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: Container(
              width: 600,
              height: 300,
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.red]
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: new NetworkImage(employee['data']['avatar']),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal : 20.0, vertical: 0.0),
            child: SizedBox(
              height: 280,
              child: Align(
                alignment:  Alignment.bottomLeft,
                child: Text(employee['data']['first_name'] + " " + employee['data']['last_name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    color: Colors.white)
                  ),
              )
            ), 
          ),
        ],
      )
      
    );

    var email = Padding (
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: SizedBox(
        height: 80,
        child: Card (
          child: Column(
            children: [
              ListTile (
                title: Text(employee['data']['email'], style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text("Email"),
                leading: Icon(
                  Icons.email,
                  color: Colors.blue[500],
                ),
              )
            ],
          ),
        ),
      ),
    );

    var job = Padding (
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card (
        child: Column(
          children: [
            ListTile (
              title: Text(employee['ad']['company'], style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text("Company"),
              leading: Icon(Icons.business, color: Colors.blue[500]),
            ),
            ListTile (
              title: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(employee['ad']['text']),
              ),
            ),
          ],
        ),
      ),
    );


    return Scaffold(
      appBar: AppBar(
        title: new Text("Employee Profile"),
        backgroundColor: Colors.blue[500],
      ),
      body: loading ? Center (
        child: new Image(image: new AssetImage("assets/loading.gif"), height: 60)
      ) : ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          profileImage,
          email,
          job,
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}