import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:maktampos/services/constant.dart';
import 'package:maktampos/services/model/login_response.dart';
import 'package:maktampos/services/network_exception.dart';
import 'package:maktampos/services/param/login_param.dart';

abstract class AuthenticationRepository {
  Future<LoginResponse?> postLogin(LoginParam loginPram);
}

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final Dio _dioClient;

  AuthenticationRepositoryImpl(this._dioClient);

  @override
  Future<LoginResponse?> postLogin(LoginParam loginPram) async {
    try {
      final response = await _dioClient.post(Constant.login,
          data: loginPram.toMap(),
          options: buildCacheOptions(
              const Duration(hours: Constant.cacheDurationHours),
              forceRefresh: true));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }
}
