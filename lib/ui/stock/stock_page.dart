import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:maktampos/services/model/stock_response.dart';
import 'package:maktampos/ui/login/login_page.dart';
import 'package:maktampos/ui/stock/create/create_stock_page.dart';
import 'package:maktampos/ui/stock/stock_bloc.dart';
import 'package:maktampos/ui/stock/stock_event.dart';
import 'package:maktampos/ui/stock/stock_state.dart';
import 'package:maktampos/utils/my_snackbar.dart';
import 'package:maktampos/utils/screen_utils.dart';
import 'package:maktampos/utils/time_utils.dart';
import 'package:maktampos/widget/progress_loading.dart';
import 'package:maktampos/widget/shimmer_loading.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class StockPage extends StatefulWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late StockBloc bloc;
  bool _isLoading = true;
  bool _paginationLoading = false;
  int page = 1;
  StockResponse? _stockResponse;
  List<StockData> _stockItems = [];

  void getStocks(bool isPagination) {
    if (isPagination) {
      String? nextPageUrl = _stockResponse?.items?.nextPageUrl;
      if (nextPageUrl != null) {
        int indexPage = nextPageUrl.indexOf("page=");
        String nextPageStr =
            nextPageUrl.substring(indexPage + 5, nextPageUrl.length);
        int? nextPage = int.tryParse(nextPageStr);
        if (nextPage != null) {
          page = nextPage;
          bloc.add(GetStocks(page));
        }
      }
    } else {
      page = 1;
      bloc.add(GetStocks(1));
    }
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<StockBloc>(context);
    getStocks(false);
  }

  void blocListener(BuildContext context, StockState state) async {
    if (state is GetStockLoading) {
      setState(() {
        if (page > 1) {
          _paginationLoading = true;
        } else {
          _isLoading = true;
        }
      });
    } else if (state is GetStockSuccess) {
      setState(() {
        if (page > 1) {
          _paginationLoading = false;
          _stockItems.addAll(state.items?.items?.data ?? []);
        } else {
          _isLoading = false;
          _stockItems = state.items?.items?.data ?? [];
        }
        _stockResponse = state.items;
      });
    } else if (state is DeleteStockLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is DeleteStockSuccess) {
      if (state.items?.success == true) {
        getStocks(false);
      } else {
        MySnackbar(context).errorSnackbar(state.items?.message ?? "");
      }
      setState(() {
        _isLoading = false;
      });
    } else if (state is InitialState) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is FailedState) {
      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
      if (state.code == 401) {
        ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
      }
      setState(() {
        _isLoading = false;
        _paginationLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final _textTheme = Theme.of(context).textTheme;
    final _size = MediaQuery.of(context).size;

    Widget buildStockCard(StockData? stockItem) {
      return InkWell(
        onTap: () {
          ScreenUtils(context).navigateTo(
              CreateStockPage(
                date: TimeUtils.toServerDateTime(stockItem?.createdAt),
              ), listener: (value) {
            if (value == 200) {
              getStocks(false);
            }
          });
        },
        onLongPress: () {
          Dialogs.materialDialog(
              msg: 'Apakah anda yakin ? data akan hilang sepenuhnya',
              title: "Hapus",
              color: Colors.white,
              context: context,
              actions: [
                IconsOutlineButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Batal',
                  iconData: Icons.cancel_outlined,
                  textStyle: TextStyle(color: Colors.grey),
                  iconColor: Colors.grey,
                ),
                IconsButton(
                  onPressed: () {
                    bloc.add(DeleteStock(
                        TimeUtils.toServerDateTime(stockItem?.createdAt)));
                    Navigator.pop(context);
                  },
                  text: 'Hapus',
                  iconData: Icons.delete,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ]);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      TimeUtils.toCommonDateTime(stockItem?.createdAt),
                      style: _textTheme.caption,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      stockItem?.name ?? "",
                      style: _textTheme.caption,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget buildHeaders() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Tanggal",
                  style: _textTheme.subtitle2,
                ),
              ),
              Expanded(
                child: Text(
                  "Karyawan",
                  style: _textTheme.subtitle2,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.background,
        elevation: 0,
        title: Text(
          'Stock',
          style: _textTheme.headline6,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: buildHeaders(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScreenUtils(context).navigateTo(CreateStockPage(), listener: (value) {
            if (value == 200) {
              getStocks(false);
            }
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: colorScheme.primary,
      ),
      body: BlocListener<StockBloc, StockState>(
        listener: blocListener,
        child: SizedBox(
          width: _size.width,
          child: LazyLoadScrollView(
            onEndOfPage: () {
              getStocks(true);
            },
            isLoading: _paginationLoading,
            child: _isLoading
                ? ShimmerLoading()
                : Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          getStocks(false);
                        },
                        child: ListView.builder(
                          itemCount: _stockItems.length,
                          itemBuilder: (context, position) {
                            StockData? data = _stockItems[position];
                            return buildStockCard(data);
                          },
                        ),
                      ),
                      Visibility(
                          visible: _paginationLoading, child: ProgressLoading())
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
