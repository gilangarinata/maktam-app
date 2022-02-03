import 'package:maktampos/services/param/selling_param.dart';

class SellingDetailResponse {
  SellingDetailResponse({
    this.id,
    this.date,
    this.shift,
    this.employee,
    this.notes,
    this.fund,
    this.expense,
    this.income,
    required this.items,
  });

  int? id;
  DateTime? date;
  int? shift;
  String? employee;
  String? notes;
  int? fund;
  int? expense;
  int? income;
  List<DataItem> items = <DataItem>[];

  factory SellingDetailResponse.fromJson(Map<String, dynamic> json) =>
      SellingDetailResponse(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        shift: json["shift"],
        employee: json["employee"],
        notes: json["notes"],
        fund: json["fund"],
        expense: json["expense"],
        income: json["income"],
        items:
            List<DataItem>.from(json["items"].map((x) => DataItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date?.toIso8601String(),
        "shift": shift,
        "employee": employee,
        "notes": notes,
        "fund": fund,
        "expense": expense,
        "income": income,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class DataItem {
  DataItem({
    this.id,
    this.itemId,
    this.sold,
    this.price,
  });

  int? id;
  int? itemId;
  int? sold;
  int? price;

  ItemDataParam toItemDataParam() {
    return ItemDataParam(
      itemId ?? -1,
      sold ?? -1,
      price ?? -1
    );
  }

  factory DataItem.fromJson(Map<String, dynamic> json) => DataItem(
        id: json["id"],
        itemId: json["itemId"],
        sold: json["sold"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemId": itemId,
        "sold": sold,
        "price": price,
      };
}
