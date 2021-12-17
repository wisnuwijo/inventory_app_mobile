import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_app/app/api/inventory_api.dart';
import 'package:inventory_app/widget/splash_screen.dart';

class EditInventory extends StatefulWidget {
  final String id;

  EditInventory({
    Key key,
    this.id
  }) : super(key: key);

  @override
  _EditInventoryState createState() => _EditInventoryState();
}

class _EditInventoryState extends State<EditInventory> {

  GlobalKey<FormState> _addInventoryForm = GlobalKey<FormState>();
  TextEditingController _namaBarang = TextEditingController();
  TextEditingController _stok = TextEditingController();
  TextEditingController _satuan = TextEditingController();
  TextEditingController _keterangan = TextEditingController();

  File _gambar;

  bool _apiCall = false;

  Future<Response> _detail;

  @override
  void initState() {
    _detail = InventoryApi().detail(int.parse(widget.id)).then((inventoryDetail) {
      _namaBarang.text = inventoryDetail.data["data"]["name"];
      _stok.text = inventoryDetail.data["data"]["stock"].toString();
      _satuan.text = inventoryDetail.data["data"]["unit"];
      _keterangan.text = inventoryDetail.data["data"]["note"];
      
      return inventoryDetail;
    });
    super.initState();
  }

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

      var _addInventory;
      if (_gambar != null) {
        _addInventory = await InventoryApi().update(
          id: widget.id,
          name: _namaBarang.text,
          note: _keterangan.text,
          stock: _stok.text,
          unit: _satuan.text,
          image: _gambar
        ); 
      } else {
        _addInventory = await InventoryApi().update(
          id: widget.id,
          name: _namaBarang.text,
          note: _keterangan.text,
          stock: _stok.text,
          unit: _satuan.text
        );
      }

      if (_addInventory == null) {
        // offline
        showMessage("Maaf anda offline, mohon coba lagi", [
          TextButton(
            onPressed: () => Navigator.pop(context), 
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
        title: Text('Edit Inventory'),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _detail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // request selesai
            if (snapshot.hasData) {
              // request berhasil
              return _editInventoryForm(snapshot.data);
            } else {
              // koneksi bermasalah
              return Center(
                child: Text('Tidak ada koneksi'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }

  SingleChildScrollView _editInventoryForm(Response data) {
    return SingleChildScrollView(
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
                      : data.data["data"]["image"] == null
                        ? Text('Ambil gambar')
                        : Image.network(data.data["data"]["image"]),
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
    );
  }
}