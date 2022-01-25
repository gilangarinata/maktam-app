import 'package:equatable/equatable.dart';
import 'package:maktampos/services/param/material_param.dart';

abstract class MaterialEvent extends Equatable {}

class GetMaterial extends MaterialEvent {
  GetMaterial();

  @override
  List<Object> get props => [];
}

class GetMaterialItems extends MaterialEvent {
  @override
  List<Object> get props => [];

  GetMaterialItems();
}

class InsertMaterial extends MaterialEvent {
  MaterialParam materialParam;

  InsertMaterial(this.materialParam);

  @override
  List<Object> get props => [];
}

class UpdateMaterial extends MaterialEvent {
  MaterialParam materialParam;

  UpdateMaterial(this.materialParam);

  @override
  List<Object> get props => [];
}

class DeleteMaterial extends MaterialEvent {
  String date;

  DeleteMaterial(this.date);

  @override
  List<Object> get props => [];
}

class GetMaterialDetails extends MaterialEvent {
  String date;

  GetMaterialDetails(this.date);

  @override
  List<Object> get props => [];
}
