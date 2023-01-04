import 'package:flutter/material.dart';
import 'package:maktampos/ui-admin/screens/category/category_screen.dart';
import 'package:maktampos/ui-admin/screens/cup/cup_screen.dart';
import 'package:maktampos/ui-admin/screens/dashboard/dashboard_screen.dart';
import 'package:maktampos/ui-admin/screens/material/material_screen.dart';
import 'package:maktampos/ui-admin/screens/outlet/outlet_screen.dart';
import 'package:maktampos/ui-admin/screens/product/product_screen.dart';
import 'package:maktampos/ui-admin/screens/spices/spices_screen.dart';
import 'package:maktampos/ui-admin/screens/user/user_screen.dart';
import 'package:maktampos/ui-admin/utils/screen_utils.dart';
import 'package:maktampos/ui/login/login_page.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../constants.dart';
import '../extensions.dart';
import '../responsive.dart';
import 'side_menu_item.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,  this.currentPage
  }) : super(key: key);

  final String? currentPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kDefaultPadding),
      color: kBgLightColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/user.png",
                    width: 46,
                  ),
                  const Spacer(),
                  // We don't want to show this close button on Desktop mood
                  if (!Responsive.isDesktop(context)) const CloseButton(),
                ],
              ),
              const SizedBox(height: kDefaultPadding * 2),
              // Menu Items
              SideMenuItem(
                press: () {
                  ScreenUtils(context).navigateTo(DashboardScreen(),replaceScreen: true);
                },
                title: "Home",
                iconSrc: "assets/Icons/Inbox.svg",
                isActive: currentPage == "home",
              ),
              SideMenuItem(
                press: () {
                  ScreenUtils(context).navigateTo(ProductScreen(),replaceScreen: true);
                },
                title: "Produk",
                iconSrc: "assets/Icons/Send.svg",
                isActive: currentPage == "product",
              ),
              SideMenuItem(
                press: () {
                  ScreenUtils(context).navigateTo(CategoryScreen(),replaceScreen: true);
                },
                title: "Kategori",
                iconSrc: "assets/Icons/File.svg",
                isActive: currentPage == "category",
              ),
              SideMenuItem(
                press: () {
                  ScreenUtils(context).navigateTo(CupScreen(),replaceScreen: true);
                },
                title: "Cup",
                iconSrc: "assets/Icons/Trash.svg",
                isActive: currentPage == "cup",
              ),
              SideMenuItem(
                press: () {
                  ScreenUtils(context).navigateTo(SpicesScreen(),replaceScreen: true);
                },
                title: "Bumbu",
                iconSrc: "assets/Icons/Trash.svg",
                isActive: currentPage == "spices",
              ),
              SideMenuItem(
                press: () {
                  ScreenUtils(context).navigateTo(MaterialScreen(),replaceScreen: true);
                },
                title: "Material",
                iconSrc: "assets/Icons/Trash.svg",
                isActive: currentPage == "material",
              ),
              SideMenuItem(
                press: () {
                  ScreenUtils(context).navigateTo(UserScreen(),replaceScreen: true);
                },
                title: "Pengguna",
                iconSrc: "assets/Icons/Trash.svg",
                isActive: currentPage == "user",
              ),
              SideMenuItem(
                press: () {
                  ScreenUtils(context).navigateTo(OutletScreen(),replaceScreen: true);
                },
                title: "Outlet",
                iconSrc: "assets/Icons/Trash.svg",
                isActive: currentPage == "outlet",
              ),
              SideMenuItem(
                press: () {
                  ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
                },
                title: "Keluar",
                iconSrc: "assets/Icons/Trash.svg",
                isActive: false,
              ),
              const SizedBox(height: kDefaultPadding * 2),
              // Tags
            ],
          ),
        ),
      ),
    );
  }
}