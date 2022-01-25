import 'package:equatable/equatable.dart';
import 'package:maktampos/services/param/selling_param.dart';

abstract class SellingEvent extends Equatable {}

class GetSelling extends SellingEvent {
  @override
  List<Object> get props => [];

  GetSelling();
}

class GetCategoriesItems extends SellingEvent {
  @override
  List<Object> get props => [];

  GetCategoriesItems();
}

class InsertSelling extends SellingEvent {
  SellingParams params;

  InsertSelling(this.params);

  @override
  List<Object> get props => [];
}

class GetSellingDetail extends SellingEvent {
  int shift;
  String date;

  GetSellingDetail(this.shift, this.date);

  @override
  List<Object> get props => [];
}

class DeleteSelling extends SellingEvent {
  int shift;
  String date;

  DeleteSelling(this.shift, this.date);

  @override
  List<Object> get props => [];
}

class UpdateSelling extends SellingEvent {
  SellingParams sellingParams;

  UpdateSelling(this.sellingParams);

  @override
  List<Object> get props => [];
}
