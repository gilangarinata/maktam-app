// To parse this JSON data, do
//
//     final inventoryExpenseResponse = inventoryExpenseResponseFromJson(jsonString);

import 'dart:convert';

List<InventoryExpenseResponse> inventoryExpenseResponseFromJson(String str) => List<InventoryExpenseResponse>.from(json.decode(str).map((x) => InventoryExpenseResponse.fromJson(x)));

class InventoryExpenseResponse {
  InventoryExpenseResponse({
    this.id,
    this.name,
    this.total,
    this.date,
  });

  String? id;
  String? name;
  String? total;
  DateTime? date;

  factory InventoryExpenseResponse.fromJson(Map<String, dynamic> json) => InventoryExpenseResponse(
    id: json["id"],
    name: json["name"],
    total: json["total"],
    date: DateTime.parse(json["date"]),
  );

}
