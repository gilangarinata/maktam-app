import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class MaterialCard extends StatelessWidget {
  const MaterialCard({
    Key? key, this.press, required this.materialItems
  }) : super(key: key);

  final VoidCallback? press;
  final List<MaterialItem>? materialItems;

  Widget buildTableHeader(BuildContext context){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Laporan Material",
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
                "Stok",
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
                "Tambah",
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
    List<Widget> items = materialItems?.map((item) => Column(
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
              child: Text(
                item.stock  ?? "0",
                style: Theme.of(context).textTheme.caption?.copyWith(
                    color: MyColors.grey_80,
                    fontSize: 14
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  item.added ?? "0",
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
    )).toList() ?? [];

    items.insert(0,buildTableHeader(context));
    return items;
  }


  @override
  Widget build(BuildContext context) {
    //  Here the shadow is not showing properly
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 4),
      child: InkWell(
        onTap: press,
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
      ),
    );
  }
}
