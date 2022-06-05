import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maktampos/ui-admin/services/responses/category_response.dart';
import 'package:maktampos/ui-admin/services/responses/outlet_response.dart';
import 'package:maktampos/ui-admin/services/responses/subcategory_response.dart';
import 'package:maktampos/ui-admin/services/responses/material_item_response.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';
import 'package:maktampos/ui-admin/services/responses/stock_response.dart';
import 'package:maktampos/ui-admin/services/responses/summary_response.dart';
import 'package:maktampos/ui-admin/services/responses/user_response.dart';


class MaktamState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends MaktamState {
  @override
  List<Object> get props => [];
}

class FailedState extends MaktamState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

/*
  Get users
*/

class GetUserSuccess extends MaktamState {
  final List<UserResponse>? items;

  GetUserSuccess({required this.items});

  @override
  List<Object?> get props => [items];
}

class GetUserLoading extends MaktamState {
  GetUserLoading();

  @override
  List<Object> get props => [];
}

/*
  Create users
*/

class CreateUserSuccess extends MaktamState {

  CreateUserSuccess();

  @override
  List<Object?> get props => [];
}

class CreateUserLoading extends MaktamState {
  CreateUserLoading();

  @override
  List<Object> get props => [];
}


/*
  delete users
*/

class DeleteUserSuccess extends MaktamState {

  DeleteUserSuccess();

  @override
  List<Object?> get props => [];
}

class DeleteUserLoading extends MaktamState {
  DeleteUserLoading();

  @override
  List<Object> get props => [];
}

/*
  get outlets
*/

class GetOutletsSuccess extends MaktamState {

  final List<OutletItem>? items;


  GetOutletsSuccess(this.items);

  @override
  List<Object?> get props => [items];
}

class GetOutletLoading extends MaktamState {
  GetOutletLoading();

  @override
  List<Object> get props => [];
}


/*
  create outlets
*/

class CreateOutletsSuccess extends MaktamState {

  CreateOutletsSuccess();

  @override
  List<Object?> get props => [];
}

class CreateOutletLoading extends MaktamState {
  CreateOutletLoading();

  @override
  List<Object> get props => [];
}

/*
  delete outlets
*/

class DeleteOutletsSuccess extends MaktamState {


  DeleteOutletsSuccess();

  @override
  List<Object?> get props => [];
}

class DeleteOutletLoading extends MaktamState {
  DeleteOutletLoading();

  @override
  List<Object> get props => [];
}