import 'package:flutter/material.dart';
import 'package:maktampos/ui-admin/models/Email.dart';
import 'package:maktampos/ui-admin/res/my_colors.dart';
import 'package:maktampos/ui-admin/screens/pdf_viewer.dart';
import 'package:maktampos/ui-admin/services/responses/summary_response.dart';
import 'package:maktampos/ui-admin/utils/number_utils.dart';
import 'package:maktampos/ui-admin/utils/screen_utils.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';
import '../../../extensions.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    Key? key, this.press, this.summaryResponse
  }) : super(key: key);

  final VoidCallback? press;
  final SummaryResponse? summaryResponse;

  @override
  Widget build(BuildContext context) {
    //  Here the shadow is not showing properly
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 4),
      child: InkWell(
        onTap: press,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                color: kBgLightColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Pendapatan",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      IconButton(onPressed: (){
                        ScreenUtils(context).navigateTo(PDFScreen(path: summaryResponse?.urlExcel ?? "",));
                      }, icon: Icon(Icons.download, color: MyColors.primary,))
                    ],
                  ),
                  Divider(height: 30,),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Total Modal",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 14
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          NumberUtils.toRupiah(summaryResponse?.totalFund?.toDouble() ?? 0.0),
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 14
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 30,),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Total Pengeluaran",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 14
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          NumberUtils.toRupiah(summaryResponse?.totalExpense?.toDouble() ?? 0.0),
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 14
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 30,),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Pendapatan",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 14
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                            NumberUtils.toRupiah(summaryResponse?.totalIncome?.toDouble() ?? 0.0),
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 14
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 30,),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Saldo",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 14
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                           NumberUtils.toRupiah(summaryResponse?.balance?.toDouble() ?? 0.0),
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 14
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 30,),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Omset",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 14
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "todo",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 14
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).addNeumorphism(
              blurRadius: 15,
              borderRadius: 15,
              offset: const Offset(5, 5),
              topShadowColor: Colors.white60,
              bottomShadowColor: const Color(0xFF234395).withOpacity(0.15),
            ),
          ],
        ),
      ),
    );
  }
}
