import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maktampos/services/model/base_response.dart';
import 'package:maktampos/services/model/caterory_item_response.dart';
import 'package:maktampos/services/model/stock_detail_response.dart';
import 'package:maktampos/services/model/stock_response.dart';

class StockState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends StockState {
  @override
  List<Object> get props => [];
}

class FailedState extends StockState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

/*
  Get stock Data
*/

class GetStockSuccess extends StockState {
  final StockResponse? items;

  GetStockSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class GetStockLoading extends StockState {
  GetStockLoading();

  @override
  List<Object> get props => [];
}

/*
  Get categories and items
*/

class GetCategoriesItemSuccess extends StockState {
  final List<CategoryItemResponse>? items;

  GetCategoriesItemSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class GetCategoriesItemLoading extends StockState {
  GetCategoriesItemLoading();

  @override
  List<Object> get props => [];
}

/*
  cerate stock
*/

class CreateUpdateStockSuccess extends StockState {
  final BaseResponse? items;

  CreateUpdateStockSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class CreateUpdateStockLoading extends StockState {
  CreateUpdateStockLoading();

  @override
  List<Object> get props => [];
}

/*
  delete stock
*/

class DeleteStockSuccess extends StockState {
  final BaseResponse? items;

  DeleteStockSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class DeleteStockLoading extends StockState {
  DeleteStockLoading();

  @override
  List<Object> get props => [];
}

/*
  get stock detail
*/

class GetStockDetailSuccess extends StockState {
  final StockDetailResponse? items;

  GetStockDetailSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class GetStockDetailLoading extends StockState {
  GetStockDetailLoading();

  @override
  List<Object> get props => [];
}
