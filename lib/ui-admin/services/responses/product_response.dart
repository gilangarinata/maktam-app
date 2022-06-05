// To parse this JSON data, do
//
//     final productResponse = productResponseFromJson(jsonString);

import 'dart:convert';

import 'package:maktampos/ui-admin/services/responses/stock_response.dart';

ProductResponse productResponseFromJson(String str) => ProductResponse.fromJson(json.decode(str));


class ProductResponse {
  ProductResponse({
    this.items,
  });

  List<ProductItem>? items;

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
    items: List<ProductItem>.from(json["items"].map((x) => ProductItem.fromJson(x))),
  );

}

class ProductItem {
  ProductItem({
    this.id,
    this.name,
    this.categoryId,
    this.categoryName,
    this.subcategoryId,
    this.subcategoryName,
    this.type,
    this.price,
    this.sold
  });

  int? id;
  String? name;
  int? categoryId;
  String? categoryName;
  int? subcategoryId;
  String? subcategoryName;
  Type? type;
  int? price;
  String? sold;
  int? left;
  int? stock;

  CupsItem toCupItem(){
    return CupsItem(
      stock: stock.toString(),
      sold: sold,
      lefts: left.toString(),
      itemId: id,
      name : name
    );
  }

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
    id: json["id"],
    name: json["name"],
    categoryId: json["categoryId"],
    categoryName: json["categoryName"],
    subcategoryId: json["subcategoryId"],
    subcategoryName: json["subcategoryName"],
    type: typeValues.map![json["type"]],
    price: json["price"],
  );


}

enum Type { ITEM, OUTLET_ITEM }

final typeValues = EnumValues({
  "item": Type.ITEM,
  "outlet_item": Type.OUTLET_ITEM
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map?.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
