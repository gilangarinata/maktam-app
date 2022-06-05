// To parse this JSON data, do
//
//     final categoryResponse = categoryResponseFromJson(jsonString);

import 'dart:convert';

CategoryResponse categoryResponseFromJson(String str) => CategoryResponse.fromJson(json.decode(str));

class CategoryResponse {
  CategoryResponse({
    this.items,
  });

  List<CategoryItem>? items;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) => CategoryResponse(
    items: List<CategoryItem>.from(json["items"].map((x) => CategoryItem.fromJson(x))),
  );

}

class CategoryItem {
  CategoryItem({
    this.id,
    this.name,
    this.type,
  });

  int? id;
  String? name;
  String? type;

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
    id: json["id"],
    name: json["name"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
  };
}
