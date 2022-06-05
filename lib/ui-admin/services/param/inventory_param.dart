class InventoryParam {
  int? materialId;
  String date;
  int warehouseStock;

  InventoryParam(this.materialId, this.date, this.warehouseStock);

  Map<String, dynamic> toMap() {
    return {
      'materialId': materialId,
      'date': date,
      'warehouseStock' : warehouseStock
    };
  }
}
