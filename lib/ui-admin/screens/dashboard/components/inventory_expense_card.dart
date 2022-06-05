import 'package:flutter/material.dart';
import 'package:maktampos/ui-admin/models/Email.dart';
import 'package:maktampos/ui-admin/res/my_colors.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';
import '../../../extensions.dart';

class InventoryExpense extends StatelessWidget {
  const InventoryExpense({
    Key? key, this.press,
  }) : super(key: key);

  final VoidCallback? press;

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
                          "Pengeluaran Gudang",
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
                        child: Text(
                          "Surabaya",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 14
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Rp.12.0000",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 14
                          ),
                        ),
                      ),
                      IconButton(onPressed: (){

                      }, icon: Icon(Icons.restore_from_trash, color: Colors.red,))
                    ],
                  ),
                  Divider(height: 30,),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Jakarta",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 14
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Rp.10.000",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              color: MyColors.grey_80,
                              fontSize: 14
                          ),
                        ),
                      ),
                      IconButton(onPressed: (){

                      }, icon: Icon(Icons.restore_from_trash, color: Colors.red,))
                    ],
                  ),
                  Divider(height: 30,),
                  Row(
                    children: [
                      Expanded(
                        child:  TextField(
                          autofocus: false,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            hintText: "Keterangan",
                            fillColor: kBgLightColor,
                            filled: true,
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(
                                  kDefaultPadding * 0.75), //15
                              child: Icon(
                                Icons.place, size: 24,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            hintText: "Jumlah",
                            fillColor: kBgLightColor,
                            filled: true,
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(
                                  kDefaultPadding * 0.75), //15
                              child: Icon(
                                Icons.attach_money, size: 24,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  FlatButton.icon(
                    minWidth: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: kDefaultPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: kPrimaryColor,
                    onPressed: () {},
                    icon: WebsafeSvg.asset("assets/Icons/Edit.svg", width: 16),
                    label: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ).addNeumorphism(
                    topShadowColor: Colors.white,
                    bottomShadowColor: const Color(0xFF234395).withOpacity(0.2),
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
