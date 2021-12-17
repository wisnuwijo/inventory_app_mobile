import 'package:dio/dio.dart';
import 'package:inventory_app/app/api/endpoint.dart';
import 'package:inventory_app/app/data_class/auth_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {

  Future<AuthType> checkAuth() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString('token');
    String role = _prefs.getString('role');

    AuthType _authType = AuthType(
      isLoggedIn: token != null,
      role: role
    );

    return _authType;
  }

  Future login(String username, String password) async {
    final dio = Dio();

    Response<dynamic> data;

    try {
      data = await dio.post(EndPoint.login, data: {
        'username': username,
        'password': password
      });

      bool _isDataExist = data.data.length > 0;
      if (_isDataExist) {
        bool _isTokenExist = data.data["data"].length > 0;
        if (_isTokenExist) {
          String authToken = data.data["data"]["auth_token"];
          String role = data.data["data"]["role"];

          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setString('token', authToken);
          _prefs.setString('role', role);
        }
      }
    } catch (e) {
      print(e);
    }

    return data;
  }

  Future logout() async {}
}