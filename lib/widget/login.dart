import 'package:flutter/material.dart';
import 'package:inventory_app/app/api/authentication.dart';
import 'package:inventory_app/widget/home/owner_home.dart';
import 'home/employee_home.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController _usernameText = TextEditingController();
  TextEditingController _passwordText = TextEditingController();

  void _submitLogin() async {
    String _usernameValue = _usernameText.text, 
          _passwordValue = _passwordText.text;

    if (_loginFormKey.currentState.validate()) {
      final _login = await Authentication().login(_usernameValue, _passwordValue);
      bool _loginSuccess = _login != null && _login.data["code"] == 200;
      bool _noConnection = _login == null;
      bool _usernameOrPasswordWrong = _login != null && _login.data["code"] == 403;

      if (_loginSuccess) {
        String _role = _login.data["data"]["role"];
        if (_role == "employee") {
          Navigator.pushReplacement(
            context, MaterialPageRoute(
              builder: (context) => EmployeeHome()
            )
          );
        } else {
          Navigator.pushReplacement(
            context, MaterialPageRoute(
              builder: (context) => OwnerHome()
            )
          );
        }
      } else {
        if (_usernameOrPasswordWrong) {
          print('username/password wrong');
        } else if (_noConnection) {
          print('no connection');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Login', style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  )),
                  TextFormField(
                    controller: _usernameText,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Harus diisi';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Username'
                    ),
                  ),
                  TextFormField(
                    controller: _passwordText,
                    obscureText: true,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Harus diisi';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password'
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => _submitLogin(),
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