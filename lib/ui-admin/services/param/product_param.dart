class ProductParam {
  String? name;
  int? subCategoryId;
  int? price;
  int? id;

  ProductParam(this.name, this.subCategoryId, this.price, this.id);

  bool isValid(){
    return name != null && subCategoryId != null && price != null && name?.isNotEmpty == true;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subCategoryId': subCategoryId,
      'price' : price,
      'id' : id
    };
  }
}
