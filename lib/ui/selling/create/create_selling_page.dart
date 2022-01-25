import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/services/model/caterory_item_response.dart';
import 'package:maktampos/services/model/selling_detail_response.dart';
import 'package:maktampos/services/param/selling_param.dart';
import 'package:maktampos/ui/login/login_page.dart';
import 'package:maktampos/ui/selling/create/create_selling_page_content.dart';
import 'package:maktampos/ui/selling/create/create_selling_page_content_information.dart';
import 'package:maktampos/ui/selling/selling_bloc.dart';
import 'package:maktampos/ui/selling/selling_event.dart';
import 'package:maktampos/ui/selling/selling_state.dart';
import 'package:maktampos/utils/my_snackbar.dart';
import 'package:maktampos/utils/number_utils.dart';
import 'package:maktampos/utils/screen_utils.dart';
import 'package:maktampos/utils/time_utils.dart';
import 'package:maktampos/widget/progress_loading.dart';
import 'package:maktampos/widget/shimmer_loading.dart';

class CreateSellingPage extends StatefulWidget {
  int? shift;
  String? date;

  CreateSellingPage({this.shift, this.date});

  @override
  _CreateSellingPageState createState() => _CreateSellingPageState();
}

class _CreateSellingPageState extends State<CreateSellingPage> {
  bool _isLoading = false;
  bool _createLoading = false;
  List<CategoryItemResponse> _categoryItems = [];
  final List<ItemDataParam> _itemDataParams = [];
  SellingParams _sellingParams = SellingParams();
  late SellingBloc bloc;
  SellingDetailResponse? _sellingDetailResponse;
  int income = 0;

  void initData() {
    setState(() {
      _sellingParams = _sellingParams.copyWith(
          date: TimeUtils.toServerDateTime(DateTime.now()), shift: 1);
    });
  }

  void updateSellingParam() {
    if (_sellingDetailResponse != null) {
      _sellingParams = _sellingParams.copyWith(
          id: _sellingDetailResponse?.id,
          date: TimeUtils.toServerDateTime(_sellingDetailResponse?.date),
          shift: _sellingDetailResponse?.shift,
          fund: _sellingDetailResponse?.fund,
          expense: _sellingDetailResponse?.expense,
          note: _sellingDetailResponse?.notes);
    }
  }

  @override
  void initState() {
    super.initState();
    initData();
    bloc = BlocProvider.of<SellingBloc>(context);
    bloc.add(GetCategoriesItems());
  }

  void getSellingDetail() {
    if (widget.shift != null && widget.date != null) {
      bloc.add(GetSellingDetail(widget.shift!, widget.date!));
    }
  }

  void countIncome() {
    if (widget.shift == null) {
      var itemDataParams = _sellingParams.data;
      if (itemDataParams != null) {
        int sum = itemDataParams
            .map((e) => e.price * e.sold)
            .toList()
            .fold(0, (p, c) => p + c);
        setState(() {
          income = sum;
        });
      }
    }
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
        CreateSellingPageContentInformation(
          sellingDetailResponse: _sellingDetailResponse,
          onDateChanged: (String date) {
            setState(() {
              _sellingParams = _sellingParams.copyWith(date: date);
            });
          },
          onExpenseChanged: (int expense) {
            setState(() {
              _sellingParams = _sellingParams.copyWith(expense: expense);
            });
          },
          onFundChanged: (int fund) {
            setState(() {
              _sellingParams = _sellingParams.copyWith(fund: fund);
            });
          },
          onNotesChanged: (String notes) {
            setState(() {
              _sellingParams = _sellingParams.copyWith(note: notes);
            });
          },
          onShiftChanged: (int shift) {
            setState(() {
              _sellingParams = _sellingParams.copyWith(shift: shift);
            });
          },
        )
      ];
      List<Widget> tabContents = _categoryItems
          .map(
            (item) => CreateSellingPageContent(
              item.items ?? [],
              (id, value, price) {
                var itemDataParam = ItemDataParam(id, value, price);
                _itemDataParams.removeWhere((element) => element.itemId == id);
                _itemDataParams.add(itemDataParam);
                setState(() {
                  _sellingParams =
                      _sellingParams.copyWith(data: _itemDataParams);
                });

                countIncome();
              },
              sellingDetailResponse: _sellingDetailResponse,
            ),
          )
          .toList();

      allTabContentsWithInfo.addAll(tabContents);
      return allTabContentsWithInfo;
    }

    return Scaffold(
      body: BlocListener<SellingBloc, SellingState>(
        listener: (context, state) {
          if (state is GetCategoriesItemLoading) {
            setState(() {
              _isLoading = true;
            });
          }
          if (state is GetDetailSellingLoading) {
            setState(() {
              _isLoading = true;
            });
          }
          if (state is GetDetailSellingSuccess) {
            setState(() {
              _isLoading = false;
              _sellingDetailResponse = state.items;
              income = _sellingDetailResponse?.income ?? 0;
              updateSellingParam();
            });
          } else if (state is GetCategoriesItemSuccess) {
            setState(() {
              _isLoading = false;
              _categoryItems = state.items ?? [];
              getSellingDetail();
            });
          } else if (state is CreateUpdateSellingLoading) {
            setState(() {
              _createLoading = true;
            });
          } else if (state is CreateUpdateSellingSuccess) {
            if (state.items?.success == true) {
              Navigator.pop(context);
            } else {
              MySnackbar(context).errorSnackbar(state.items?.message ?? "");
            }
            setState(() {
              _createLoading = false;
              _isLoading = false;
            });
          } else if (state is FailedState) {
            setState(() {
              _isLoading = false;
              _createLoading = false;
            });
            if (state.code == 401) {
              MySnackbar(context)
                  .errorSnackbar("Sesi anda habis, silahkan login ulang");
              ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
              return;
            }

            MySnackbar(context)
                .errorSnackbar(state.message + " : " + state.code.toString());
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
                  'Tambah Penjualan',
                  style: _textTheme.bodyText2,
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                width: _size.width,
                child: _createLoading
                    ? ProgressLoading()
                    : Container(
                        height: 90,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("Pendapatan : "),
                                Spacer(),
                                Text(NumberUtils.toRupiah(income.toDouble())),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (widget.shift == null) {
                                  //create STATE
                                  if (_sellingParams.isCreateValidate()) {
                                    bloc.add(InsertSelling(_sellingParams));
                                  } else {
                                    MySnackbar(context).errorSnackbar(
                                        "Mohon periksa kembali data anda");
                                  }
                                } else {
                                  if (_sellingParams.isUpdateValidate()) {
                                    bloc.add(UpdateSelling(_sellingParams));
                                  } else {
                                    MySnackbar(context).errorSnackbar(
                                        "Mohon periksa kembali data anda / id null");
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
                          ],
                        ),
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
