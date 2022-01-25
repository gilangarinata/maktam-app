import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:maktampos/services/constant.dart';
import 'package:maktampos/services/model/base_response.dart';
import 'package:maktampos/services/model/caterory_item_response.dart';
import 'package:maktampos/services/model/selling_detail_response.dart';
import 'package:maktampos/services/model/selling_response.dart';
import 'package:maktampos/services/network_exception.dart';
import 'package:maktampos/services/param/selling_param.dart';

abstract class SellingRepository {
  Future<SellingResponse?> getAllData();

  Future<List<CategoryItemResponse>?> getItemsAndCategories();

  Future<BaseResponse> createSelling(SellingParams sellingParams);

  Future<SellingDetailResponse?> getSellingDetail(String date, int shift);

  Future<BaseResponse?> deleteSelling(String date, int shift);

  Future<BaseResponse?> updateSelling(SellingParams params);
}

class SellingRepositoryImpl extends SellingRepository {
  final Dio _dioClient;

  SellingRepositoryImpl(this._dioClient);

  @override
  Future<SellingResponse?> getAllData() async {
    try {
      final response = await _dioClient.get(Constant.selling,
          options: buildCacheOptions(
              const Duration(hours: Constant.cacheDurationHours),
              forceRefresh: true));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return SellingResponse.fromJson(response.data);
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
  Future<List<CategoryItemResponse>?> getItemsAndCategories() async {
    try {
      final response = await _dioClient.get(Constant.categoryItems,
          options: buildCacheOptions(
              const Duration(hours: Constant.cacheDurationHours),
              forceRefresh: true));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        List<CategoryItemResponse> items = List<CategoryItemResponse>.from(
            response.data.map((x) => CategoryItemResponse.fromJson(x)));
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
  Future<BaseResponse> createSelling(SellingParams sellingParams) async {
    try {
      final response = await _dioClient.post(Constant.selling,
          data: sellingParams.toJson(),
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
  Future<SellingDetailResponse?> getSellingDetail(
      String date, int shift) async {
    try {
      final response = await _dioClient.get(Constant.selling,
          queryParameters: {"date": date, "shift": shift},
          options: buildCacheOptions(
              const Duration(hours: Constant.cacheDurationHours),
              forceRefresh: true));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        SellingDetailResponse items =
            SellingDetailResponse.fromJson(response.data);
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
  Future<BaseResponse?> deleteSelling(String date, int shift) async {
    try {
      final response = await _dioClient.delete(Constant.selling,
          queryParameters: {"date": date, "shift": shift},
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
  Future<BaseResponse?> updateSelling(SellingParams params) async {
    try {
      final response = await _dioClient.put(Constant.selling,
          data: params.toJson(),
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
