import 'dart:async';

import 'package:dio/dio.dart';
import 'package:maktampos/ui-admin/res/var_constants.dart';
import 'package:maktampos/ui-admin/services/param/category_param.dart';
import 'package:maktampos/ui-admin/services/param/inventory_param.dart';
import 'package:maktampos/ui-admin/services/param/outlet_param.dart';
import 'package:maktampos/ui-admin/services/param/product_param.dart';
import 'package:maktampos/ui-admin/services/param/user_param.dart';
import 'package:maktampos/ui-admin/services/responses/base_response.dart';
import 'package:maktampos/ui-admin/services/responses/category_response.dart';
import 'package:maktampos/ui-admin/services/responses/outlet_response.dart';
import 'package:maktampos/ui-admin/services/responses/subcategory_response.dart';
import 'package:maktampos/ui-admin/services/responses/inventory_response.dart';
import 'package:maktampos/ui-admin/services/responses/login_response.dart';
import 'package:maktampos/ui-admin/services/responses/material_item_response.dart';
import 'package:maktampos/ui-admin/services/responses/material_response.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';
import 'package:maktampos/ui-admin/services/responses/selling_response.dart';
import 'package:maktampos/ui-admin/services/responses/stock_response.dart';
import 'package:maktampos/ui-admin/services/responses/summary_response.dart';
import 'package:collection/collection.dart';
import 'package:maktampos/ui-admin/services/param/login_param.dart';
import 'package:collection/collection.dart';
import 'package:maktampos/ui-admin/services/responses/user_response.dart';
import '../constant.dart';
import '../network_exception.dart';


abstract class MaktamRepository {
  Future<List<UserResponse>?> getUsers();
  Future<bool> createUser(UserParam userParam);
  Future<bool> updateUser(UserParam userParam);
  Future<bool> deleteUser(int id);

  Future<List<OutletItem>?> getOutlets();
  Future<bool> createOutlet(OutletParam param);
  Future<bool> updateOutlet(OutletParam param);
  Future<bool> deleteOutlet(int id);
}

class MaktamRepositoryImpl extends MaktamRepository {
  final Dio _dioClient;

  MaktamRepositoryImpl(this._dioClient);

  @override
  Future<List<UserResponse>?> getUsers() async {
    try {
      final response = await _dioClient.get(Constant.users,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var userResponse = List<UserResponse>.from(response.data.map((e) => UserResponse.fromJson(e)));
        return userResponse;
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      print("gilang" + statusMessage);
      throw ClientErrorException(statusMessage, statusCode);
    } catch ( e) {
      print("gilang2" + e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<bool> updateUser(UserParam userParam) async {
    try {
      final response = await _dioClient.put(Constant.users,data: userParam.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var baseResponse = BaseResponse.fromJson(response.data);
        if(baseResponse.success == true){
          return true;
        }else{
          throw ClientErrorException(baseResponse.message ?? "Gagal membuat user", statusCode);
        }
      } else {
        var baseResponse = BaseResponse.fromJson(response.data);
        throw ClientErrorException(baseResponse.message ?? "", statusCode);
      }
    } on DioError catch (ex) {
      var baseResponse = baseResponseFromJson(ex.response.toString());
      throw ClientErrorException(baseResponse.message ?? "Gagal Membuat User, username tidak boleh ada yang sama", 500);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> createUser(UserParam userParam) async {
    try {
      final response = await _dioClient.post(Constant.users,data: userParam.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var baseResponse = BaseResponse.fromJson(response.data);
        if(baseResponse.success == true){
          return true;
        }else{
          throw ClientErrorException(baseResponse.message ?? "Gagal membuat user", statusCode);
        }
      } else {
        var baseResponse = BaseResponse.fromJson(response.data);
        throw ClientErrorException(baseResponse.message ?? "", statusCode);
      }
    } on DioError catch (ex) {
      var baseResponse = baseResponseFromJson(ex.response.toString());
      throw ClientErrorException(baseResponse.message ?? "Gagal Membuat User, username tidak boleh ada yang sama", 500);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<OutletItem>?> getOutlets() async {
    try {
      final response = await _dioClient.get(Constant.outlet,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return OutletResponse.fromJson(response.data).items;
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

  @override
  Future<bool> deleteUser(int id) async {
    try {
      final response = await _dioClient.delete(Constant.users,queryParameters: {
        "id" : id
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var isSuccess = BaseResponse.fromJson(response.data).success;
        return isSuccess ?? false;
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

  @override
  Future<bool> createOutlet(OutletParam param) async {
    try {
      final response = await _dioClient.post(Constant.outlet,data: param.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var baseResponse = BaseResponse.fromJson(response.data);
        if(baseResponse.success == true){
          return true;
        }else{
          throw ClientErrorException(baseResponse.message ?? "Gagal membuat user", statusCode);
        }
      } else {
        var baseResponse = BaseResponse.fromJson(response.data);
        throw ClientErrorException(baseResponse.message ?? "", statusCode);
      }
    } on DioError catch (ex) {
      var baseResponse = baseResponseFromJson(ex.response.toString());
      throw ClientErrorException(baseResponse.message ?? "Gagal Membuat User, username tidak boleh ada yang sama", 500);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> deleteOutlet(int id) async {
    try {
      final response = await _dioClient.delete(Constant.outlet,queryParameters: {
        "id" : id
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var isSuccess = BaseResponse.fromJson(response.data).success;
        return isSuccess ?? false;
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

  @override
  Future<bool> updateOutlet(OutletParam param) async {
    try {
      final response = await _dioClient.put(Constant.outlet,data: param.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var baseResponse = BaseResponse.fromJson(response.data);
        if(baseResponse.success == true){
          return true;
        }else{
          throw ClientErrorException(baseResponse.message ?? "Gagal membuat user", statusCode);
        }
      } else {
        var baseResponse = BaseResponse.fromJson(response.data);
        throw ClientErrorException(baseResponse.message ?? "", statusCode);
      }
    } on DioError catch (ex) {
      var baseResponse = baseResponseFromJson(ex.response.toString());
      throw ClientErrorException(baseResponse.message ?? "Gagal Membuat User, username tidak boleh ada yang sama", 500);
    } catch (e) {
      throw Exception(e);
    }
  }

}
