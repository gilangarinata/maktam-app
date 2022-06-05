import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maktampos/ui-admin/components/progress_loading.dart';
import 'package:maktampos/ui-admin/models/Email.dart';
import 'package:maktampos/ui-admin/res/my_colors.dart';
import 'package:maktampos/ui-admin/services/responses/material_item_response.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';
import 'package:maktampos/ui-admin/services/responses/stock_response.dart';
import 'package:maktampos/ui-admin/utils/number_utils.dart';
import 'package:maktampos/ui-admin/utils/screen_utils.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:collection/collection.dart';

import '../../../constants.dart';
import '../../../extensions.dart';
import '../../pdf_viewer.dart';

class InventoryCard extends StatelessWidget {
  const InventoryCard({
    Key? key, this.savePressed, required this.materialItems, required this.onValueChanges, required this.updateLoading
  }) : super(key: key);

  final bool updateLoading;
  final VoidCallback? savePressed;
  final List<MaterialItem>? materialItems;
  final Function(int, MaterialItem) onValueChanges;

  Widget buildTableHeader(BuildContext context){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Gudang",
                style: Theme.of(context).textTheme.caption?.copyWith(
                    color: MyColors.grey_90,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Material",
                style: Theme.of(context).textTheme.caption?.copyWith(
                    color: MyColors.grey_80,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "Input Barang",
                style: Theme.of(context).textTheme.caption?.copyWith(
                    color: MyColors.grey_80,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "Stok Gudang",
                style: Theme.of(context).textTheme.caption?.copyWith(
                    color: MyColors.grey_80,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "Diambil Outlet",
                style: Theme.of(context).textTheme.caption?.copyWith(
                    color: MyColors.grey_80,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "Sisa Barang",
                style: Theme.of(context).textTheme.caption?.copyWith(
                    color: MyColors.grey_80,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
        Divider(height: 30,),
      ],
    );
  }

  List<Widget> generateWidget(BuildContext context){
    List<Widget> items = materialItems?.map((item) {
      TextEditingController controller = TextEditingController();
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  item.name  ?? "",
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: MyColors.grey_80,
                      fontSize: 14
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: controller,
                  onChanged: (value) {
                    int inventory = int.tryParse(value) ?? 0;
                    onValueChanges(inventory,item);
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    fillColor: kBgLightColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      // borderSide: BorderSide.,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    (item.inventoryStock ?? 0).toString(),
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyColors.grey_80,
                        fontSize: 14
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    (item.takenByOutlets ?? 0).toString(),
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyColors.grey_80,
                        fontSize: 14
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    (item.left ?? 0).toString(),
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyColors.grey_80,
                        fontSize: 14
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 30,),
        ],
      );
    }).toList() ?? [];

    items.insert(0,buildTableHeader(context));
    items.add(buildSaveButton());
    return items;
  }

  Widget buildSaveButton(){
    return Column(
      children: [
        Visibility(
            visible: updateLoading,
            child: Container(
          height: 30,
          child: Center(child: ProgressLoading()),
        )),
        Visibility(
          visible: !updateLoading,
          child: FlatButton.icon(
          minWidth: double.infinity,
          height: 10,
          padding: const EdgeInsets.symmetric(
            vertical: kDefaultPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: kPrimaryColor,
          onPressed: savePressed,
          icon: WebsafeSvg.asset("assets/Icons/Edit.svg", width: 16),
          label: const Text(
            "Simpan",
            style: TextStyle(color: Colors.white),
          ),
        ).addNeumorphism(
          topShadowColor: Colors.white,
          bottomShadowColor: const Color(0xFF234395).withOpacity(0.2),
        ),)

      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    //  Here the shadow is not showing properly
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 4),
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          color: kBgLightColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          child: Column(
            children: generateWidget(context),
          ),
        ),
      ).addNeumorphism(
        blurRadius: 15,
        borderRadius: 15,
        offset: const Offset(5, 5),
        topShadowColor: Colors.white60,
        bottomShadowColor: const Color(0xFF234395).withOpacity(0.15),
      ),
    );
  }
}
