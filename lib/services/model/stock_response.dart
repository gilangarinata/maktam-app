class StockResponse {
  StockResponse({
    this.items,
  });

  Items? items;

  factory StockResponse.fromJson(Map<String, dynamic> json) => StockResponse(
        items: Items.fromJson(json["items"]),
      );
}

class Items {
  Items({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<StockData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        currentPage: json["current_page"],
        data: List<StockData>.from(
            json["data"].map((x) => StockData.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );
}

class StockData {
  StockData({
    this.id,
    this.name,
    this.createdAt,
  });

  int? id;
  String? name;
  DateTime? createdAt;

  factory StockData.fromJson(Map<String, dynamic> json) => StockData(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}
