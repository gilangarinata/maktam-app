import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maktampos/services/model/base_response.dart';
import 'package:maktampos/services/model/caterory_item_response.dart';
import 'package:maktampos/services/model/selling_detail_response.dart';
import 'package:maktampos/services/model/selling_response.dart';

class SellingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends SellingState {
  @override
  List<Object> get props => [];
}

class FailedState extends SellingState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

/*
  Get selling Data
*/

class GetSellingSuccess extends SellingState {
  final SellingResponse? items;

  GetSellingSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class GetSellingLoading extends SellingState {
  GetSellingLoading();

  @override
  List<Object> get props => [];
}

/*
  Get categories and items
*/

class GetCategoriesItemSuccess extends SellingState {
  final List<CategoryItemResponse>? items;

  GetCategoriesItemSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class GetCategoriesItemLoading extends SellingState {
  GetCategoriesItemLoading();

  @override
  List<Object> get props => [];
}

/*
  cerate selling
*/

class CreateUpdateSellingSuccess extends SellingState {
  final BaseResponse? items;

  CreateUpdateSellingSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class CreateUpdateSellingLoading extends SellingState {
  CreateUpdateSellingLoading();

  @override
  List<Object> get props => [];
}

/*
  detail selling
*/

class GetDetailSellingSuccess extends SellingState {
  final SellingDetailResponse? items;

  GetDetailSellingSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class GetDetailSellingLoading extends SellingState {
  GetDetailSellingLoading();

  @override
  List<Object> get props => [];
}

/*
  delete selling
*/

class DeleteSellingSuccess extends SellingState {
  final BaseResponse? items;

  DeleteSellingSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class DeleteSellingLoading extends SellingState {
  DeleteSellingLoading();

  @override
  List<Object> get props => [];
}
