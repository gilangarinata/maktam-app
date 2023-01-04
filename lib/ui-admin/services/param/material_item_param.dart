class MaterialItemParam {
  String? name;
  int? id;

  MaterialItemParam(this.name,this.id);

  bool isValid(){
    return name != null;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id' : id
    };
  }
}
