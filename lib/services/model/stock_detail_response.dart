import 'package:maktampos/services/param/stock_param.dart';

class StockDetailResponse {
  StockDetailResponse({
    this.date,
    this.notes,
    this.milk,
    this.milkPlace,
    this.spices,
    this.cups,
  });

  DateTime? date;
  String? notes;
  List<Milk>? milk;
  List<MilkPlace>? milkPlace;
  List<Cup>? spices;
  List<Cup>? cups;

  factory StockDetailResponse.fromJson(Map<String, dynamic> json) =>
      StockDetailResponse(
        date: DateTime.parse(json["date"]),
        notes: json["notes"],
        milk: List<Milk>.from(json["milk"].map((x) => Milk.fromJson(x))),
        milkPlace: List<MilkPlace>.from(
            json["milkPlace"].map((x) => MilkPlace.fromJson(x))),
        spices: List<Cup>.from(json["spices"].map((x) => Cup.fromJson(x))),
        cups: List<Cup>.from(json["cups"].map((x) => Cup.fromJson(x))),
      );
}

class Cup {
  Cup({
    this.id,
    this.itemId,
    this.stock,
    this.sold,
    this.lefts,
  });

  int? id;
  int? itemId;
  int? stock;
  int? sold;
  int? lefts;

  SpicesOrCupParam toSpicesOrCupParam(){
    return SpicesOrCupParam(
        id :id ?? -1,
        stock: stock ?? -1,
        itemId: itemId ?? -1,
        sold: sold ?? -1
    );
  }

  factory Cup.fromJson(Map<String, dynamic> json) => Cup(
        id: json["id"],
        itemId: json["itemId"],
        stock: json["stock"],
        sold: json["sold"],
        lefts: json["lefts"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemId": itemId,
        "stock": stock,
        "sold": sold,
        "lefts": lefts,
      };
}

class Milk {
  Milk({
    this.id,
    this.stock,
    this.itemId,
  });

  int? id;
  int? stock;
  int? itemId;

  MilkParam toMilkParam(){
    return MilkParam(
      id :id ?? -1,
      stock: stock ?? -1,
      itemId: itemId ?? -1
    );
  }

  factory Milk.fromJson(Map<String, dynamic> json) => Milk(
        id: json["id"],
        stock: json["stock"],
        itemId: json["itemId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stock": stock,
        "itemId": itemId,
      };
}

class MilkPlace {
  MilkPlace({
    this.id,
    this.place,
    this.stock,
    this.type,
    this.createdAt,
  });

  int? id;
  String? place;
  int? stock;
  String? type;
  DateTime? createdAt;

  MilkPlaceParam toParam() {
    return MilkPlaceParam(
        id: this.id, place: this.place, stock: this.stock, type: this.type);
  }

  factory MilkPlace.fromJson(Map<String, dynamic> json) => MilkPlace(
        id: json["id"],
        place: json["place"],
        stock: json["stock"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}
