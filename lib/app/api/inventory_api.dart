import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'endpoint.dart';
import 'package:permission_handler/permission_handler.dart';

class InventoryApi {

  Future add({
    String note,
    String name,
    String stock,
    String unit,
    File image
  }) async {
    final dio = Dio();

    Response<dynamic> data;

    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String token = _prefs.getString('token');

      var formData;
      print('image != null ${image != null}');
      if (image != null) {
        formData = FormData.fromMap({
          'token': token,
          'note': note,
          'name': name,
          'stock': stock,
          'unit': unit,
          'image': await MultipartFile.fromFile(image.path)
        });
      } else {
        formData = FormData.fromMap({
          'token': token,
          'note': note,
          'name': name,
          'stock': stock,
          'unit': unit
        });
      }

      data = await dio.post(EndPoint.add, data: formData).timeout(Duration(
        seconds: 30
      ));
    } catch (e) {
      print(e);
    }

    return data;
  }

  Future update({
    String note,
    String name,
    String stock,
    String unit,
    File image,
    String id
  }) async {
    final dio = Dio();

    Response<dynamic> data;

    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String token = _prefs.getString('token');

      var formData;
      if (image != null) {
        formData = FormData.fromMap({
          'token': token,
          'note': note,
          'name': name,
          'stock': stock,
          'unit': unit,
          'id': id,
          'image': await MultipartFile.fromFile(image.path)
        });
      } else {
        formData = FormData.fromMap({
          'token': token,
          'note': note,
          'name': name,
          'stock': stock,
          'unit': unit,
          'id': id
        });
      }

      data = await dio.post(EndPoint.update, data: formData).timeout(Duration(
        seconds: 30
      ));
    } catch (e) {
      print(e);
    }

    return data;
  }

  Future delete({
    String id
  }) async {
    final dio = Dio();

    Response<dynamic> data;

    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String token = _prefs.getString('token');

      var formData = FormData.fromMap({
        'token': token,
        'id': id
      });

      data = await dio.post(EndPoint.delete, data: formData).timeout(Duration(
        seconds: 30
      ));
    } catch (e) {
      print(e);
    }

    return data;
  }

  Future<Response<dynamic>> showList() async {
    final dio = Dio();

    Response<dynamic> data;

    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String token = _prefs.getString('token');

      var formData = {
        'token': token
      };

      data = await dio.get(EndPoint.showList, queryParameters: formData).timeout(Duration(
        seconds: 30
      ));
    } catch (e) {
      print(e);
    }

    return data;
  }

  Future<Response<dynamic>> detail(int id) async {
    final dio = Dio();

    Response<dynamic> data;

    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String token = _prefs.getString('token');

      var formData = {
        'token': token,
        'id': id
      };

      data = await dio.get(EndPoint.detail, queryParameters: formData).timeout(Duration(
        seconds: 30
      ));
    } catch (e) {
      print(e);
    }

    return data;
  }

  Future<String> downloadPDF() async {
    final dio = Dio();

    String finalPath;

    try {
      if (await Permission.storage.request().isGranted) {
        // ijin didapatkan
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        String token = _prefs.getString('token');

        Directory path = await getExternalStorageDirectory();
        String filePath = path.path + "INVENTORY.PDF";

        var formData = {'token': token};
        final response = await dio.download(EndPoint.exportPdf, filePath, queryParameters: formData).timeout(Duration(seconds: 60));
        if (response.data != null) {
          finalPath = filePath;
        }
      }
    } catch (e) {
      print(e);
    }

    return finalPath;
  }
}