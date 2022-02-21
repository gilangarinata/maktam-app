import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/services/model/caterory_item_response.dart';
import 'package:maktampos/services/model/stock_detail_response.dart';
import 'package:maktampos/services/param/stock_param.dart';
import 'package:maktampos/ui/login/login_page.dart';
import 'package:maktampos/ui/stock/create/create_stock_page_content.dart';
import 'package:maktampos/ui/stock/create/create_stock_page_content_information.dart';
import 'package:maktampos/ui/stock/stock_bloc.dart';
import 'package:maktampos/ui/stock/stock_event.dart';
import 'package:maktampos/utils/my_snackbar.dart';
import 'package:maktampos/utils/number_utils.dart';
import 'package:maktampos/utils/screen_utils.dart';
import 'package:maktampos/utils/time_utils.dart';
import 'package:maktampos/widget/progress_loading.dart';
import 'package:maktampos/widget/shimmer_loading.dart';

import '../stock_state.dart';

class CreateStockPage extends StatefulWidget {
  String? date;

  CreateStockPage({Key? key, this.date}) : super(key: key);

  @override
  _CreateStockPageState createState() => _CreateStockPageState();
}

class _CreateStockPageState extends State<CreateStockPage> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _createLoading = false;
  List<CategoryItemResponse> _categoryItems = [];
  StockParam _stockParam = StockParam();
  StockDetailResponse? _stockDetailResponse;

  final List<MilkParam> _itemMilks = [];
  final List<MilkPlaceParam> _itemMilkPlace = [];
  final List<SpicesOrCupParam> _itemSpices = [];
  final List<SpicesOrCupParam> _itemCups = [];

  var soldTotal = 0;
  var deliveryTotal = 0;

  // late TabController controller;

  late StockBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<StockBloc>(context);

    initStockParam();
    getStockDetails();
  }

  void getStockDetails() {
    if (widget.date != null) {
      bloc.add(GetStockDetails(widget.date ?? ""));
    } else {
      bloc.add(GetCategoriesItems());
    }
  }

  void initStockParam() {
    _stockParam =
        _stockParam.copyWith(date: TimeUtils.toServerDateTime(DateTime.now()));
  }

  void countIncome() {
    int sum = _itemMilks.where((element) => element.itemId == 25 || element.itemId == 26 || element.itemId == 27)
        .map((e) => e.stock ?? 0)
        .toList()
        .fold(0, (p, c) => p + c);

    int minus = _itemMilks.where((element) => element.itemId == 28 || element.itemId == 29)
        .map((e) => e.stock ?? 0)
        .toList()
        .fold(0, (p, c) => p + c);

    int sumMilkPlaceReceived = _itemMilkPlace
        .where((element) => element.type == "receive")
        .map((e) => e.stock ?? 0)
        .toList()
        .fold(0, (p, c) => p + c);

    int sumMilkPlaceTake = _itemMilkPlace
        .where((element) => element.type == "take")
        .map((e) => e.stock ?? 0)
        .toList()
        .fold(0, (p, c) => p + c);

    setState(() {
      soldTotal = sum + sumMilkPlaceReceived - sumMilkPlaceTake - minus;
    });
  }

  void countDelivery() {
    int? standard = _categoryItems.first.items?.where((element) => element.itemId == 25) //id susu datang
        .first.standard;

    int sumLeft = _itemMilks
        .where((element) => element.itemId == 28 || element.itemId == 29) //id sisa matang & id sisa mentah
        .map((e) => e.stock ?? 0)
        .toList()
        .fold(0, (p, c) => p + c);

    print("standart: $standard  left: $sumLeft");

    setState(() {
      deliveryTotal = (standard ?? 0) - sumLeft;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final _textTheme = Theme.of(context).textTheme;
    final _size = MediaQuery.of(context).size;

    List<Widget> generateTabs() {
      List<Widget> allTabsWithInfo = [
        Tab(
          child: Text(
            'Informasi',
            style: _textTheme.bodyText2,
          ),
        ),
      ];
      List<Widget> tabs = _categoryItems
          .map((item) => Tab(
                child: Text(
                  item.categoryName ?? "",
                  style: _textTheme.bodyText2,
                ),
              ))
          .toList();

      allTabsWithInfo.addAll(tabs);
      return allTabsWithInfo;
    }

    List<Widget> generateTabsContent() {
      List<Widget> allTabContentsWithInfo = [
        CreateStockPageContentInformation(
          onDateChanged: (String date) {
            _stockParam = _stockParam.copyWith(date: date);
          },
          onNotesChanged: (String notes) {
            _stockParam = _stockParam.copyWith(notes: notes);
          },
          stockDetailResponse: _stockDetailResponse,
        )
      ];
      List<Widget> tabContents = _categoryItems
          .map((item) => CreateStockPageContent(
                (milkplaces) {
                  _itemMilkPlace.clear();
                  _itemMilkPlace.addAll(milkplaces);
                  _stockParam = _stockParam.copyWith(milkPlace: _itemMilkPlace);
                  countIncome();
                  countDelivery();
                },
                item.categoryId,
                item.items ?? [],
                (ItemId, value, itemPlaces, id) {
                  //susu
                  if (ItemId != null && value != null) {
                    var itemMilkParam =
                        MilkParam(itemId: ItemId, stock: value, id: id);
                    _itemMilks
                        .removeWhere((element) => element.itemId == ItemId);
                    _itemMilks.add(itemMilkParam);
                    _stockParam = _stockParam.copyWith(milk: _itemMilks);
                    countIncome();
                    countDelivery();
          }
        },
            (itemId, stock, sold, id) {
          //spices
          if (itemId != null && stock != null && sold != null) {
            var itemSpicesParam = SpicesOrCupParam(
                itemId: itemId, stock: stock, sold: sold, id: id);
            _itemSpices
                .removeWhere((element) => element.itemId == itemId);
            _itemSpices.add(itemSpicesParam);
            _stockParam = _stockParam.copyWith(spices: _itemSpices);
          }
        },
            (itemId, stock, sold, id) {
          //cup
          if (itemId != null && stock != null && sold != null) {
            var itemCupsParam = SpicesOrCupParam(
                itemId: itemId, stock: stock, sold: sold, id: id);
            _itemCups
                .removeWhere((element) => element.itemId == itemId);
            _itemCups.add(itemCupsParam);
            _stockParam = _stockParam.copyWith(cup: _itemCups);
          }
        },
        stockDetailResponse: _stockDetailResponse,
              ))
          .toList();
      allTabContentsWithInfo.addAll(tabContents);
      return allTabContentsWithInfo;
    }

    return Scaffold(
      body: BlocListener<StockBloc, StockState>(
        listener: (context, state) {
          if (state is GetCategoriesItemLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is GetCategoriesItemSuccess) {
            setState(() {
              _isLoading = false;
              _categoryItems = state.items ?? [];
            });
          } else if (state is FailedState) {
            setState(() {
              _isLoading = false;
            });
            if (state.code == 401) {
              ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
            }
            MySnackbar(context).errorSnackbar(state.message);
          } else if (state is CreateUpdateStockSuccess) {
            setState(() {
              _createLoading = false;
            });
            if (state.items?.success == true) {
              Navigator.pop(context, 200);
            } else {
              MySnackbar(context).errorSnackbar(
                  state.items?.message ?? "Unknown error : CreateUpdateStock");
            }
          } else if (state is CreateUpdateStockLoading) {
            setState(() {
              _createLoading = true;
            });
          } else if (state is GetStockDetailLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is GetStockDetailSuccess) {
            setState(() {
              _isLoading = false;
              _stockDetailResponse = state.items;
              _stockParam = _stockParam.copyWith(
                  notes: _stockDetailResponse?.notes,
                  date: TimeUtils.toServerDateTime(
                    _stockDetailResponse?.date,
                  ));
              _itemMilks.addAll(
                _stockDetailResponse?.milk?.map((e) => e.toMilkParam()).toList() ?? []
              );
              _itemMilkPlace.addAll(
                  _stockDetailResponse?.milkPlace?.map((e) => e.toParam()).toList() ?? []
              );
              _itemCups.addAll(
                  _stockDetailResponse?.cups?.map((e) => e.toSpicesOrCupParam()).toList() ?? []
              );
              _itemSpices.addAll(
                  _stockDetailResponse?.spices?.map((e) => e.toSpicesOrCupParam()).toList() ?? []
              );

              bloc.add(GetCategoriesItems());
              countIncome();
              countDelivery();
            });
          }
        },
        child: DefaultTabController(
          length: _categoryItems.length + 1,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(120.0),
              child: AppBar(
                leading: BackButton(color: Colors.black),
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: colorScheme.background,
                elevation: 0,
                bottom: PreferredSize(
                    child: TabBar(
                        isScrollable: true,
                        unselectedLabelColor:
                            colorScheme.primary.withOpacity(0.3),
                        indicatorColor: colorScheme.primary,
                        tabs: generateTabs()),
                    preferredSize: Size.fromHeight(30.0)),
                title: Text(
                  'Tambah Stok',
                  style: _textTheme.bodyText2,
                ),
              ),
            ),
            bottomNavigationBar: SizedBox(
              width: _size.width,
              child: _createLoading
                  ? ProgressLoading()
                  : Container(
                padding: const EdgeInsets.all(18.0),
                color: Colors.white,
                    height: 130,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Stok Terjual Susu: "),
                            Spacer(),
                            Text(soldTotal.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Pengiriman Susu: "),
                            Spacer(),
                            Text(deliveryTotal.toString()),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (widget.date != null) {
                                      if (_stockParam.isValid()) {
                                        bloc.add(UpdateStock(_stockParam));
                                      }
                                    } else {
                                      if (_stockParam.isValid()) {
                                        bloc.add(InsertStock(_stockParam));
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Simpan",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.apply(color: Colors.white),
                                  ),
                                ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            ),
            body: _isLoading
                ? ShimmerLoading()
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TabBarView(children: generateTabsContent()),
                  ),
          ),
        ),
      ),
    );
  }
}
