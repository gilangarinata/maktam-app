// To parse this JSON data, do
//
//     final materialItemResponse = materialItemResponseFromJson(jsonString);

import 'dart:convert';

MaterialItemResponse materialItemResponseFromJson(String str) => MaterialItemResponse.fromJson(json.decode(str));

class MaterialItemResponse {
  MaterialItemResponse({
    this.items,
  });

  List<MaterialItem>? items;

  factory MaterialItemResponse.fromJson(Map<String, dynamic> json) => MaterialItemResponse(
    items: List<MaterialItem>.from(json["items"].map((x) => MaterialItem.fromJson(x))),
  );

}

class MaterialItem {
  MaterialItem({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic? deletedAt;
  String? stock;
  String? added;

  int? inventoryStock;
  int? takenByOutlets;
  int? left;

  factory MaterialItem.fromJson(Map<String, dynamic> json) => MaterialItem(
    id: json["id"],
    name: json["name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );
}
