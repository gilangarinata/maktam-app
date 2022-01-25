class MaterialParam {
  MaterialParam({
    this.date,
    this.notes,
    this.items,
  });

  MaterialParam copyWith({
    String? date,
    String? notes,
    List<MaterialItemParam?>? items,
  }) {
    return MaterialParam(
        date: date ?? this.date,
        notes: notes ?? this.notes,
        items: items ?? this.items);
  }

  String? date;
  String? notes;
  List<MaterialItemParam?>? items;

  Map<String, dynamic> toJson() => {
        "date": date,
        "notes": notes,
        "items": List<dynamic>.from((items ?? []).map((x) => x?.toJson())),
      };
}

class MaterialItemParam {
  MaterialItemParam({
    this.id,
    this.materialId,
    this.stock,
    this.added,
  });

  int? id;
  int? materialId;
  int? stock;
  int? added;

  Map<String, dynamic> toJson() => {
        "id": id,
        "materialId": materialId,
        "stock": stock,
        "added": added,
      };
}
