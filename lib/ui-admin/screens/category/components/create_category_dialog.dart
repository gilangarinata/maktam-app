import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/ui-admin/components/progress_loading.dart';
import 'package:maktampos/ui-admin/extensions.dart';
import 'package:maktampos/ui-admin/res/my_colors.dart';
import 'package:maktampos/ui-admin/screens/product/product_bloc.dart';
import 'package:maktampos/ui-admin/screens/product/product_event.dart';
import 'package:maktampos/ui-admin/screens/product/product_state.dart';
import 'package:maktampos/ui-admin/services/param/category_param.dart';
import 'package:maktampos/ui-admin/services/param/product_param.dart';
import 'package:maktampos/ui-admin/services/responses/category_response.dart';
import 'package:maktampos/ui-admin/services/responses/subcategory_response.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';
import 'package:maktampos/ui-admin/utils/my_snackbar.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:collection/collection.dart';


import '../../../constants.dart';

class CreateCategoryDialog extends StatefulWidget {
  const CreateCategoryDialog({Key? key, this.categoryItem}) : super(key: key);


  final CategoryItem? categoryItem;

  @override
  State<CreateCategoryDialog> createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateCategoryDialog> {

  late TextEditingController _nameController;
  bool _createCategoryLoading = false;
  bool _deleteCategoryLoading = false;
  bool? nameIsValid;

  late ProductBloc bloc;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.categoryItem?.name);
    bloc = BlocProvider.of<ProductBloc>(context);
  }

  void blocListener(BuildContext context, ProductState state) async {
    if (state is CreateCategoryLoading) {
      setState(() {
        _createCategoryLoading = true;
      });
    }else if (state is DeleteCategoryLoading) {
      setState(() {
        _deleteCategoryLoading = true;
      });
    }  else if (state is CreateCategorySuccess) {
      /*
        create caegory
       */
      setState(() {
        _createCategoryLoading = false;
        _deleteCategoryLoading = false;
      });
      Navigator.pop(context,200);
    }else if (state is DeleteCategorySuccess) {
      /*
        delete category
       */
      setState(() {
        _deleteCategoryLoading = false;
      });
      Navigator.pop(context,200);
    }   else if (state is InitialState) {
      setState(() {
        _createCategoryLoading = false;
        _deleteCategoryLoading = false;
      });
    } else if (state is FailedState) {
      Navigator.of(context).pop();
      setState(() {
        _createCategoryLoading = false;
        _deleteCategoryLoading = false;
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
    return BlocListener<ProductBloc, ProductState>(
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
                    widget.categoryItem != null ? "Edit Kategori" : "Tambah Kategori",
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
                hintText: "Nama Kategori",
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
            _deleteCategoryLoading || _createCategoryLoading ? ProgressLoading() : Container(
              child: Column(
                children: [
                  Container(
                    child: FlatButton.icon(
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: kPrimaryColor,
                      onPressed: () {
                        var productName = _nameController.text.toString();
                        if(productName.isEmpty){
                          setState(() {
                            nameIsValid = false;
                          });
                          return;
                        }
                        setState(() {
                          nameIsValid = true;
                        });
                        var categoryParam = CategoryParam(productName, "item", widget.categoryItem?.id, widget.categoryItem?.name);
                        if(categoryParam.isValid()){
                          if(widget.categoryItem != null){
                            bloc.add(UpdateCategory(categoryParam));
                          }else{
                            bloc.add(CreateCategory(categoryParam));
                          }
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
                  if(widget.categoryItem != null)
                    Container(
                        child: _createCategoryLoading ? ProgressLoading() : FlatButton.icon(
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
        var productId = widget.categoryItem?.id;
        if(productId != null){
          bloc.add(DeleteCategory(productId));
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

