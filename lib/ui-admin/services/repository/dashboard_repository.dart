import 'dart:async';

import 'package:dio/dio.dart';
import 'package:maktampos/ui-admin/res/var_constants.dart';
import 'package:maktampos/ui-admin/services/param/inventory_param.dart';
import 'package:maktampos/ui-admin/services/responses/base_response.dart';
import 'package:maktampos/ui-admin/services/responses/inventory_expense_response.dart';
import 'package:maktampos/ui-admin/services/responses/inventory_response.dart';
import 'package:maktampos/ui-admin/services/responses/login_response.dart';
import 'package:maktampos/ui-admin/services/responses/material_item_response.dart';
import 'package:maktampos/ui-admin/services/responses/material_response.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';
import 'package:maktampos/ui-admin/services/responses/selling_response.dart';
import 'package:maktampos/ui-admin/services/responses/stock_response.dart';
import 'package:maktampos/ui-admin/services/responses/summary_response.dart';
import 'package:maktampos/ui-admin/services/param/login_param.dart';
import 'package:collection/collection.dart';
import '../constant.dart';
import '../network_exception.dart';


abstract class DashboardRepository {
  Future<SummaryResponse?> getSummary(String date);
  Future<List<ProductItem>> getSellings(String date);
  Future<StockResponse> getStocks(String date);
  Future<List<MaterialItem>> getMaterials(String date);
  Future<List<MaterialItem>> getInventory(String date);
  Future<bool> updateInventory(InventoryParam param);

  Future<List<InventoryExpenseResponse>> getInventoryExpense(String date);
  Future<bool> addInventoryExpense(String location, int total, String date);
  Future<bool> deleteInventoryExpense(int id);
}

class DashboardRepositoryImpl extends DashboardRepository {
  final Dio _dioClient;
  final Dio _dioClient2;

  DashboardRepositoryImpl(this._dioClient,this._dioClient2);

  @override
  Future<SummaryResponse?> getSummary(String date) async {
    try {
      final response = await _dioClient.get(Constant.summary,
          queryParameters: {
            "date" : date
          },);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return SummaryResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      print("gilang" + statusMessage);
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

    /*
        First get the list of product in this func
        Then get Selling data in sellingData() method
     */
  @override
  Future<List<ProductItem>> getSellings(String date) async {
    try {
      final response = await _dioClient.get(Constant.products,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {

        var productResponse = ProductResponse.fromJson(response.data)
            .items
            ?.where((element) => element.type == Type.ITEM).toList();
        return await getSellingData(date, productResponse);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      print("gilang" + statusMessage);
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  /*
      First get the list of product on getSellings() method
      Then get Selling data in this method
   */
  Future<List<ProductItem>> getSellingData(String date, List<ProductItem>? productItems) async {
    try {
      final response = await _dioClient.get(Constant.selling,
        queryParameters: {
          "date" : date
        },);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var sellingResponse = SellingResponse.fromJson(response.data);
        productItems?.forEach((product) {
          var selling = sellingResponse.items?.firstWhereOrNull((selling) => selling.itemId == product.id);
          if(selling != null){
            product.sold = selling.sold;
          }else{
            product.sold == "0";
          }
        });

        return productItems ?? [];
      } else {
        print("get selling failed");
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

  /*
        First get the list of product in this func filter by TYPE = OUTLET_ITEM
        Then get stock data in getStockData() method
     */
  @override
  Future<StockResponse> getStocks(String date) async {
    try {
      final response = await _dioClient.get(Constant.products,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {

        var productResponse = ProductResponse.fromJson(response.data)
            .items
            ?.where((element) => element.type == Type.OUTLET_ITEM).toList();
        return await getStockData(date, productResponse);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      print("gilang" + statusMessage);
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<StockResponse> getStockData(String date, List<ProductItem>? productItems) async {
    try {
      final response = await _dioClient.get(Constant.stock,
        queryParameters: {
          "date" : date
        },);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var stockResponse = StockResponse.fromJson(response.data);
        var cupItems = productItems?.where((element) => element.categoryId == VarConstants.CATEGORY_ID_CUPS);
        var spicesItems = productItems?.where((element) => element.categoryId == VarConstants.CATEGORY_ID_SPICES);
        cupItems?.forEach((cupItem) {
          var stockItem = stockResponse.cups?.items?.firstWhereOrNull((element) => element.itemId == cupItem.id);
          cupItem.stock = int.tryParse(stockItem?.stock ?? "") ?? 0;
          cupItem.sold = stockItem?.sold;
          cupItem.left = int.tryParse(stockItem?.lefts ?? "") ?? 0;
        });

        spicesItems?.forEach((spicesItem) {
          var stockItem = stockResponse.spices?.items?.firstWhereOrNull((element) => element.itemId == spicesItem.id);
          spicesItem.stock = int.tryParse(stockItem?.stock ?? "") ?? 0;
          spicesItem.sold = stockItem?.sold;
          spicesItem.left = int.tryParse(stockItem?.lefts ?? "") ?? 0;
        });

        print("cup Items : ${productItems?.length}" );

        var newStockResponse = StockResponse(
          milk: stockResponse.milk,
          cups: Cups(
            url: stockResponse.cups?.url,
            items: cupItems?.map((e) => e.toCupItem()).toList()
          ),
          spices: Cups(
              url: stockResponse.spices?.url,
              items: spicesItems?.map((e) => e.toCupItem()).toList()
          ),
        );

        return newStockResponse;
      } else {
        print("get selling failed");
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
  Future<List<MaterialItem>> getMaterials(String date) async {
    try {
      final response = await _dioClient.get(Constant.materialItem,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var materialResponse = MaterialItemResponse.fromJson(response.data)
            .items;
        if(date.isEmpty){
          return materialResponse ?? [];
        }else{
          return await getMaterialData(date, materialResponse);
        }
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      print("gilang" + statusMessage);
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<MaterialItem>> getMaterialData(String date, List<MaterialItem>? materialItems) async {
    try {
      final response = await _dioClient.get(Constant.materialData,
        queryParameters: {
          "date" : date
        },);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var materialResponse = List<MaterialResponse>.from(response.data.map((e) => MaterialResponse.fromJson(e)));
        materialItems?.forEach((element) {
          var material = materialResponse.firstWhereOrNull((material) => material.materialId == element.id);
          element.stock = material?.stock;
          element.added = material?.added;
        });
        return materialItems ?? [];
      } else {
        print("get selling failed");
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
  Future<List<MaterialItem>> getInventory(String date) async {
    try {
      final response = await _dioClient.get(Constant.materialItem,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var materialResponse = MaterialItemResponse.fromJson(response.data)
            .items;
        return await getInventoryData(date, materialResponse);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      print("gilang" + statusMessage);
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<MaterialItem>> getInventoryData(String date, List<MaterialItem>? materialItems) async {
    try {
      final response = await _dioClient.get(Constant.inventory,
        queryParameters: {
          "date" : date
        },);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var inventoryResponse = InventoryResponse.fromJson(response.data);
        materialItems?.forEach((element) {
          var material = inventoryResponse.inventory?.firstWhereOrNull((material) => material.materialId == element.id);
          element.inventoryStock = material?.warehouseStock;
          element.takenByOutlets = material?.takenByOutlet;
          element.left = material?.leftOver;
        });
        return materialItems ?? [];
      } else {
        print("get selling failed");
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
  Future<bool> updateInventory(InventoryParam param) async {
    try {
      final response = await _dioClient.post(Constant.inventory,
      data: param.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var baseResponse = BaseResponse.fromJson(response.data);
        return baseResponse.success ?? false;
      } else {
        print("get selling failed");
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
  Future<List<InventoryExpenseResponse>> getInventoryExpense(String date) async {
    try {
      final response = await _dioClient2.get(Constant.inventoryExpense,queryParameters: {
        "date" : date
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var responses = List<InventoryExpenseResponse>.from(response.data.map((e) => InventoryExpenseResponse.fromJson(e)));
        return responses;
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      print("gilang" + statusMessage);
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> addInventoryExpense(String location, int total, String date) async {
    try {
      final response = await _dioClient2.post(Constant.inventoryExpense,
          data: {
        "name" : location,
            "total" : total,
            "date" : date
          });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return true;
      } else {
        print("get selling failed");
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
  Future<bool> deleteInventoryExpense(int id) async {
    try {
      final response = await _dioClient2.get(Constant.inventoryExpense,queryParameters: {
        "id" : id
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return true;
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      print("gilang" + statusMessage);
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }
}
