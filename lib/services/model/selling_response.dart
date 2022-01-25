class SellingResponse {
  SellingResponse({
    this.fund,
    this.expense,
    this.income,
    this.data,
  });

  int? fund;
  int? expense;
  int? income;
  List<SellingData>? data;

  factory SellingResponse.fromJson(Map<String, dynamic> json) =>
      SellingResponse(
        fund: json["fund"],
        expense: json["expense"],
        income: json["income"],
        data: List<SellingData>.from(
            json["items"].map((x) => SellingData.fromJson(x))),
      );
}

class SellingData {
  SellingData({
    this.id,
    this.date,
    this.shift,
    this.employee,
  });

  int? id;
  DateTime? date;
  int? shift;
  String? employee;

  factory SellingData.fromJson(Map<String, dynamic> json) => SellingData(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        shift: json["shift"],
        employee: json["employee"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date?.toIso8601String(),
        "shift": shift,
        "employee": employee,
      };
}
