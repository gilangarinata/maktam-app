class SellingParams {
  SellingParams({
    this.id,
    this.shift,
    this.grandTotal,
    this.date,
    this.fund,
    this.income,
    this.expense,
    this.note,
    this.data,
  });

  SellingParams copyWith({
    int? id,
    int? shift,
    int? grandTotal,
    String? date,
    int? fund,
    int? income,
    int? expense,
    String? note,
    List<ItemDataParam>? data,
  }) {
    return SellingParams(
        id: id ?? this.id,
        shift: shift ?? this.shift,
        grandTotal: grandTotal ?? this.grandTotal,
        date: date ?? this.date,
        fund: fund ?? this.fund,
        income: income ?? this.income,
        expense: expense ?? this.expense,
        note: note ?? this.note,
        data: data ?? this.data);
  }

  bool isCreateValidate() {
    return shift != null && date != null;
  }

  bool isUpdateValidate() {
    return shift != null && date != null && id != null;
  }

  int? id;
  int? shift;
  int? grandTotal;
  String? date;
  int? fund;
  int? income;
  int? expense;
  String? note;
  List<ItemDataParam>? data;

  Map<String, dynamic> toJson() => {
        "id": id,
        "shift": shift,
        "grandTotal": grandTotal ?? 0,
        "date": date,
        "fund": fund ?? 0,
        "income": income ?? 0,
        "expense": expense ?? 0,
        "note": note,
        "data": getData(),
      };

  List<dynamic> getData() {
    if (data != null) {
      return List<dynamic>.from(data!.map((x) => x.toJson()));
    } else {
      return List.empty();
    }
  }
}

class ItemDataParam {
  ItemDataParam(this.itemId, this.sold, this.price);

  int itemId;
  int sold;
  int price;

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "sold": sold,
      };
}
