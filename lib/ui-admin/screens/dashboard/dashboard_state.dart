import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maktampos/ui-admin/services/responses/material_item_response.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';
import 'package:maktampos/ui-admin/services/responses/stock_response.dart';
import 'package:maktampos/ui-admin/services/responses/summary_response.dart';


class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends DashboardState {
  @override
  List<Object> get props => [];
}

class FailedState extends DashboardState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

/*
  Get summary Data
*/

class GetSummarySuccess extends DashboardState {
  final SummaryResponse? items;

  GetSummarySuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class GetSummaryLoading extends DashboardState {
  GetSummaryLoading();

  @override
  List<Object> get props => [];
}


/*
  Get selling Data
*/

class GetSellingSuccess extends DashboardState {
  final List<ProductItem> items;

  GetSellingSuccess({required this.items});

  @override
  List<Object?> get props => [items];
}

class GetSellingLoading extends DashboardState {
  GetSellingLoading();

  @override
  List<Object> get props => [];
}


/*
  Get stock Data
*/

class GetStockSuccess extends DashboardState {
  final StockResponse stockResponse;

  GetStockSuccess({required this.stockResponse});

  @override
  List<Object?> get props => [stockResponse];
}

class GetStockLoading extends DashboardState {
  GetStockLoading();

  @override
  List<Object> get props => [];
}



/*
  Get material Data
*/

class GetMaterialSuccess extends DashboardState {
  final List<MaterialItem> materialItems;

  GetMaterialSuccess({required this.materialItems});

  @override
  List<Object?> get props => [materialItems];
}

class GetMaterialLoading extends DashboardState {
  GetMaterialLoading();

  @override
  List<Object> get props => [];
}


/*
  Get inventory
*/

class GetInventorySuccess extends DashboardState {
  final List<MaterialItem> materialItems;

  GetInventorySuccess({required this.materialItems});

  @override
  List<Object?> get props => [materialItems];
}

class GetInventoryLoading extends DashboardState {
  GetInventoryLoading();

  @override
  List<Object> get props => [];
}

/*
  update inventory
*/

class UpdateInventorySuccess extends DashboardState {
  UpdateInventorySuccess();

  @override
  List<Object?> get props => [];
}

class UpdateInventoryLoading extends DashboardState {
  UpdateInventoryLoading();

  @override
  List<Object> get props => [];
}

