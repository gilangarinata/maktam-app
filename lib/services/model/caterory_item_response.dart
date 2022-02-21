class CategoryItemResponse {
  CategoryItemResponse({
    this.categoryName,
    this.categoryId,
    this.items,
  });

  String? categoryName;
  int? categoryId;
  List<Item>? items;

  factory CategoryItemResponse.fromJson(Map<String, dynamic> json) =>
      CategoryItemResponse(
        categoryName: json["categoryName"],
        categoryId: json["categoryId"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );
}

class Item {
  Item({
    this.itemId,
    this.itemName,
    this.price,
    this.standard
  });

  int? itemId;
  String? itemName;
  int? price;
  int? standard;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json["itemId"],
        itemName: json["itemName"],
        price: json["price"],
        standard: json["standard"],
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "itemName": itemName,
        "price" : price
      };
}
