import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:maktampos/services/constant.dart';
import 'package:maktampos/services/model/base_response.dart';
import 'package:maktampos/services/model/caterory_item_response.dart';
import 'package:maktampos/services/model/stock_detail_response.dart';
import 'package:maktampos/services/model/stock_response.dart';
import 'package:maktampos/services/network_exception.dart';
import 'package:maktampos/services/param/stock_param.dart';

abstract class StockRepository {
  Future<StockResponse?> getStocks(int page);

  Future<List<CategoryItemResponse>?> getItemsAndCategories();

  Future<BaseResponse?> createStock(StockParam stockParam);

  Future<BaseResponse?> updateStock(StockParam stockParam);

  Future<StockDetailResponse?> getStockDetail(String date);

  Future<BaseResponse?> deleteStock(String date);
}

class StockRepositoryImpl extends StockRepository {
  final Dio _dioClient;

  StockRepositoryImpl(this._dioClient);

  @override
  Future<StockResponse?> getStocks(int page) async {
    try {
      final response = await _dioClient.get(Constant.stock,
          queryParameters: {"page": page},
          options: buildCacheOptions(
              const Duration(hours: Constant.cacheDurationHours),
              forceRefresh: true));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return StockResponse.fromJson(response.data);
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
      final response = await _dioClient.get(Constant.categoryOutletItems,
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
  Future<BaseResponse?> createStock(StockParam stockParam) async {
    try {
      final response = await _dioClient.post(Constant.stock,
          data: stockParam.toJson(),
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
  Future<BaseResponse?> updateStock(StockParam stockParam) async {
    try {
      final response = await _dioClient.put(Constant.stock,
          data: stockParam.toJson(),
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
  Future<StockDetailResponse?> getStockDetail(String date) async {
    try {
      final response = await _dioClient.get(Constant.stock,
          queryParameters: {"date": date},
          options: buildCacheOptions(
              const Duration(hours: Constant.cacheDurationHours),
              forceRefresh: true));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        StockDetailResponse items = StockDetailResponse.fromJson(response.data);
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
  Future<BaseResponse?> deleteStock(String date) async {
    try {
      final response = await _dioClient.delete(Constant.stock,
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
}
