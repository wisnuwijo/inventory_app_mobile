import 'package:flutter/material.dart';
import 'package:inventory_app/app/api/authentication.dart';
import 'package:inventory_app/widget/home/employee_home.dart';
import 'package:inventory_app/widget/home/owner_home.dart';
import 'package:inventory_app/widget/login.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Authentication().checkAuth().then((value) => {
      if (value.isLoggedIn) {
        // sudah login  
        if (value.role == 'owner') {
          // redirect ke owner
          Future.delayed(Duration(
            seconds: 2
          ), () => Navigator.pushReplacement(
            context, MaterialPageRoute(
              builder: (context) => OwnerHome()
            )
          ))
        } else {
          // redirect ke employee
          Future.delayed(Duration(
            seconds: 2
          ), () => Navigator.pushReplacement(
            context, MaterialPageRoute(
              builder: (context) => EmployeeHome()
            )
          ))
        }
      } else {
        // belum login
        // redirect ke login
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()))
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Inventory App'),
        )
      ),
    );
  }
}