import 'package:equatable/equatable.dart';
import 'package:maktampos/ui-admin/services/param/inventory_param.dart';

abstract class DasboardEvent extends Equatable {}

class GetSummary extends DasboardEvent {
  DateTime date;
  @override
  List<Object> get props => [];

  GetSummary(this.date);
}

class GetSelling extends DasboardEvent {
  DateTime date;
  @override
  List<Object> get props => [];

  GetSelling(this.date);
}

class GetStocks extends DasboardEvent {
  DateTime date;
  @override
  List<Object> get props => [];

  GetStocks(this.date);
}

class GetMaterials extends DasboardEvent {
  DateTime? date;
  @override
  List<Object> get props => [];

  GetMaterials(this.date);
}

class GetInventory extends DasboardEvent {
  DateTime date;
  @override
  List<Object> get props => [];

  GetInventory(this.date);
}

class UpdateInventory extends DasboardEvent {
  InventoryParam param;
  @override
  List<Object> get props => [];

  UpdateInventory(this.param);
}

class GetInventoryExpense extends DasboardEvent {
  DateTime date;
  @override
  List<Object> get props => [];

  GetInventoryExpense(this.date);
}

class AddInventoryExpense extends DasboardEvent {
  DateTime date;
   String location;
   int total;
  @override
  List<Object> get props => [];

  AddInventoryExpense(this.date,this.location, this.total);
}

class DeleteInventoryExpense extends DasboardEvent {
  int id;
  @override
  List<Object> get props => [];

  DeleteInventoryExpense(this.id);
}



