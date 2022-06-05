import 'package:equatable/equatable.dart';
import 'package:maktampos/ui-admin/services/param/category_param.dart';
import 'package:maktampos/ui-admin/services/param/inventory_param.dart';
import 'package:maktampos/ui-admin/services/param/outlet_param.dart';
import 'package:maktampos/ui-admin/services/param/product_param.dart';
import 'package:maktampos/ui-admin/services/param/user_param.dart';

abstract class MaktamEvent extends Equatable {}

class GetUsers extends MaktamEvent {
  @override
  List<Object> get props => [];

  GetUsers();
}

class CreateUsers extends MaktamEvent {
  UserParam param;

  @override
  List<Object> get props => [];

  CreateUsers(this.param);
}

class UpdateUsers extends MaktamEvent {
  UserParam param;

  @override
  List<Object> get props => [];

  UpdateUsers(this.param);
}

class DeleteUser extends MaktamEvent {
  int id;

  @override
  List<Object> get props => [];

  DeleteUser(this.id);
}

class GetOutlets extends MaktamEvent {
  @override
  List<Object> get props => [];

  GetOutlets();
}

class CreateOutlet extends MaktamEvent {
  final OutletParam param;
  @override
  List<Object> get props => [];

  CreateOutlet(this.param);
}

class UpdateOutlet extends MaktamEvent {
  final OutletParam param;
  @override
  List<Object> get props => [];

  UpdateOutlet(this.param);
}

class DeleteOutlet extends MaktamEvent {
  final int id;
  @override
  List<Object> get props => [];

  DeleteOutlet(this.id);
}

