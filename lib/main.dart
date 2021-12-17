import 'package:flutter/material.dart';
import 'package:inventory_app/widget/splash_screen.dart';

void main() {
  runApp(InventoryApp());
}

class InventoryApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen()
    );
  }
}