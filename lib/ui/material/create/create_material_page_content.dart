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

  var state = _CreateMaterialPageContentState();

  List<MaterialItemParam?> getParams() {
    var params = state.getParams();
    return params;
  }

  @override
  _CreateMaterialPageContentState createState() => state;

  CreateMaterialPageContent({this.materialDetailResponse});
}

class _CreateMaterialPageContentState extends State<CreateMaterialPageContent>
    with AutomaticKeepAliveClientMixin<CreateMaterialPageContent> {
  late MaterialBloc bloc;
  List<MaterialItem> items = [];
  bool _isLoading = true;

  List<MaterialItemParam?> getParams() {
    return items
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
    bloc.add(GetMaterialItems());
  }

  List<Widget> generateItems(TextTheme _textTheme) {
    List<Widget> newItems = items.map((item) {
      int stock = 0;
      int std = item.standard ?? 0;

      var materialDetail = widget.materialDetailResponse;
      MaterialItemDetailResponse? detailItem = materialDetail?.items
          ?.firstWhereOrNull(
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
                  _addedController.text = (std - stock).toString();
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
        items = state.items ?? [];
      });
    } else if (state is InitialState) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is FailedState) {
      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
      if (state.code == 401) {
        ScreenUtils(context).navigateTo(const LoginPage(), replaceScreen: true);
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
