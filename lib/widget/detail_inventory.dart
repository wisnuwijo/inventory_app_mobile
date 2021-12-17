import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/app/api/inventory_api.dart';
import 'package:inventory_app/widget/edit_inventory.dart';

class DetailInventory extends StatefulWidget {
  final String namaBarang;
  final int id;

  DetailInventory({
    Key key,
    this.namaBarang,
    this.id
  }) : super(key: key);

  @override
  _DetailInventoryState createState() => _DetailInventoryState();
}

class _DetailInventoryState extends State<DetailInventory> {

  Future<Response> _detail;

  @override
  void initState() {
    _detail = InventoryApi().detail(widget.id);
    super.initState();
  }

  Widget _detailInventoryBody(Response data) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text('Nama Barang')),
                Expanded(child: Text('${data.data["data"]["name"]}')),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(child: Text('Stok')),
                Expanded(child: Text('${data.data["data"]["stock"]} ${data.data["data"]["unit"]}')),
              ],
            ),
            Divider(),
            Text('Keterangan'),
            SizedBox(height: 10),
            Text('${data.data["data"]["note"]}')
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.namaBarang}'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
              context, MaterialPageRoute(
                builder: (context) => EditInventory(
                  id: widget.id.toString(),
                )
              )
            ), 
            child: Text('EDIT', style: TextStyle(
              color: Colors.white
            ))
          )
        ],
      ),
      body: FutureBuilder(
        future: _detail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // connection done
            if (snapshot.hasData) {
              // request success
              return _detailInventoryBody(snapshot.data);
            } else {
              // request failed
              return Center(
                child: Text('Oops, sepertinya ada salah'),
              );
            }
          } else {
            // connection isn't done yet
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}