import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:maktampos/services/constant.dart';
import 'package:maktampos/services/model/base_response.dart';
import 'package:maktampos/services/model/material_detail_response.dart';
import 'package:maktampos/services/model/material_item_response.dart';
import 'package:maktampos/services/model/material_response.dart';
import 'package:maktampos/services/network_exception.dart';
import 'package:maktampos/services/param/material_param.dart';

abstract class MaterialRepository {
  Future<List<MaterialResponse>?> getMaterials();

  Future<List<MaterialItem>?> getMaterialItems();

  Future<BaseResponse?> createMaterial(MaterialParam materialParam);

  Future<BaseResponse?> updateMaterial(MaterialParam materialParam);

  Future<MaterialDetailResponse?> getMaterialDetail(String date);

  Future<BaseResponse?> deleteMaterial(String date);
}

class MaterialRepositoryImpl extends MaterialRepository {
  final Dio _dioClient;

  MaterialRepositoryImpl(this._dioClient);

  @override
  Future<List<MaterialItem>?> getMaterialItems() async {
    try {
      final response = await _dioClient.get(Constant.materialItem,
          options: buildCacheOptions(
              const Duration(hours: Constant.cacheDurationHours),
              forceRefresh: true));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return MaterialItemResponse.fromJson(response.data).materials;
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
  Future<BaseResponse?> createMaterial(MaterialParam materialParam) async {
    try {
      final response = await _dioClient.post(Constant.material,
          data: materialParam.toJson(),
          options: buildCacheOptions(
              const Duration(hours: Constant.cacheDurationHours),
              forceRefresh: true));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return BaseResponse.fromJson(response.data);
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
  Future<MaterialDetailResponse?> getMaterialDetail(String date) async {
    try {
      final response = await _dioClient.get(Constant.material,
          queryParameters: {"date": date},
          options: buildCacheOptions(
              const Duration(hours: Constant.cacheDurationHours),
              forceRefresh: true));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        MaterialDetailResponse items =
            MaterialDetailResponse.fromJson(response.data);
        return items;
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
  Future<BaseResponse?> deleteMaterial(String date) async {
    try {
      final response = await _dioClient.delete(Constant.material,
          queryParameters: {"date": date},
          options: buildCacheOptions(
              const Duration(hours: Constant.cacheDurationHours),
              forceRefresh: true));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        BaseResponse items = BaseResponse.fromJson(response.data);
        return items;
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
  Future<List<MaterialResponse>?> getMaterials() async {
    try {
      final response = await _dioClient.get(Constant.material,
          options: buildCacheOptions(
              const Duration(hours: Constant.cacheDurationHours),
              forceRefresh: true));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return List<MaterialResponse>.from(
            response.data.map((x) => MaterialResponse.fromJson(x)));
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
  Future<BaseResponse?> updateMaterial(MaterialParam materialParam) async {
    try {
      final response = await _dioClient.put(Constant.material,
          data: materialParam.toJson(),
          options: buildCacheOptions(
              const Duration(hours: Constant.cacheDurationHours),
              forceRefresh: true));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        BaseResponse items = BaseResponse.fromJson(response.data);
        return items;
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
