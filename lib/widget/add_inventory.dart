import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_app/app/api/inventory_api.dart';
import 'package:inventory_app/app/api/inventory_api_offline.dart';
import 'package:inventory_app/widget/splash_screen.dart';

class AddInventory extends StatefulWidget {
  AddInventory({Key key}) : super(key: key);

  @override
  _AddInventoryState createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {

  GlobalKey<FormState> _addInventoryForm = GlobalKey<FormState>();
  TextEditingController _namaBarang = TextEditingController();
  TextEditingController _stok = TextEditingController();
  TextEditingController _satuan = TextEditingController();
  TextEditingController _keterangan = TextEditingController();

  File _gambar;

  bool _apiCall = false;

  showMessage(String msg, List<Widget> actions) {
    return showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Pesan'),
        content: Text('$msg'),
        actions: actions,
      )
    );
  }

  void _saveInventory() async {
    if (_addInventoryForm.currentState.validate()) {
      setState(() {
        _apiCall = true;
      });

      final _addInventory = await InventoryApi().add(
        name: _namaBarang.text,
        note: _keterangan.text,
        stock: _stok.text,
        unit: _satuan.text,
        image: _gambar
      );

      if (_addInventory == null) {
        // offline
        await InventoryApiOffline().add(
          name: _namaBarang.text,
          note: _keterangan.text,
          stock: int.parse(_stok.text),
          unit: _satuan.text,
          image: _gambar
        );

        showMessage("Maaf anda offline, data akan terupload ketika Anda sudah terhubung internet", [
          TextButton(
            onPressed: () => Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => SplashScreen()
              )
            ),
            child: Text('OK')
          )
        ]);
      } else if (_addInventory != null && _addInventory.data["code"] == 200) {
        // success
        showMessage("Inventory disimpan", [
          TextButton(
            onPressed: () => Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => SplashScreen()
              )
            ),
            child: Text('OK')
          )
        ]);
      } else {
        // error
        showMessage("Oops, sepertinya ada yang salah. Mohon coba lagi", [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('OK')
          )
        ]);
      }

      setState(() {
        _apiCall = false;
      });
    }
  }

  void _takePicture() async {
    XFile _takeImage = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 20);
    setState(() {
      _gambar = File(_takeImage.path);
    });
  }

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
            key: _addInventoryForm,
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      child: _gambar != null
                        ? Image.file(_gambar)
                        : Text('Ambil gambar'),
                    ),
                    TextButton(
                      onPressed: () => _takePicture(), 
                      child: Text('Ambil Gambar')
                    )
                  ],
                ),
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Harus diisi";
                    }

                    return null;
                  },
                  controller: _namaBarang,
                  decoration: InputDecoration(
                    labelText: 'Nama Barang'
                  ),
                ),
                TextFormField(
                  controller: _stok,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Harus diisi";
                    }

                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stok Barang'
                  ),
                ),
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Harus diisi";
                    }

                    return null;
                  },
                  controller: _satuan,
                  decoration: InputDecoration(
                    labelText: 'Satuan'
                  ),
                ),
                TextFormField(
                  controller: _keterangan,
                  decoration: InputDecoration(
                    labelText: 'Keterangan'
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _apiCall
                    ? null
                    : _saveInventory(),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_apiCall ? 'Menyimpan ...' : 'Simpan')
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