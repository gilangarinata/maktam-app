import 'package:alice_lightweight/alice.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:maktampos/preferences/pref_data.dart';
import 'package:maktampos/services/constant.dart';
import 'package:maktampos/services/model/login_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  Dio init(Alice? alice,{bool isNewApi = false} ) {
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
    if(isNewApi){
      _dio.options.baseUrl = Constant.baseUrl2;
    }else{
      _dio.options.baseUrl = Constant.baseUrl;
    }
    _dio.options.connectTimeout = Constant.writeTimeout;
    _dio.options.receiveTimeout = Constant.readTimeout;
    _dio.interceptors.add(DioCacheManager(
            CacheConfig(baseUrl: Constant.baseUrl, defaultRequestMethod: "GET"))
        .interceptor);
    return _dio;
  }
}

class ApiInterceptors extends Interceptor {
  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return "Bearer ${prefs.getString(PrefData.accessToken)}";
  }

  Future<String> _getTempToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return "Bearer ${prefs.getString("TEMP_TOKEN")}";
  }

  Future<bool> getIsTemp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("TEMP") ?? false;
  }

  void _saveToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefData.accessToken, token ?? "");
  }

  void _saveTempToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("TEMP_TOKEN", token ?? "");
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
    var isTemp = await getIsTemp();
    if(isTemp){
      options.headers = {
        "Authorization": await _getTempToken(),
      };
    }else{
      options.headers = {
        "Authorization": await _getToken(),
      };
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    super.onResponse(response, handler);
    if (response.statusCode == Constant.successCode) {
      if (response.realUri.path.contains(Constant.login)) {
        var isTemp = await getIsTemp();
        if(isTemp){
          _saveTempToken(LoginResponse.fromJson(response.data).token);
        }else{
          _saveToken(LoginResponse.fromJson(response.data).token);
          _saveRole(LoginResponse.fromJson(response.data).role?.roleName);
        }
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
