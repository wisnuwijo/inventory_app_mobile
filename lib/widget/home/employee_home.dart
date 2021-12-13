import 'package:flutter/material.dart';
import 'package:inventory_app/app/data_class/InventoryData.dart';
import 'package:inventory_app/widget/add_inventory.dart';
import '../detail_inventory.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({Key key}) : super(key: key);

  @override
  _EmployeeHomeState createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {

  List<InventoryData> _data = [
    InventoryData(
      id: 1,
      nama: "Pensil",
      satuan: "pcs",
      stok: 1,
      keterangan: "Pensil premium"
    ),
    InventoryData(
      id: 2,
      nama: "Bolpoin",
      satuan: "pcs",
      stok: 1,
      keterangan: "Bolpin teknik"
    )
  ];

  _confirmDelete(int id, String namaBarang) {
    return showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Peringatan'),
        content: Text('Yakin hapus $namaBarang?'),
        actions: [
          TextButton(
            onPressed: () {}, 
            child: Text('Batal')
          ),
          ElevatedButton(
            onPressed: () {}, 
            child: Text('Hapus')
          )
        ],
      )
    );
  }

  _showMoreButton() {
    return showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Opsi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Download PDF'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Keluar'),
              onTap: () {},
            )
          ],
        ),
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddInventory())),
      ),
      appBar: AppBar(
        title: Text('Inventory App'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert), 
            onPressed: () => _showMoreButton()
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${_data[index].nama}'),
            subtitle: Text('Stok : ${_data[index].stok} ${_data[index].satuan}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red), 
              onPressed: () => _confirmDelete(_data[index].id, _data[index].nama)
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailInventory(
              namaBarang: _data[index].nama
            ))),
          );
        }
      ),
    );
  }
}