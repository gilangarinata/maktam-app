// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

List<UserResponse> userResponseFromJson(String str) => List<UserResponse>.from(json.decode(str).map((x) => UserResponse.fromJson(x)));

String userResponseToJson(List<UserResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserResponse {
  UserResponse({
    this.id,
    this.name,
    this.username,
    this.phoneNumber,
    this.outletId,
    this.outletName,
    this.roleId,
    this.roleName,
    this.address,
  });

  int? id;
  String? name;
  String? username;
  int? phoneNumber;
  int? outletId;
  String? outletName;
  int? roleId;
  String? roleName;
  String? address;

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    phoneNumber: json["phone_number"],
    outletId: json["outletId"],
    outletName: json["outletName"],
    roleId: json["roleId"],
    roleName: json["roleName"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "phone_number": phoneNumber,
    "outletId": outletId,
    "outletName": outletName,
    "roleId": roleId,
    "roleName": roleName,
    "address": address,
  };
}
