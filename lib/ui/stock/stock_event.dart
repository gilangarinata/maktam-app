import 'package:equatable/equatable.dart';
import 'package:maktampos/services/param/stock_param.dart';

abstract class StockEvent extends Equatable {}

class GetStocks extends StockEvent {
  int page;

  GetStocks(this.page);

  @override
  List<Object> get props => [];
}

class GetCategoriesItems extends StockEvent {
  @override
  List<Object> get props => [];

  GetCategoriesItems();
}

class InsertStock extends StockEvent {
  StockParam stockParam;

  InsertStock(this.stockParam);

  @override
  List<Object> get props => [];
}

class UpdateStock extends StockEvent {
  StockParam stockParam;

  UpdateStock(this.stockParam);

  @override
  List<Object> get props => [];
}

class DeleteStock extends StockEvent {
  String date;

  DeleteStock(this.date);

  @override
  List<Object> get props => [];
}

class GetStockDetails extends StockEvent {
  String date;

  GetStockDetails(this.date);

  @override
  List<Object> get props => [];
}
