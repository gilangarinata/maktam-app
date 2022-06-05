// To parse this JSON data, do
//
//     final inventoryResponse = inventoryResponseFromJson(jsonString);

import 'dart:convert';

InventoryResponse inventoryResponseFromJson(String str) => InventoryResponse.fromJson(json.decode(str));

class InventoryResponse {
  InventoryResponse({
    this.success,
    this.inventory,
  });

  bool? success;
  List<Inventory>? inventory;

  factory InventoryResponse.fromJson(Map<String, dynamic> json) => InventoryResponse(
    success: json["success"],
    inventory: List<Inventory>.from(json["inventory"].map((x) => Inventory.fromJson(x))),
  );

}

class Inventory {
  Inventory({
    this.materialId,
    this.materialName,
    this.warehouseStock,
    this.takenByOutlet,
    this.leftOver,
  });

  int? materialId;
  String? materialName;
  int? warehouseStock;
  int? takenByOutlet;
  int? leftOver;

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
    materialId: json["materialId"],
    materialName: json["materialName"],
    warehouseStock: json["warehouseStock"],
    takenByOutlet: json["takenByOutlet"],
    leftOver: json["leftOver"],
  );
}
