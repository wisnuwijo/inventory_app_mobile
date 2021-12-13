import 'package:flutter/material.dart';
import 'package:inventory_app/widget/edit_inventory.dart';

class DetailInventory extends StatefulWidget {
  final String namaBarang;

  DetailInventory({
    Key key,
    this.namaBarang
  }) : super(key: key);

  @override
  _DetailInventoryState createState() => _DetailInventoryState();
}

class _DetailInventoryState extends State<DetailInventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.namaBarang}'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditInventory())), 
            child: Text('EDIT', style: TextStyle(
              color: Colors.white
            ))
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Nama Barang')),
                  Expanded(child: Text('Bolpoin')),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Expanded(child: Text('Stok')),
                  Expanded(child: Text('1 pcs')),
                ],
              ),
              Divider(),
              Text('Keterangan'),
              SizedBox(height: 10),
              Text('Abcd asda sda sd asda sda sd as da sd as da sd asd as')
            ],
          )
        ),
      ),
    );
  }
}