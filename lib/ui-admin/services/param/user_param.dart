class UserParam {
  String? username;
  String? password;
  int? outletId;
  int? roleId;
  String? name;
  String? phoneNumber;
  String? address;
  int? id;


  UserParam(this.username, this.password, this.outletId, this.roleId,
      this.name, this.phoneNumber, this.address, this.id);

  String? validateError(){
    if(username == null || username?.isEmpty == true){
      return "Username tidak boleh kosong";
    }

    if(id == null){
      if(password == null || password?.isEmpty == true){
        return "Password tidak boleh kosong";
      }
    }

    if(outletId == null){
      return "Pilih outlet terlebih dahulu";
    }
    if(roleId == null){
      return "Pilih jabatan terlebih dahulu";
    }
    if(name == null || name?.isEmpty == true){
      return "Nama tidak boleh kosong";
    }
    if(phoneNumber == null || phoneNumber?.isEmpty == true){
      return "Nomor tidak boleh kosong";
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "password": password,
      "outletId": outletId,
      "roleId": roleId,
      "name": name,
      "phoneNumber": phoneNumber,
      "address": address
    };
  }
}
