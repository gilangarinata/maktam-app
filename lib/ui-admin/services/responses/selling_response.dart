// To parse this JSON data, do
//
//     final sellingResponse = sellingResponseFromJson(jsonString);

import 'dart:convert';

SellingResponse sellingResponseFromJson(String str) => SellingResponse.fromJson(json.decode(str));


class SellingResponse {
  SellingResponse({
    this.items,
  });

  List<Item>? items;

  factory SellingResponse.fromJson(Map<String, dynamic> json) => SellingResponse(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

}

class Item {
  Item({
    this.id,
    this.categoryId,
    this.sold,
    this.itemId,
  });

  int? id;
  int? categoryId;
  String? sold;
  int? itemId;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    categoryId: json["categoryId"],
    sold: json["sold"],
    itemId: json["itemId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryId": categoryId,
    "sold": sold,
    "itemId": itemId,
  };
}
