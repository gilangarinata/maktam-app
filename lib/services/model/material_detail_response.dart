class MaterialDetailResponse {
  MaterialDetailResponse({
    this.id,
    this.date,
    this.employee,
    this.notes,
    this.items,
  });

  int? id;
  DateTime? date;
  String? employee;
  String? notes;
  List<MaterialItemDetailResponse>? items;

  factory MaterialDetailResponse.fromJson(Map<String, dynamic> json) =>
      MaterialDetailResponse(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        employee: json["employee"],
        notes: json["notes"],
        items: List<MaterialItemDetailResponse>.from(
            json["items"].map((x) => MaterialItemDetailResponse.fromJson(x))),
      );
}

class MaterialItemDetailResponse {
  MaterialItemDetailResponse({
    this.id,
    this.materialId,
    this.name,
    this.stock,
    this.standard,
    this.added,
  });

  int? id;
  int? materialId;
  String? name;
  int? stock;
  int? standard;
  int? added;

  factory MaterialItemDetailResponse.fromJson(Map<String, dynamic> json) =>
      MaterialItemDetailResponse(
        id: json["id"],
        materialId: json["materialId"],
        name: json["name"],
        stock: json["stock"],
        standard: json["standard"],
        added: json["added"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "materialId": materialId,
        "name": name,
        "stock": stock,
        "standard": standard,
        "added": added,
      };
}
