import 'package:flutter/material.dart';
import 'home/employee_home.dart';

class AddInventory extends StatefulWidget {
  AddInventory({Key key}) : super(key: key);

  @override
  _AddInventoryState createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Inventory'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nama Barang'
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stok Barang'
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmployeeHome())),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Simpan')
                      ],
                    ),
                  )
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}