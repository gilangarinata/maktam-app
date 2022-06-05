import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/ui-admin/components/progress_loading.dart';
import 'package:maktampos/ui-admin/extensions.dart';
import 'package:maktampos/ui-admin/res/my_colors.dart';
import 'package:maktampos/ui-admin/screens/maktam_bloc.dart';
import 'package:maktampos/ui-admin/screens/maktam_event.dart';
import 'package:maktampos/ui-admin/screens/maktam_state.dart';
import 'package:maktampos/ui-admin/services/param/outlet_param.dart';
import 'package:maktampos/ui-admin/services/param/user_param.dart';
import 'package:maktampos/ui-admin/services/responses/outlet_response.dart';
import 'package:maktampos/ui-admin/services/responses/subcategory_response.dart';
import 'package:maktampos/ui-admin/services/responses/user_response.dart';
import 'package:maktampos/ui-admin/utils/my_snackbar.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:collection/collection.dart';


import '../../../constants.dart';


class CreateOutletDialog extends StatefulWidget {
  const CreateOutletDialog({Key? key, this.outletItem}) : super(key: key);

  final OutletItem? outletItem;

  @override
  State<CreateOutletDialog> createState() => _CreateOutletDialogState();
}

class _CreateOutletDialogState extends State<CreateOutletDialog> {

  late TextEditingController _nameController;
  late TextEditingController _addressController;

  bool _createOutletLoading = false;
  bool _deleteOutletLoading = false;

  bool? nameIsValid;
  bool? addressIsValid;

  late MaktamBloc bloc;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.outletItem?.name);
    _addressController = TextEditingController(text: widget.outletItem?.address);
    bloc = BlocProvider.of<MaktamBloc>(context);
  }

  void blocListener(BuildContext context, MaktamState state) async {
    if (state is CreateOutletLoading) {
      setState(() {
        _createOutletLoading = true;
      });
    }else if (state is DeleteOutletLoading) {
      setState(() {
        _deleteOutletLoading = true;
      });
    } else if (state is CreateOutletsSuccess) {
      /*
        create user
       */
      setState(() {
        _createOutletLoading = false;
      });
      Navigator.pop(context, 200);
    }else if (state is DeleteOutletsSuccess) {
      /*
        deleteUser user
       */
      setState(() {
        _deleteOutletLoading = false;
      });
      Navigator.pop(context, 200);
    }   else if (state is InitialState) {
      setState(() {
        _createOutletLoading = false;
      });
    } else if (state is FailedState) {
      Navigator.of(context).pop();
      setState(() {
        _createOutletLoading = false;
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
                    "Tambah Outlet",
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
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  nameIsValid = value.isNotEmpty;
                });
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Nama Outlet",
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
            Container(
              child: _createOutletLoading ? ProgressLoading() : FlatButton.icon(
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: kPrimaryColor,
                onPressed: () {
                  var name = _nameController.text.toString();
                  var address = _addressController.text.toString();
                  if(name.isEmpty){
                    setState(() {
                      nameIsValid = false;
                    });
                    return;
                  }

                  var param = OutletParam(name,address,widget.outletItem?.id);
                  if(param.isValid()){
                    if(widget.outletItem != null){
                      bloc.add(UpdateOutlet(param));
                    }else{
                      bloc.add(CreateOutlet(param));
                    }
                  }else{
                    MySnackbar(context).errorSnackbar("Data tidak valid");
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
            if(widget.outletItem != null)
              _deleteOutletLoading ? ProgressLoading() : Container(
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
        var userId = widget.outletItem?.id;
        if(userId != null){
          bloc.add(DeleteOutlet(userId));
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

