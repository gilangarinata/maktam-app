import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maktampos/ui-admin/models/Email.dart';
import 'package:maktampos/ui-admin/res/my_colors.dart';
import 'package:maktampos/ui-admin/res/var_constants.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';
import 'package:maktampos/ui-admin/services/responses/stock_response.dart';
import 'package:maktampos/ui-admin/utils/number_utils.dart';
import 'package:maktampos/ui-admin/utils/screen_utils.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:collection/collection.dart';

import '../../../constants.dart';
import '../../../extensions.dart';
import '../../pdf_viewer.dart';

class StockMilkCard extends StatelessWidget {
  const StockMilkCard({
    Key? key, this.press, required this.stockResponse
  }) : super(key: key);

  final VoidCallback? press;
  final StockResponse? stockResponse;

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
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Stok Susu",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_90,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    IconButton(onPressed: (){
                      ScreenUtils(context).navigateTo(PDFScreen(path: stockResponse?.milk?.url ?? "",));
                    }, icon: Icon(Icons.download, color: MyColors.primary,))
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Total Susu Datang",
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
                        "Jumlah",
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

                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Total Susu Datang",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 14
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        stockResponse?.milk
                            ?.items
                            ?.firstWhereOrNull((element) => element.itemId == VarConstants.SUSU_DATANG_ITEM_ID)
                            ?.stock ?? "0",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30,),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Total Sisa Kemarin Mentah",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 14
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        stockResponse?.milk
                            ?.items
                            ?.firstWhereOrNull((element) => element.itemId == VarConstants.SISA_KEMARIN_MENTAH_ITEM_ID)
                            ?.stock ?? "0",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30,),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Total Sisa Kemarin Matang",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 14
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        stockResponse?.milk
                            ?.items
                            ?.firstWhereOrNull((element) => element.itemId == VarConstants.SISA_KEMARIN_MATANG_ITEM_ID)
                            ?.stock ?? "0",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30,),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Total Sisa Matang",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 14
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                          stockResponse?.milk
                              ?.items
                              ?.firstWhereOrNull((element) => element.itemId == VarConstants.SISA_MATANG_ITEM_ID)
                              ?.stock ?? "0",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30,),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Total Sisa Mentah",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 14
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                          stockResponse?.milk
                              ?.items
                              ?.firstWhereOrNull((element) => element.itemId == VarConstants.SISA_MENTAH_ITEM_ID)
                              ?.stock ?? "0",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30,),

              ],
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
