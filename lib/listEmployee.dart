import 'dart:convert';
import 'package:employee/main.dart';
import 'package:flutter/material.dart';
import 'package:employee/employeeDetail.dart';
import 'package:employee/addEmployee.dart';
import 'global.dart' as global;
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    title: "My Apps", 
    home: new ListEmployee(),
  ));
}

class ListEmployee extends StatefulWidget {
  @override
  _ListEmployeeState createState() => _ListEmployeeState();
}

class _ListEmployeeState extends State<ListEmployee> {
  var employees = {}, user = {};
  int employeesLength = 0;
  bool loading = true;

  getEmployeeData() async {
    print(global.user);
    String employeeUri = "https://reqres.in/api/users";
    var employeeRes = await http.get(employeeUri);
    employees = jsonDecode(employeeRes.body);
    employeesLength = employees.length;

    String userUri = "https://reqres.in/api/users/${global.user['id']}";
    var userRes = await http.get(userUri);
    user = jsonDecode(userRes.body);

    setState(() {
      loading = false;
    });
  }

  void initState() {
    super.initState();

    var userDetail = {};
    userDetail['id'] = 0;
    userDetail['first_name'] = "";
    userDetail['last_name'] = "";
    userDetail['email'] = "";
    userDetail['avatar'] = "";
    user['data'] = userDetail;

    getEmployeeData();
  }

  @override
  Widget build(BuildContext context) { 
    
    var employeeList = ListView.separated(
      padding: EdgeInsets.only(top: 10.0),
      separatorBuilder: (context, index) => Divider(
        color: Colors.black38,
      ),
      itemCount: employeesLength,
      itemBuilder: (context, index) {
        return ListTile ( 
          title: (employees['data'][index]['id']==user['data']['id']) ? Text(
            employees['data'][index]['first_name'] + " " + employees['data'][index]['last_name'] + " (Me)", 
            style: TextStyle(fontWeight: FontWeight.w500)
          ) : Text(
            employees['data'][index]['first_name'] + " " + employees['data'][index]['last_name'], 
            style: TextStyle(fontWeight: FontWeight.w500)
          ),
          leading: new Container(
            width: 50.0,
            height: 50.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(employees['data'][index]['avatar'])
              )
            )
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeDetail(),
                settings: RouteSettings(arguments: employees['data'][index]['id'])
              ),
            );
          },
        );
      },
    );

    var drawer = Drawer(
      child: ListView (
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(user['data']['avatar'])
                      )
                    )
                  ),
                  Text("Hello, " + user['data']['first_name'] + " " + user['data']['last_name'], style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeDetail(),
                  settings: RouteSettings(arguments: user['data']['id'])
                ),
              );
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              global.user = {};
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyApp())
              );
            },
          ),
        ],
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Employee"),
      ),
      drawer: drawer,
      body: loading ?  Center (
        child: new Image(image: new AssetImage("assets/loading.gif"), height: 60)
      ) : employeeList,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmployee()),
          );
        },
        icon: Icon(Icons.add),
        label: Text("Add Employee"),
        backgroundColor: Colors.blue[500],
      ),
      backgroundColor: Colors.white,
    );
  }
}