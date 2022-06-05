import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/ui-admin/components/progress_loading.dart';
import 'package:maktampos/ui-admin/extensions.dart';
import 'package:maktampos/ui-admin/res/my_colors.dart';
import 'package:maktampos/ui-admin/screens/maktam_bloc.dart';
import 'package:maktampos/ui-admin/screens/maktam_event.dart';
import 'package:maktampos/ui-admin/screens/maktam_state.dart';
import 'package:maktampos/ui-admin/services/param/user_param.dart';
import 'package:maktampos/ui-admin/services/responses/outlet_response.dart';
import 'package:maktampos/ui-admin/services/responses/subcategory_response.dart';
import 'package:maktampos/ui-admin/services/responses/user_response.dart';
import 'package:maktampos/ui-admin/utils/my_snackbar.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:collection/collection.dart';


import '../../../constants.dart';


class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({Key? key, this.userItem, required this.outletItems}) : super(key: key);

  final UserResponse? userItem;
  final List<OutletItem> outletItems;

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {

  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _outletController;

  bool _createUserLoading = false;
  bool _deleteUserLoading = false;

  bool? usernameIsValid;
  bool? passwordIsValid;
  bool? nameIsValid;
  bool? addressIsValid;
  bool? phoneIsValid;

  OutletItem? selectedOutlet;

  late MaktamBloc bloc;

  @override
  void initState() {
    super.initState();
    selectedOutlet = widget.outletItems.firstWhereOrNull((element) => element.id == widget.userItem?.outletId);
    _usernameController = TextEditingController(text: widget.userItem?.username);
    _passwordController = TextEditingController();
    _nameController = TextEditingController(text: widget.userItem?.name);
    _addressController = TextEditingController(text: widget.userItem?.address);
    _phoneController = TextEditingController(text: widget.userItem?.phoneNumber?.toString());
    _outletController = TextEditingController(text: selectedOutlet?.name);
    bloc = BlocProvider.of<MaktamBloc>(context);
  }

  void blocListener(BuildContext context, MaktamState state) async {
    if (state is CreateUserLoading) {
      setState(() {
        _createUserLoading = true;
      });
    }else if (state is DeleteUserLoading) {
      setState(() {
        _deleteUserLoading = true;
      });
    } else if (state is CreateUserSuccess) {
      /*
        create user
       */
      setState(() {
        _createUserLoading = false;
      });
      Navigator.pop(context, 200);
    }else if (state is DeleteUserSuccess) {
      /*
        deleteUser user
       */
      setState(() {
        _deleteUserLoading = false;
      });
      Navigator.pop(context, 200);
    }   else if (state is InitialState) {
      setState(() {
        _createUserLoading = false;
      });
    } else if (state is FailedState) {
      Navigator.of(context).pop();
      setState(() {
        _createUserLoading = false;
      });
      if (state.code == 401) {
        MySnackbar(context)
            .errorSnackbar("Sesi anda habis, silahkan login ulang");
        // ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
        return;
      }
      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var outletDialog = AlertDialog(
        title: Text("Pilih outlet"),
        content: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.outletItems.map((e) => RadioListTile(
                title: Text(e.name ?? ""),
                value: e,
                groupValue: selectedOutlet,
                selected: selectedOutlet == e,
                onChanged: (value) {
                  if (value != selectedOutlet) {
                    setState(() {
                      selectedOutlet = value as OutletItem;
                    });
                    _outletController.text = selectedOutlet?.name ?? "";
                    Navigator.of(context).pop();
                  }
                },
              ))
                  .toList(),
            ),
          ),
        ));
    return BlocListener<MaktamBloc, MaktamState>(
      listener: blocListener,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Tambah Pengguna",
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyColors.grey_80,
                        fontSize: 16
                    ),
                  ),
                ),
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.close))
              ],
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _usernameController,
              onChanged: (value) {
                setState(() {
                  usernameIsValid = value.isNotEmpty;
                });
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Username",
                filled: true,
                errorText: usernameIsValid == false ? "Tidak Boleh Kosong" : null,
                fillColor: Colors.transparent,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // borderSide: BorderSide.,
                ),
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _passwordController,
              onChanged: (value) {
                setState(() {
                  passwordIsValid = value.isNotEmpty;
                });
              },
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                errorText: passwordIsValid == false ? "Tidak Boleh Kosong" : null,
                hintText: "Password",
                fillColor: Colors.transparent,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // borderSide: BorderSide.,
                ),
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  nameIsValid = value.isNotEmpty;
                });
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Nama Lengkap",
                filled: true,
                errorText: nameIsValid == false ? "Tidak Boleh Kosong" : null,
                fillColor: Colors.transparent,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // borderSide: BorderSide.,
                ),
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _addressController,
              onChanged: (value) {
                setState(() {
                  addressIsValid = value.isNotEmpty;
                });
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Alamat",
                filled: true,
                errorText: addressIsValid == false ? "Tidak Boleh Kosong" : null,
                fillColor: Colors.transparent,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // borderSide: BorderSide.,
                ),
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _phoneController,
              onChanged: (value) {
                setState(() {
                  phoneIsValid = value.isNotEmpty;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Nomor Hp",
                filled: true,
                errorText: phoneIsValid == false ? "Tidak Boleh Kosong" : null,
                fillColor: Colors.transparent,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // borderSide: BorderSide.,
                ),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                showDialog<void>(context: context, builder: (context) => outletDialog);
              },
              child: TextField(
                controller: _outletController,
                enabled: false,
                onChanged: (value) {
                  setState(() {

                  });
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Outlet",
                  filled: true,
                  fillColor: Colors.transparent,
                  hintStyle: TextStyle(color: MyColors.grey_60),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // borderSide: BorderSide.,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // borderSide: BorderSide.,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: _createUserLoading ? ProgressLoading() : FlatButton.icon(
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: kPrimaryColor,
                onPressed: () {
                  var username = _usernameController.text.toString();
                  var password = _passwordController.text.toString();
                  var name = _nameController.text.toString();
                  var address = _addressController.text.toString();
                  var phoneNumber = _phoneController.text.toString();
                  var outletId = selectedOutlet?.id;
                  var roleId = 2;

                  if(username.isEmpty){
                    setState(() {
                      usernameIsValid = false;
                    });
                    return;
                  }
                  if(widget.userItem == null){
                    if(password.isEmpty){
                      setState(() {
                        passwordIsValid = false;
                      });
                      return;
                    }
                  }

                  if(name.isEmpty){
                    setState(() {
                      nameIsValid = false;
                    });
                    return;
                  }
                  if(address.isEmpty){
                    setState(() {
                      addressIsValid = false;
                    });
                    return;
                  }
                  if(phoneNumber.isEmpty){
                    setState(() {
                      phoneIsValid = false;
                    });
                    return;
                  }
                  var param = UserParam(username, password, outletId, roleId, name, phoneNumber, address, widget.userItem?.id);
                  var errorMessage = param.validateError();
                  if(errorMessage == null){
                    if(widget.userItem != null){
                      bloc.add(UpdateUsers(param));
                    }else{
                      bloc.add(CreateUsers(param));
                    }
                  }else{
                    MySnackbar(context).errorSnackbar(errorMessage);
                  }
                },
                icon: WebsafeSvg.asset("assets/Icons/Edit.svg", width: 16),
                label: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
              ).addNeumorphism(
                topShadowColor: Colors.white,
                bottomShadowColor: const Color(0xFF234395).withOpacity(0.2),
              ),
            ),
            if(widget.userItem != null)
              _deleteUserLoading ? ProgressLoading() : Container(
                child: FlatButton.icon(
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    showDeleteDialog(context);
                  },
                  label: const Text(
                    "Hapus",
                    style: TextStyle(color: Colors.white),
                  ), icon: Icon(Icons.remove_circle_outline, color: Colors.white,),
                )
              ),
          ],
        ),
      ),
    );
  }

  showDeleteDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Batal"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Hapus"),
      onPressed:  () {
        var userId = widget.userItem?.id;
        if(userId != null){
          bloc.add(DeleteUser(userId));
        }
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Peringatan"),
      content: Text("Anda yakin ingin mengahpus produk ini?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

