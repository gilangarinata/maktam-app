import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/services/model/material_detail_response.dart';
import 'package:maktampos/services/model/material_item_response.dart';
import 'package:maktampos/services/param/material_param.dart';
import 'package:maktampos/ui/login/login_page.dart';
import 'package:maktampos/ui/material/material_bloc.dart';
import 'package:maktampos/ui/material/material_event.dart';
import 'package:maktampos/utils/my_snackbar.dart';
import 'package:maktampos/utils/screen_utils.dart';
import 'package:maktampos/widget/progress_loading.dart';

import '../material_state.dart';

class CreateMaterialPageContent extends StatefulWidget {
  MaterialDetailResponse? materialDetailResponse;
  List<MaterialItem>? materialItems;

  var state = _CreateMaterialPageContentState();

  List<MaterialItemParam?> getParams() {
    print("material item : $materialItems");
    return materialItems
        ?.map((e) {
      if (e.stock != null && e.added != null) {
        return e.toMaterialItemParam();
      } else {
        return null;
      }
    })
        .toList()
        .where((element) => element != null)
        .toList() ?? [];
  }

  @override
  _CreateMaterialPageContentState createState() => state;

  CreateMaterialPageContent({this.materialDetailResponse,this.materialItems});
}

class _CreateMaterialPageContentState extends State<CreateMaterialPageContent>
    with AutomaticKeepAliveClientMixin<CreateMaterialPageContent> {
  late MaterialBloc bloc;
  bool _isLoading = false;

  List<MaterialItemDetailResponse> _materialItemDetailResponse = [];

  List<MaterialItemParam?>? getParams() {
    var materialItems = widget.materialItems ?? [];
    print("material item : $materialItems");
    return materialItems
        .map((e) {
          if (e.stock != null && e.added != null) {
            return e.toMaterialItemParam();
          } else {
            return null;
          }
        })
        .toList()
        .where((element) => element != null)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<MaterialBloc>(context);
    _materialItemDetailResponse = widget.materialDetailResponse?.items ?? [];
  }

  List<Widget> generateItems(TextTheme _textTheme) {
    List<Widget> newItems = (widget.materialItems ?? []).map((item) {
      int stock = 0;
      int std = item.standard ?? 0;

      MaterialItemDetailResponse? detailItem = _materialItemDetailResponse
          .firstWhereOrNull(
              (element) => element.materialId == item.materialId);

      String? added = detailItem?.added.toString();
      TextEditingController _addedController =
          TextEditingController(text: added);

      item.detailId = detailItem?.id;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.materialName ?? "",
                style: _textTheme.caption,
              ),
            ),
            Expanded(
              child: TextFormField(
                initialValue: detailItem?.stock?.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  stock = int.tryParse(value) ?? 0;
                  item.stock = stock;
                  item.added = std - stock;
                  var added = (std - stock);
                  _addedController.text = added.toString();
                  var materialDetail = _materialItemDetailResponse.firstWhereOrNull((element) => element.materialId == item.materialId);
                  if(materialDetail == null){
                    _materialItemDetailResponse.add(
                      MaterialItemDetailResponse(
                        id: null,
                        materialId: item.materialId,
                        name: item.materialName,
                        stock: stock,
                        added: added,
                        standard: std
                      )
                    );
                  }else{
                    for (var element in _materialItemDetailResponse) {
                      if(element.materialId == item.materialId){
                        element.added = added;
                        element.stock = stock;
                      }
                    }
                  }
                },
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFormField(
                controller: _addedController,
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Tambah",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextFormField(
                initialValue: item.standard?.toString() ?? "",
                enabled: false,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {},
              ),
            )
          ],
        ),
      );
    }).toList();
    newItems.insert(
        0,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              Expanded(child: Container()),
              Expanded(child: Text("Jumlah")),
              Expanded(child: Text("Tambah")),
              Expanded(child: Text("Standart")),
            ],
          ),
        ));

    return newItems;
  }

  void blocListener(BuildContext context, MaterialsState state) async {
    if (state is GetMaterialLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is GetMaterialItemSuccess) {
      setState(() {
        _isLoading = false;
      });
    } else if (state is InitialState) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is FailedState) {
      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
      if (state.code == 401) {
        ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    return BlocListener<MaterialBloc, MaterialsState>(
      listener: blocListener,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: _isLoading
            ? ProgressLoading()
            : ListView(
                children: generateItems(_textTheme),
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
