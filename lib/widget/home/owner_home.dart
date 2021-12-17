import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/app/api/inventory_api.dart';
import 'package:inventory_app/app/api/inventory_api_offline.dart';
import 'package:inventory_app/widget/add_inventory.dart';
import 'package:inventory_app/widget/detail_inventory.dart';
import 'package:inventory_app/widget/pdf_viewer.dart';

class OwnerHome extends StatefulWidget {
  OwnerHome({Key key}) : super(key: key);

  @override
  _OwnerHomeState createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {

  Future<Response> _inventoryList;

  @override
  void initState() {
    _inventoryList = InventoryApi().showList();
    super.initState();
  }

  _showMsg(String msg, List<Widget> actions) {
    return showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Pesan'),
        content: Text('$msg'),
        actions: actions,
      )
    );
  }

  _deleteInventory(String id) async {
    Navigator.pop(context);
    _showMsg('Memproses ...', []);
    final _delete = await InventoryApi().delete(id: id);
    
    Navigator.pop(context);

    if (_delete != null) {
      if (_delete.data["code"] == 200) {
        // success
        setState(() {
          _inventoryList = InventoryApi().showList();
        });

        _showMsg('Berhasil dihapus', [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('OK')
          )
        ]);
      } else {
        // error
        _showMsg('Oops, sepertinya ada yang salah. Mohon coba lagi', [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('OK')
          )
        ]);
      }
    } else {
      // error koneksi
      _showMsg('Kamu tidak terhubung internet', [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('OK')
          )
        ]);
    }
  }

  _confirmDelete(String id) {
    return showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi'),
        content: Text('Kamu yakin akan menghapus inventory?'),
        actions: [
          TextButton(
            onPressed: () => _deleteInventory(id), 
            child: Text('Hapus')
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('Batal')
          ),
        ],
      )
    );
  }

  _synchronizeData() async {
    _showMsg('Memproses ...', []);

    int _success = 0, _failed = 0;
    List<Map> _offlineData = await InventoryApiOffline().offlineData();
    for (var i = 0; i < _offlineData.length; i++) {
      final _inventory = _offlineData[i];

      var _sync;
      if (_inventory['image'] != null && _inventory['image'] != '') {
        _sync = await InventoryApi().add(
          image: File(_inventory['image']),
          name: _inventory['name'],
          note: _inventory['note'],
          stock: _inventory['stock'].toString(),
          unit: _inventory['unit']
        );
      } else {
        _sync = await InventoryApi().add(
          name: _inventory['name'],
          note: _inventory['note'],
          stock: _inventory['stock'].toString(),
          unit: _inventory['unit']
        );
      }

      print("sync : $_sync");
      if (_sync != null && _sync.data["code"] == 200) {
        _success += 1;
        await InventoryApiOffline().setToOnline(_inventory['id']);
      } else {
        _failed += 1;
      }
    }

    setState(() {
      _inventoryList = InventoryApi().showList();
    });

    Navigator.pop(context);
    _showMsg(
      '$_success data dari ${_offlineData.length} berhasil disinkronisasi', [
      TextButton(
        onPressed: () => Navigator.pop(context), 
        child: Text('OK')
      )
    ]);
  }

  Widget _offlineWarning() {
    return FutureBuilder(
      future: InventoryApiOffline().offlineData(),
      builder: (context, snapshot) {
        int _jumlahDataOffline = 0;
        if (snapshot.data != null) {
          _jumlahDataOffline = snapshot.data.length;
        }

        if (_jumlahDataOffline == 0) return Container();
        return Container(
          padding: EdgeInsets.all(20),
          color: Colors.orange[100],
          child: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Mohon sinkronisasi data Anda ($_jumlahDataOffline data)'),
                  TextButton(
                    onPressed: () => _synchronizeData(), 
                    child: Text('Sikronkan data')
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }

  Widget _inventoryListBody(Response data) {
    return ListView.builder(
      itemCount: data.data['data'].length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            index == 0
              ? _offlineWarning()
              : Container(),
            ListTile(
              trailing: IconButton(
                onPressed: () => _confirmDelete(data.data['data'][index]['id'].toString()), 
                icon: Icon(Icons.delete, color: Colors.red)
              ),
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => DetailInventory(
                      id: data.data['data'][index]['id'],
                      namaBarang: data.data['data'][index]['name'],
                    )
                  )
                );
              },
              title: Text('${data.data['data'][index]['name']}'),
              subtitle: Row(
                children: [
                  Expanded(child: Text('Stock : ${data.data['data'][index]['stock']} ${data.data['data'][index]['unit']}')),
                  Expanded(child: Text('Keterangan : ${data.data['data'][index]['note']}')),
                ],
              ),
            ),
            Divider(
              height: 1,
            )
          ],
        );
      }
    );
  }

  void _downloadFile() async {
    _showMsg('Memproses', []);
    String filePath = await InventoryApi().downloadPDF();
    print("filePath : $filePath");
    
    Navigator.pop(context);
    _showMsg('File berhasil tersimpan di $filePath', [
      TextButton(
        onPressed: () => Navigator.pop(context), 
        child: Text('OK')
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewer(
            pdfFile: File(filePath),
          )));
        }, 
        child: Text('Buka')
      )
    ]);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => AddInventory()
          )
        ),
      ),
      appBar: AppBar(
        title: Text('Inventory App'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.download), 
            onPressed: () => _downloadFile()
          )
        ],
      ),
      body: FutureBuilder(
        future: _inventoryList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // connection finished
            if (snapshot.hasData) {
              // request berhasil
              return _inventoryListBody(snapshot.data);
            } else {
              // request gagal
              return Center(child: Text('Oops, sepertinya ada yang salah'));
            }
          } else {
            // unfinished connection
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}