import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maktampos/services/model/base_response.dart';
import 'package:maktampos/services/model/material_detail_response.dart';
import 'package:maktampos/services/model/material_item_response.dart';
import 'package:maktampos/services/model/material_response.dart';

class MaterialsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends MaterialsState {
  @override
  List<Object> get props => [];
}

class FailedState extends MaterialsState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

/*
  Get material Data
*/

class GetMaterialsSuccess extends MaterialsState {
  final List<MaterialResponse>? items;

  GetMaterialsSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class GetMaterialLoading extends MaterialsState {
  GetMaterialLoading();

  @override
  List<Object> get props => [];
}

/*
  Get categories and items
*/

class GetMaterialItemSuccess extends MaterialsState {
  final List<MaterialItem>? items;

  GetMaterialItemSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class GetMaterialItemLoading extends MaterialsState {
  GetMaterialItemLoading();

  @override
  List<Object> get props => [];
}

/*
  cerate material
*/

class CreateUpdateMaterialSuccess extends MaterialsState {
  final BaseResponse? items;

  CreateUpdateMaterialSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class CreateUpdateMaterialLoading extends MaterialsState {
  CreateUpdateMaterialLoading();

  @override
  List<Object> get props => [];
}

/*
  delete material
*/

class DeleteMaterialSuccess extends MaterialsState {
  final BaseResponse? items;

  DeleteMaterialSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class DeleteMaterialLoading extends MaterialsState {
  DeleteMaterialLoading();

  @override
  List<Object> get props => [];
}

/*
  get material detail
*/

class GetMaterialDetailSuccess extends MaterialsState {
  final MaterialDetailResponse? items;

  GetMaterialDetailSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class GetMaterialDetailLoading extends MaterialsState {
  GetMaterialDetailLoading();

  @override
  List<Object> get props => [];
}
