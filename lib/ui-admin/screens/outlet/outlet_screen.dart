import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktampos/ui-admin/components/progress_loading.dart';
import 'package:maktampos/ui-admin/components/side_menu.dart';
import 'package:maktampos/ui-admin/res/my_colors.dart';
import 'package:maktampos/ui-admin/screens/cup/components/create_cup_dialog.dart';

import 'package:maktampos/ui-admin/screens/email/email_screen.dart';
import 'package:maktampos/ui-admin/screens/main/components/email_card.dart';
import 'package:maktampos/ui-admin/screens/maktam_bloc.dart';
import 'package:maktampos/ui-admin/screens/maktam_event.dart';
import 'package:maktampos/ui-admin/screens/maktam_state.dart';
import 'package:maktampos/ui-admin/screens/user/components/create_user_dialog.dart';
import 'package:maktampos/ui-admin/services/responses/outlet_response.dart';
import 'package:maktampos/ui-admin/services/responses/user_response.dart';
import 'package:maktampos/ui-admin/utils/my_snackbar.dart';


import '../../constants.dart';
import '../../responsive.dart';


import 'package:flutter/foundation.dart' show kIsWeb;

import 'components/create_outlet_dialog.dart';

class OutletScreen extends StatefulWidget {
  // Press "Command + ."
  const OutletScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<OutletScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late MaktamBloc bloc;

  bool _getOutletIsLoading = true;
  List<OutletItem> _outletItems = [];

  late Dialog createDialog;

  @override
  void initState() {
    super.initState();
    initDialog();
    bloc = BlocProvider.of<MaktamBloc>(context);
    getData();
  }

  void initDialog(){
    createDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: CreateOutletDialog(),
    );
  }

  void getData(){
    bloc.add(GetUsers());
    bloc.add(GetOutlets());
  }

  void blocListener(BuildContext context, MaktamState state) async {
    if (state is GetOutletLoading) {
      setState(() {
        _getOutletIsLoading = true;
      });
    } else if (state is GetOutletsSuccess) {
      /*
        Get outlet
       */
      setState(() {
        _getOutletIsLoading = false;
        _outletItems = state.items ?? [];
      });
      initDialog();
    } else if (state is InitialState) {
      setState(() {
        _getOutletIsLoading = true;
      });
    } else if (state is FailedState) {
      setState(() {
        _getOutletIsLoading = false;
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
                flex: 3,
                child: Text(
                  "Outlet",
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
                  "Alamat",
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
    List<Widget> sellingItems = _outletItems.map((outlet) => InkWell(
      onTap: (){
        Dialog editDialog = Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
          child: CreateOutletDialog(
            outletItem: outlet,
          ),
        );

        showDialog(context: context, builder: (BuildContext context) => editDialog).then((value) {
          if(value == 200)  getData();
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  outlet.name  ?? "-",
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: MyColors.grey_80,
                      fontSize: 14
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  outlet.address ?? "-",
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
        child: const SideMenu(currentPage: "outlet",),
      ),
      body : BlocListener<MaktamBloc, MaktamState>(
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
                        "Outlet",
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
                  child: _getOutletIsLoading ? ProgressLoading() :  Padding(
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
            if(value == 200) getData();
          });
        },
        backgroundColor: MyColors.primary,
        child: const Icon(Icons.add,color: MyColors.white,),
      ),
    );
  }
}
