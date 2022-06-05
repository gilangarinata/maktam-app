import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maktampos/ui-admin/models/Email.dart';
import 'package:maktampos/ui-admin/res/my_colors.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';
import 'package:maktampos/ui-admin/services/responses/stock_response.dart';
import 'package:maktampos/ui-admin/utils/number_utils.dart';
import 'package:maktampos/ui-admin/utils/screen_utils.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';
import '../../../extensions.dart';
import '../../pdf_viewer.dart';

class StockCupSpicesCard extends StatelessWidget {
  const StockCupSpicesCard({
    Key? key, this.press, required this.stockResponse, required this.isCup
  }) : super(key: key);

  final VoidCallback? press;
  final StockResponse? stockResponse;
  final bool isCup;

  Widget buildTableHeader(BuildContext context){
    return Column(
      children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isCup ? "Laporan Stok Cup" : "Laporan Stok Bumbu",
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyColors.grey_90,
                        fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                IconButton(onPressed: (){
                  ScreenUtils(context).navigateTo(PDFScreen(path: isCup ? stockResponse?.cups?.url ?? "" : stockResponse?.spices?.url ?? "",));
                }, icon: Icon(Icons.download, color: MyColors.primary,))
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    isCup ? "Cup" : "Bumbu",
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyColors.grey_80,
                        fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
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
                  flex: 1,
                  child: Text(
                    "Terjual",
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyColors.grey_80,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Sisa",
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

  List<Widget> generateStockWidget(BuildContext context){
    var items = isCup ? stockResponse?.cups?.items : stockResponse?.spices?.items;
    List<Widget> stockItems = items?.map((item) => Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                item.name  ?? "",
                style: Theme.of(context).textTheme.caption?.copyWith(
                    color: MyColors.grey_80,
                    fontSize: 14
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  item.stock ?? "0",
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: MyColors.grey_80,
                      fontSize: 14
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  item.sold ?? "0",
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: MyColors.grey_80,
                      fontSize: 14
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  item.lefts ?? "0",
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

    stockItems.insert(0,buildTableHeader(context));
    return stockItems;
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
              children: generateStockWidget(context),
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
