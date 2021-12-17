import 'package:dio/dio.dart';
import 'package:inventory_app/app/api/endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {

  Future updateToken({
    String firebaseToken
  }) async {
    final dio = Dio();

    Response<dynamic> data;

    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String token = _prefs.getString('token');

      var formData = FormData.fromMap({
        'firebase_token': firebaseToken,
        'token': token
      });

      data = await dio.post(EndPoint.updateFcmToken, data: formData).timeout(Duration(
        seconds: 30
      ));
    } catch (e) {
      print(e);
    }

    return data;
  }
}