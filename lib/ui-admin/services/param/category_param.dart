class CategoryParam {
  String? name;
  String? type;
  int? id;
  String? previousName;

  CategoryParam(this.name, this.type, this.id, this.previousName);

  bool isValid(){
    return name != null && type != null;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type' : type,
      'id' : id
    };
  }
}
