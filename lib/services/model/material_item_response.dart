import 'package:maktampos/services/param/material_param.dart';

class MaterialItemResponse {
  MaterialItemResponse({
    this.materials,
  });

  List<MaterialItem>? materials;

  factory MaterialItemResponse.fromJson(Map<String, dynamic> json) =>
      MaterialItemResponse(
        materials: List<MaterialItem>.from(
            json["materials"].map((x) => MaterialItem.fromJson(x))),
      );
}

class MaterialItem {
  MaterialItem({
    this.id,
    this.materialId,
    this.materialName,
    this.outletId,
    this.outletName,
    this.standard,
  });

  int? id;
  int? materialId;
  String? materialName;
  int? outletId;
  String? outletName;
  int? standard;
  int? detailId;
  int? stock;
  int? added;

  factory MaterialItem.fromJson(Map<String, dynamic> json) => MaterialItem(
        id: json["id"],
        materialId: json["materialId"],
        materialName: json["materialName"],
        outletId: json["outletId"],
        outletName: json["outletName"],
        standard: json["standard"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "materialId": materialId,
        "materialName": materialName,
        "outletId": outletId,
        "outletName": outletName,
        "standard": standard,
      };

  MaterialItemParam toMaterialItemParam() => MaterialItemParam(
      id: detailId, materialId: materialId, stock: stock, added: added);
}
