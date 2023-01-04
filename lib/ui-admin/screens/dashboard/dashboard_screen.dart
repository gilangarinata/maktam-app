import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktampos/ui-admin/components/progress_loading.dart';
import 'package:maktampos/ui-admin/components/side_menu.dart';
import 'package:maktampos/ui-admin/screens/dashboard/components/inventory_card.dart';
import 'package:maktampos/ui-admin/screens/dashboard/components/inventory_expense_card.dart';
import 'package:maktampos/ui-admin/screens/dashboard/components/material_card.dart';
import 'package:maktampos/ui-admin/screens/dashboard/components/selling_card.dart';
import 'package:maktampos/ui-admin/screens/dashboard/components/stock_cup_spices_card.dart';
import 'package:maktampos/ui-admin/screens/dashboard/components/stock_milk_card.dart';
import 'package:maktampos/ui-admin/screens/dashboard/components/summary_card.dart';
import 'package:maktampos/ui-admin/screens/dashboard/dasboard_bloc.dart';
import 'package:maktampos/ui-admin/screens/dashboard/dasboard_event.dart';
import 'package:maktampos/ui-admin/screens/dashboard/dashboard_state.dart';
import 'package:maktampos/ui-admin/screens/email/email_screen.dart';
import 'package:maktampos/ui-admin/screens/main/components/email_card.dart';
import 'package:maktampos/ui-admin/services/param/inventory_param.dart';
import 'package:maktampos/ui-admin/services/responses/inventory_expense_response.dart';
import 'package:maktampos/ui-admin/services/responses/material_item_response.dart';
import 'package:maktampos/ui-admin/services/responses/product_response.dart';
import 'package:maktampos/ui-admin/services/responses/stock_response.dart';
import 'package:maktampos/ui-admin/services/responses/summary_response.dart';
import 'package:maktampos/ui-admin/utils/my_snackbar.dart';
import 'package:maktampos/ui-admin/utils/screen_utils.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:maktampos/ui-admin/models/Email.dart';

import '../../constants.dart';
import '../../responsive.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class DashboardScreen extends StatefulWidget {
  // Press "Command + ."
  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController dateController;
  late DateTime selectedDate;
  late DashboardBloc bloc;
  bool _summaryIsLoading = true;
  bool _sellingIsLoading = true;
  bool _inventoryExpenseIsLoading = false;
  bool _stockIsLoading = true;
  bool _materialIsLoading = true;
  bool _updateInventoryLoading = false;
  bool addInventoryExpenseLoading = false;
  SummaryResponse? _summaryResponse;
  List<ProductItem> _productResponse = [];
  StockResponse? _stockResponse;
  List<MaterialItem> _materialItems = [];
  List<MaterialItem> _inventoryItems = [];
  List<InventoryExpenseResponse> _inventoryExpenseItems = [];
  String? inventoryLocation = null;
  int? inventoryTotal = null;

  //params
  List<InventoryParam> _inventoryParams = [];

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<DashboardBloc>(context);
    var today = DateTime.now();
    selectedDate = today;
    var formattedDate = DateFormat("dd MMM yyyy").format(today);
    dateController = TextEditingController(
        text: formattedDate
    );
    getData();
  }

  void getData(){
    bloc.add(GetSummary(selectedDate));
    bloc.add(GetSelling(selectedDate));
    bloc.add(GetStocks(selectedDate));
    bloc.add(GetMaterials(selectedDate));
    bloc.add(GetInventory(selectedDate));
    bloc.add(GetInventoryExpense(selectedDate));
  }

  void resetData(){
    setState(() {
      _summaryResponse = null;
      _productResponse = [];
      _stockResponse = null;
      _materialItems = [];
      _inventoryItems = [];
      _inventoryExpenseItems = [];
    });
  }

  void blocListener(BuildContext context, DashboardState state) async {
    if (state is GetSummaryLoading) {
      setState(() {
        _summaryIsLoading = true;
      });
    } else if (state is GetSellingLoading) {
      setState(() {
        _sellingIsLoading = true;
      });
    }else if (state is AddInventoryExpenseLoading) {
      setState(() {
        addInventoryExpenseLoading = true;
      });
    }else if (state is DeleteInventoryExpenseLoading) {
      setState(() {
        addInventoryExpenseLoading = true;
      });
    }else if (state is GetStockLoading) {
      setState(() {
        _stockIsLoading = true;
      });
    }else if (state is GetInventoryExpenseLoading) {
      setState(() {
        _inventoryExpenseIsLoading = true;
      });
    }else if (state is GetMaterialLoading) {
      setState(() {
        _materialIsLoading = true;
      });
    }else if (state is GetInventoryLoading) {
      setState(() {
        // _inventoryIsLoadng = true;
      });
    }else if (state is UpdateInventoryLoading) {
      setState(() {
        _updateInventoryLoading = true;
      });
    } else if (state is GetSummarySuccess) {
      /*
        Get summary
       */
      setState(() {
        _summaryIsLoading = false;
        _summaryResponse = state.items;
      });
    }else if (state is GetInventoryExpenseSuccess) {
      /*
        Get summary
       */
      setState(() {
        _inventoryExpenseIsLoading = false;
        _inventoryExpenseItems = state.materialItems;
      });
    } else if (state is GetSellingSuccess) {
      /*
        Get selling
       */
      setState(() {
        _sellingIsLoading = false;
        _productResponse = state.items;
      });
    }else if (state is GetStockSuccess) {
      /*
        Get stocks
       */
      setState(() {
        _stockIsLoading = false;
        _stockResponse = state.stockResponse;
      });
    }else if (state is GetMaterialSuccess) {
      /*
        Get materials
       */
      setState(() {
        _materialIsLoading = false;
        _materialItems = state.materialItems;
      });
    }else if (state is AddInventoryExpenseSuccess) {
      /*
        Get materials
       */
      setState(() {
        addInventoryExpenseLoading = false;
      });
      bloc.add(GetInventoryExpense(selectedDate));
    }else if (state is DeleteInventoryExpenseSuccess) {
      /*
        Get materials
       */
      setState(() {
        addInventoryExpenseLoading = false;
      });
      bloc.add(GetInventoryExpense(selectedDate));
    }else if (state is GetInventorySuccess) {
      /*
        Get inventories
       */
      setState(() {
        // _inventoryIsLoadng = false;
        _inventoryItems = state.materialItems;
      });
    }else if (state is UpdateInventorySuccess) {
      /*
        update inventories
       */
      setState(() {
        _updateInventoryLoading = false;
      });
      bloc.add(GetInventory(selectedDate));
    }  else if (state is InitialState) {
      setState(() {
        _summaryIsLoading = true;
        _sellingIsLoading = true;
      });
    } else if (state is FailedState) {
      setState(() {
        _summaryIsLoading = false;
        _sellingIsLoading = false;
        _inventoryExpenseIsLoading = false;
        resetData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: const SideMenu(currentPage: "home",),
      ),
      body : BlocListener<DashboardBloc, DashboardState>(
        child: Container(
          padding: EdgeInsets.only(top: kDefaultPadding),
          color: kBgDarkColor,
          child: SafeArea(
            right: false,
            child: Column(
              children: [
                // This is our Seearch bar
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
                      if (!Responsive.isDesktop(context)) const SizedBox(width: 5),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate, // Refer step 1
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null && picked != selectedDate) {
                              setState(() {
                                selectedDate = picked;
                                var formattedDate = DateFormat("dd MMM yyyy").format(selectedDate);
                                dateController = TextEditingController(
                                    text: formattedDate
                                );
                                getData();
                              });
                            }
                          },
                          child: TextField(
                            enabled: false,
                            controller: dateController,
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              hintText: "Tanggal",
                              fillColor: kBgLightColor,
                              filled: true,
                              suffixIcon: Padding(
                                padding: EdgeInsets.all(
                                    kDefaultPadding * 0.75), //15
                                child: Icon(
                                  Icons.calendar_today, size: 24,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                Expanded(
                  child: _summaryIsLoading ? ProgressLoading() :  RefreshIndicator(
                    onRefresh: () async {
                      getData();
                    },
                    child: ListView(
                      children: [
                        SummaryCard(summaryResponse: _summaryResponse,),
                        _inventoryExpenseIsLoading ? ProgressLoading() : InventoryExpense(
                          items: _inventoryExpenseItems,
                          onValueChanges: (location, total){
                            if(location != null){
                              inventoryLocation = location;
                            }

                            if(total != null){
                              inventoryTotal = total;
                            }
                          },
                          press: () {
                            if(inventoryLocation != null && inventoryTotal != null){
                              bloc.add(AddInventoryExpense(selectedDate, inventoryLocation!, inventoryTotal!));
                            }
                          },
                          isLoading: addInventoryExpenseLoading,
                          onDelete: (id){
                            if(id != null){
                              bloc.add(DeleteInventoryExpense(id));
                            }
                          },
                        ),
                        if(_sellingIsLoading) ProgressLoading() else
                        SellingCard(productResponse: _productResponse,),
                        if(_stockIsLoading) ProgressLoading() else
                          StockMilkCard(stockResponse: _stockResponse,),
                        if(_stockIsLoading) ProgressLoading() else
                          StockCupSpicesCard(stockResponse: _stockResponse, isCup : true),
                        if(_stockIsLoading) ProgressLoading() else
                          StockCupSpicesCard(stockResponse: _stockResponse, isCup : false),
                        if(_materialIsLoading) ProgressLoading() else
                          MaterialCard(materialItems : _materialItems),
                        InventoryCard(materialItems : _inventoryItems, onValueChanges: (value, item){
                          _inventoryParams.removeWhere((element) => element.materialId == item.id);
                          _inventoryParams.add(
                            InventoryParam(
                                item.id,
                                DateFormat("yyyy-MM-dd").format(selectedDate),
                                value)
                          );
                        },
                          savePressed: () async {
                            await Future.forEach(_inventoryParams, (element) async {
                              bloc.add(UpdateInventory(element as InventoryParam));
                            });
                            _inventoryParams.clear();
                          },
                            updateLoading: _updateInventoryLoading,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        listener: blocListener,
      )
    );
  }
}
