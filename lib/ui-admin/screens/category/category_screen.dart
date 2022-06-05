import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktampos/ui-admin/components/progress_loading.dart';
import 'package:maktampos/ui-admin/components/side_menu.dart';
import 'package:maktampos/ui-admin/res/my_colors.dart';
import 'package:maktampos/ui-admin/screens/category/components/create_category_dialog.dart';

import 'package:maktampos/ui-admin/screens/email/email_screen.dart';
import 'package:maktampos/ui-admin/screens/main/components/email_card.dart';
import 'package:maktampos/ui-admin/screens/product/components/create_product_dialog.dart';
import 'package:maktampos/ui-admin/screens/product/product_bloc.dart';
import 'package:maktampos/ui-admin/screens/product/product_event.dart';
import 'package:maktampos/ui-admin/screens/product/product_state.dart';
import 'package:maktampos/ui-admin/services/param/inventory_param.dart';
import 'package:maktampos/ui-admin/services/responses/category_response.dart';
import 'package:maktampos/ui-admin/services/responses/subcategory_response.dart';
import 'package:maktampos/ui-admin/services/responses/material_item_response.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';
import 'package:maktampos/ui-admin/services/responses/stock_response.dart';
import 'package:maktampos/ui-admin/services/responses/summary_response.dart';
import 'package:maktampos/ui-admin/utils/my_snackbar.dart';
import 'package:maktampos/ui-admin/utils/number_utils.dart';
import 'package:maktampos/ui-admin/utils/screen_utils.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:maktampos/ui-admin/models/Email.dart';


import 'package:flutter/foundation.dart' show kIsWeb;

import '../../constants.dart';
import '../../responsive.dart';

class CategoryScreen extends StatefulWidget {
  // Press "Command + ."
  const CategoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ProductBloc bloc;

  bool _getCategoriesIsLoading = true;
  List<CategoryItem> _categoryItems = [];

  late Dialog createDialog;

  @override
  void initState() {
    super.initState();
    initDialog();
    bloc = BlocProvider.of<ProductBloc>(context);
    getData();
  }

  void initDialog(){
    createDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: CreateCategoryDialog(),
    );
  }

  void getData(){
    bloc.add(GetCategories());
  }

  void blocListener(BuildContext context, ProductState state) async {
    if (state is GetCategoryLoading) {
      setState(() {
        _getCategoriesIsLoading = true;
      });
    } else if (state is GetCategorySuccess) {
      /*
        Get categories
       */
      setState(() {
        _getCategoriesIsLoading = false;
        _categoryItems = state.items ?? [];
      });
    } else if (state is InitialState) {
      setState(() {
        _getCategoriesIsLoading = true;
      });
    } else if (state is FailedState) {
      setState(() {
        _getCategoriesIsLoading = false;
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

  Widget buildTableHeader(BuildContext context){
    return InkWell(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Kategori",
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
      ),
    );
  }

  List<Widget> generateTable(BuildContext context){
    List<Widget> sellingItems = _categoryItems.map((category) => InkWell(
      onTap: (){
        Dialog editDialog = Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
          child: CreateCategoryDialog(
            categoryItem: category,
          ),
        );

        showDialog(context: context, builder: (BuildContext context) => editDialog).then((value) {
          if(value == 200){
            getData();
          }
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  category.name  ?? "-",
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: MyColors.grey_80,
                      fontSize: 14
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: MyColors.grey_60,)
            ],
          ),
          const Divider(height: 30,),
        ],
      ),
    )).toList() ?? [];

    sellingItems.insert(0,buildTableHeader(context));
    return sellingItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: const SideMenu(currentPage: "category",),
      ),
      body : BlocListener<ProductBloc, ProductState>(
        child: Container(
          padding: EdgeInsets.only(top: kDefaultPadding),
          color: kBgDarkColor,
          child: SafeArea(
            right: false,
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Row(
                    children: [
                      // Once user click the menu icon the menu shows like drawer
                      // Also we want to hide this menu icon on desktop
                      if (!Responsive.isDesktop(context))
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      SizedBox(width: 15),
                      Text(
                        "Kategori",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            color: MyColors.grey_80,
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                Expanded(
                  child: _getCategoriesIsLoading ? ProgressLoading() :  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        getData();
                      },
                      child: ListView(
                        children: generateTable(context)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        listener: blocListener,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (BuildContext context) => createDialog).then((value) {
            if(value == 200){
              getData();
            }
          });
        },
        backgroundColor: MyColors.primary,
        child: const Icon(Icons.add,color: MyColors.white,),
      ),
    );
  }
}
