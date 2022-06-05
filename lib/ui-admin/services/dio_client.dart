import 'package:alice_lightweight/alice.dart';
import 'package:dio/dio.dart';
import 'package:maktampos/ui-admin/preferences/pref_data.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';
import 'responses/login_response.dart';

class DioClient {
  Dio init(Alice? alice) {
    Dio _dio = Dio();
    _dio.interceptors.add(ApiInterceptors());
    if (alice != null) _dio.interceptors.add(alice.getDioInterceptor());
    _dio.interceptors.add(
      PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90),
    );
    _dio.options.contentType = 'application/json';
    _dio.options.baseUrl = Constant.baseUrl;
    _dio.options.connectTimeout = Constant.writeTimeout;
    _dio.options.receiveTimeout = Constant.readTimeout;
    return _dio;
  }
}

class ApiInterceptors extends Interceptor {
  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcGkuc3VzdW1ha3RhbS5jb21cL2xvZ2luIiwiaWF0IjoxNjQ1NzkyMDU2LCJleHAiOjQ4MDgxNzYwNDYwNDE1MTY4NTYsIm5iZiI6MTY0NTc5MjA1NiwianRpIjoiNENoQW83WU5tTFBxR3NEMyIsInN1YiI6NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.OEsPLQ-SKepVwSN___RE767OMS2G9pbJ60i71arBYiw";
    // return "Bearer ${prefs.getString(PrefData.accessToken)}";
  }

  void _saveToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefData.accessToken, token ?? "");
  }

  void _saveRole(String? role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefData.role, role ?? "");
  }

  void _clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers = {
      "Authorization": await _getToken(),
    };
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    if (response.statusCode == Constant.successCode) {
      if (response.realUri.path.contains(Constant.login)) {
        _saveToken(LoginResponse.fromJson(response.data).token);
        _saveRole(LoginResponse.fromJson(response.data).role?.roleName);
      }
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    var statusCode = err.response?.statusCode ?? -1;
    if (statusCode == 401) {
      _clearToken();
    }
  }
}
