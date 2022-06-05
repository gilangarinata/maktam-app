import 'dart:convert';

StockResponse stockResponseFromJson(String str) => StockResponse.fromJson(json.decode(str));

class StockResponse {
  StockResponse({
    this.milk,
    this.spices,
    this.cups,
  });

  Milk? milk;
  Cups? spices;
  Cups? cups;

  factory StockResponse.fromJson(Map<String, dynamic> json) => StockResponse(
    milk: Milk.fromJson(json["milk"]),
    spices: Cups.fromJson(json["spices"]),
    cups: Cups.fromJson(json["cups"]),
  );
}

class Cups {
  Cups({
    this.url,
    this.items,
  });

  String? url;
  List<CupsItem>? items;

  factory Cups.fromJson(Map<String, dynamic> json) => Cups(
    url: json["url"],
    items: List<CupsItem>.from(json["items"].map((x) => CupsItem.fromJson(x))),
  );
}

class CupsItem {
  CupsItem({
    this.id,
    this.stock,
    this.sold,
    this.lefts,
    this.itemId,
    this.name
  });

  int? id;
  String? stock;
  String? sold;
  String? lefts;
  int? itemId;
  String? name;

  factory CupsItem.fromJson(Map<String, dynamic> json) => CupsItem(
    id: json["id"],
    stock: json["stock"],
    sold: json["sold"],
    lefts: json["lefts"],
    itemId: json["itemId"],
  );
}

class Milk {
  Milk({
    this.url,
    this.items,
  });

  String? url;
  List<MilkItem>? items;

  factory Milk.fromJson(Map<String, dynamic> json) => Milk(
    url: json["url"],
    items: List<MilkItem>.from(json["items"].map((x) => MilkItem.fromJson(x))),
  );

}

class MilkItem {
  MilkItem({
    this.id,
    this.stock,
    this.itemId,
  });

  int? id;
  String? stock;
  int? itemId;

  factory MilkItem.fromJson(Map<String, dynamic> json) => MilkItem(
    id: json["id"],
    stock: json["stock"],
    itemId: json["itemId"],
  );

}
