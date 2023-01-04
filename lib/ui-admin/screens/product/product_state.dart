import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maktampos/ui-admin/services/responses/category_response.dart';
import 'package:maktampos/ui-admin/services/responses/subcategory_response.dart';
import 'package:maktampos/ui-admin/services/responses/material_item_response.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';
import 'package:maktampos/ui-admin/services/responses/stock_response.dart';
import 'package:maktampos/ui-admin/services/responses/summary_response.dart';


class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends ProductState {
  @override
  List<Object> get props => [];
}

class FailedState extends ProductState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

/*
  Get product Data
*/

class GetProductSuccess extends ProductState {
  final List<ProductItem>? items;

  GetProductSuccess({required this.items});

  @override
  List<Object?> get props => [items];
}

class GetProductLoading extends ProductState {
  GetProductLoading();

  @override
  List<Object> get props => [];
}


/*
  Get category Data
*/

class GetSubategoriesSuccess extends ProductState {
  final List<SubcategoryItem>? items;

  GetSubategoriesSuccess({required this.items});

  @override
  List<Object?> get props => [items];
}

class GetSubcategoryLoading extends ProductState {
  GetSubcategoryLoading();

  @override
  List<Object> get props => [];
}



/*
  create product Data
*/

class CreateProductSuccess extends ProductState {

  CreateProductSuccess();

  @override
  List<Object?> get props => [];
}

class CreateProductLoading extends ProductState {
  CreateProductLoading();

  @override
  List<Object> get props => [];
}


/*
  delete product Data
*/

class DeleteProductSuccess extends ProductState {

  DeleteProductSuccess();

  @override
  List<Object?> get props => [];
}

class DeleteProductLoading extends ProductState {
  DeleteProductLoading();

  @override
  List<Object> get props => [];
}


/*
  Get category Data
*/

class GetCategorySuccess extends ProductState {
  final List<CategoryItem>? items;

  GetCategorySuccess({required this.items});

  @override
  List<Object?> get props => [items];
}

class GetCategoryLoading extends ProductState {
  GetCategoryLoading();

  @override
  List<Object> get props => [];
}

/*
  create category Data
*/

class CreateCategorySuccess extends ProductState {

  CreateCategorySuccess();

  @override
  List<Object?> get props => [];
}

class CreateCategoryLoading extends ProductState {
  CreateCategoryLoading();

  @override
  List<Object> get props => [];
}


/*
  delete category Data
*/

class DeleteCategorySuccess extends ProductState {

  DeleteCategorySuccess();

  @override
  List<Object?> get props => [];
}

class DeleteCategoryLoading extends ProductState {
  DeleteCategoryLoading();

  @override
  List<Object> get props => [];
}

/*
  delete material Data
*/

class DeleteMaterialSuccess extends ProductState {

  DeleteMaterialSuccess();

  @override
  List<Object?> get props => [];
}

class DeleteMaterialLoading extends ProductState {
  DeleteMaterialLoading();

  @override
  List<Object> get props => [];
}

/*
  create material Data
*/

class CreateMaterialSuccess extends ProductState {

  CreateMaterialSuccess();

  @override
  List<Object?> get props => [];
}

class CreateMaterialLoading extends ProductState {
  CreateMaterialLoading();

  @override
  List<Object> get props => [];
}