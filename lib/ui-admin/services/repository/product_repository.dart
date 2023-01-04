import 'dart:async';

import 'package:dio/dio.dart';
import 'package:maktampos/ui-admin/res/var_constants.dart';
import 'package:maktampos/ui-admin/services/param/category_param.dart';
import 'package:maktampos/ui-admin/services/param/inventory_param.dart';
import 'package:maktampos/ui-admin/services/param/material_item_param.dart';
import 'package:maktampos/ui-admin/services/param/product_param.dart';
import 'package:maktampos/ui-admin/services/responses/base_response.dart';
import 'package:maktampos/ui-admin/services/responses/category_response.dart';
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
import '../constant.dart';
import '../network_exception.dart';


abstract class ProductRepository {
  Future<List<ProductItem>?> getProducts();
  Future<List<SubcategoryItem>?> getSubcategories();
  Future<bool> createProduct(ProductParam param);
  Future<bool> updateProduct(ProductParam param);
  Future<bool> deleteProduct(int id);

  //categories
  Future<List<CategoryItem>?> getCategories();
  Future<bool> createCategory(CategoryParam param);
  Future<bool> deleteCategory(int id);
  Future<bool> updateCategory(CategoryParam param);

  //cups
  Future<List<ProductItem>?> getCups();

  //spices
  Future<List<ProductItem>?> getSpices();

  //materials
  Future<bool> deleteMaterial(int id);
  Future<bool> updateMaterial(MaterialItemParam param);
  Future<bool> createMaterial(MaterialItemParam param);
}

class ProductRepositoryImpl extends ProductRepository {
  final Dio _dioClient;


  ProductRepositoryImpl(this._dioClient);

  @override
  Future<List<ProductItem>?> getProducts() async {
    try {
      final response = await _dioClient.get(Constant.products,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {

        var productResponse = ProductResponse.fromJson(response.data)
            .items
            ?.where((element) => element.type == Type.ITEM).toList();
        return productResponse;
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
  Future<List<SubcategoryItem>?> getSubcategories() async {
    try {
      final response = await _dioClient.get(Constant.subcategory,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var categoryResponse = SubcategoryResponse.fromJson(response.data).items?.where((element) => element.type == "item").toList();
        return categoryResponse;
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
  Future<bool> createProduct(ProductParam param) async {
    try {
      final response = await _dioClient.post(Constant.products,data: param.toMap());
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
  Future<bool> updateProduct(ProductParam param) async {
    try {
      final response = await _dioClient.put(Constant.products,data: param.toMap());
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
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await _dioClient.delete(Constant.products,queryParameters: {
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
  Future<List<CategoryItem>?> getCategories() async {
    try {
      final response = await _dioClient.get(Constant.category,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var categoryResponse = CategoryResponse.fromJson(response.data).items?.where((element) => element.type == "item").toList();
        return categoryResponse;
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
  Future<bool> createCategory(CategoryParam param) async {
    try {
      final response = await _dioClient.post(Constant.category,data: param.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        List<CategoryItem>? categories = await getCategories();
        var newCategory = categories?.firstWhereOrNull((element) => element.name == param.name && element.type == param.type);
        return await createSubCategory(param, newCategory);
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

  Future<bool> createSubCategory(CategoryParam param, CategoryItem? item) async {
    try {
      var subCategoryParam = {
        "categoryId" : item?.id,
        "name" : param.name,
        "type" : param.type
      };
      final response = await _dioClient.post(Constant.subcategory,data: subCategoryParam);
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
  Future<bool> deleteCategory(int id) async {
    try {
      final response = await _dioClient.delete(Constant.category,queryParameters: {
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
  Future<bool> updateCategory(CategoryParam param) async {
    try {
      final response = await _dioClient.put(Constant.category,data: param.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        List<SubcategoryItem>? subcategories = await getSubcategories();
        var subcategoryShouldEdit = subcategories?.firstWhereOrNull((element) => element.subCategoryName == param.previousName);
        return await updateSubCategory(param, subcategoryShouldEdit);
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

  Future<bool> updateSubCategory(CategoryParam param, SubcategoryItem? item) async {
    try {
      var subCategoryParam = {
        "name" : param.name,
        "id" : item?.id
      };
      final response = await _dioClient.put(Constant.subcategory,data: subCategoryParam);
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
  Future<List<ProductItem>?> getCups() async {
    try {
      final response = await _dioClient.get(Constant.products,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var productResponse = ProductResponse.fromJson(response.data)
            .items
            ?.where((element) => element.type == Type.OUTLET_ITEM && element.categoryId == VarConstants.CATEGORY_ID_CUPS).toList();
        return productResponse;
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
  Future<List<ProductItem>?> getSpices() async{
    try {
      final response = await _dioClient.get(Constant.products,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var productResponse = ProductResponse.fromJson(response.data)
            .items
            ?.where((element) => element.type == Type.OUTLET_ITEM && element.categoryId == VarConstants.CATEGORY_ID_SPICES).toList();
        return productResponse;
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
  Future<bool> createMaterial(MaterialItemParam param) async {
    try {
      final response = await _dioClient.post(Constant.materialItem,data: param.toMap());
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
  Future<bool> deleteMaterial(int id) async {
    try {
      final response = await _dioClient.delete(Constant.materialItem,queryParameters: {
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
  Future<bool> updateMaterial(MaterialItemParam param) async {
    try {
      final response = await _dioClient.put(Constant.materialItem,data: param.toMap());
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
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

}
