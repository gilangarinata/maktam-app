// To parse this JSON data, do
//
//     final outletResponse = outletResponseFromJson(jsonString);

import 'dart:convert';

OutletResponse outletResponseFromJson(String str) => OutletResponse.fromJson(json.decode(str));

class OutletResponse {
  OutletResponse({
    this.items,
  });

  List<OutletItem>? items;

  factory OutletResponse.fromJson(Map<String, dynamic> json) => OutletResponse(
    items: List<OutletItem>.from(json["items"].map((x) => OutletItem.fromJson(x))),
  );

}

class OutletItem {
  OutletItem({
    this.id,
    this.name,
    this.address,
  });

  int? id;
  String? name;
  String? address;

  factory OutletItem.fromJson(Map<String, dynamic> json) => OutletItem(
    id: json["id"],
    name: json["name"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
  };
}
