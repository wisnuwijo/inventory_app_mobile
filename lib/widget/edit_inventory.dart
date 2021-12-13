import 'package:flutter/material.dart';

class EditInventory extends StatefulWidget {
  EditInventory({Key key}) : super(key: key);

  @override
  _EditInventoryState createState() => _EditInventoryState();
}

class _EditInventoryState extends State<EditInventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
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
                    labelText: 'Stok'
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Keterangan'
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
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