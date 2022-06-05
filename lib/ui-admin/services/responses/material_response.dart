
import 'dart:convert';

List<MaterialResponse> materialResponseFromJson(String str) => List<MaterialResponse>.from(json.decode(str).map((x) => MaterialResponse.fromJson(x)));

String materialResponseToJson(List<MaterialResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MaterialResponse {
  MaterialResponse({
    this.id,
    this.materialId,
    this.name,
    this.stock,
    this.added,
  });

  int? id;
  int? materialId;
  String? name;
  String? stock;
  String? added;

  factory MaterialResponse.fromJson(Map<String, dynamic> json) => MaterialResponse(
    id: json["id"],
    materialId: json["materialId"],
    name: json["name"],
    stock: json["stock"],
    added: json["added"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "materialId": materialId,
    "name": name,
    "stock": stock,
    "added": added,
  };
}
