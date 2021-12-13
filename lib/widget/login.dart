import 'package:flutter/material.dart';
import 'home/employee_home.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Login', style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  )),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username'
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password'
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmployeeHome())),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Masuk')
                        ],
                      ),
                    )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}