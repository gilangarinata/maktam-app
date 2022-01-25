class MaterialResponse {
  MaterialResponse({
    this.id,
    this.date,
    this.employee,
  });

  int? id;
  DateTime? date;
  String? employee;

  factory MaterialResponse.fromJson(Map<String, dynamic> json) =>
      MaterialResponse(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        employee: json["employee"],
      );
}
