// To parse this JSON data, do
//
//     final categoryResponse = categoryResponseFromJson(jsonString);

import 'dart:convert';

SubcategoryResponse categoryResponseFromJson(String str) => SubcategoryResponse.fromJson(json.decode(str));

class SubcategoryResponse {
  SubcategoryResponse({
    this.items,
  });

  List<SubcategoryItem>? items;

  factory SubcategoryResponse.fromJson(Map<String, dynamic> json) => SubcategoryResponse(
    items: List<SubcategoryItem>.from(json["items"].map((x) => SubcategoryItem.fromJson(x))),
  );

}

class SubcategoryItem {
  SubcategoryItem({
    this.id,
    this.categoryName,
    this.subCategoryName,
    this.type,
  });

  int? id;
  String? categoryName;
  String? subCategoryName;
  String? type;

  factory SubcategoryItem.fromJson(Map<String, dynamic> json) => SubcategoryItem(
    id: json["id"],
    categoryName: json["categoryName"],
    subCategoryName: json["subCategoryName"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryName": categoryName,
    "subCategoryName": subCategoryName,
    "type": type,
  };
}
