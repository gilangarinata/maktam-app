class OutletParam {
  String? name;
  String? address;
  int? id;

  OutletParam(this.name, this.address, this.id);

  bool isValid(){
    return name != null;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'id' : id
    };
  }
}
