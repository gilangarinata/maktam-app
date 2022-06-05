class StockParam {
  StockParam({
    this.date,
    this.notes,
    this.milk,
    this.milkPlace,
    this.spices,
    this.cup,
  });

  StockParam copyWith({
    String? date,
    String? notes,
    List<MilkParam>? milk,
    List<MilkPlaceParam>? milkPlace,
    List<SpicesOrCupParam>? spices,
    List<SpicesOrCupParam>? cup,
  }) {
    return StockParam(
        date: date ?? this.date,
        notes: notes ?? this.notes,
        milk: milk ?? this.milk,
        milkPlace: milkPlace ?? this.milkPlace,
        spices: spices ?? this.spices,
        cup: cup ?? this.cup);
  }

  String? date;
  String? notes;
  List<MilkParam>? milk;
  List<MilkPlaceParam>? milkPlace;
  List<SpicesOrCupParam>? spices;
  List<SpicesOrCupParam>? cup;

  bool isValid() {
    return date != null;
  }

  Map<String, dynamic> toJson() => {
        "date": date,
        "notes": notes,
        "milk": List<dynamic>.from((milk ?? []).map((x) => x.toJson())),
        "milkPlace":
            List<dynamic>.from((milkPlace ?? []).map((x) => x.toJson())),
        "spices": List<dynamic>.from((spices ?? []).map((x) => x.toJson())),
        "cup": List<dynamic>.from((cup ?? []).map((x) => x.toJson())),
      };
}

class SpicesOrCupParam {
  SpicesOrCupParam({
    this.id,
    this.itemId,
    this.stock,
    this.sold,
  });

  int? id;
  int? itemId;
  int? stock;
  int? sold;

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemId": itemId,
        "stock": stock,
        "sold": sold,
      };
}

class MilkParam {
  MilkParam({
    this.id,
    this.itemId,
    this.stock,
    this.standard
  });

  int? id;
  int? itemId;
  int? stock;
  int? standard;

  factory MilkParam.fromJson(Map<String, dynamic> json) => MilkParam(
        itemId: json["itemId"],
        stock: json["stock"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemId": itemId,
        "stock": stock,
      };
}

class MilkPlaceParam {
  MilkPlaceParam({
    this.id,
    this.place,
    this.stock,
    this.type,
  });

  int? id;
  String? place;
  int? stock;
  String? type;

  Map<String, dynamic> toJson() => {
        "id": id,
        "place": place,
        "stock": stock,
        "type": type,
      };
}
