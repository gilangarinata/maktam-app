import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:maktampos/services/model/selling_response.dart';
import 'package:maktampos/ui/login/login_page.dart';
import 'package:maktampos/ui/selling/create/create_selling_page.dart';
import 'package:maktampos/ui/selling/selling_bloc.dart';
import 'package:maktampos/ui/selling/selling_event.dart';
import 'package:maktampos/ui/selling/selling_state.dart';
import 'package:maktampos/utils/my_snackbar.dart';
import 'package:maktampos/utils/number_utils.dart';
import 'package:maktampos/utils/screen_utils.dart';
import 'package:maktampos/utils/time_utils.dart';
import 'package:maktampos/widget/shimmer_loading.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class SellingPage extends StatefulWidget {
  const SellingPage({Key? key}) : super(key: key);

  @override
  _SellingPageState createState() => _SellingPageState();
}

class _SellingPageState extends State<SellingPage> {
  late SellingBloc bloc;
  bool _isLoading = true;
  List<SellingData> sellingData = [];
  SellingResponse? _sellingResponse;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<SellingBloc>(context);
    getSellingData();
  }

  void getSellingData() {
    bloc.add(GetSelling());
  }

  void deleteSelling(String date, int shift) {
    bloc.add(DeleteSelling(shift, date));
  }

  void sellingListener(BuildContext context, SellingState state) async {
    if (state is GetSellingLoading) {
      setState(() {
        print("client:loading");
        _isLoading = true;
      });
    } else if (state is GetSellingSuccess) {
      setState(() {
        _isLoading = false;
        print("client:success");
        sellingData = state.items?.data ?? [];
        _sellingResponse = state.items;
      });
    } else if (state is DeleteSellingLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is DeleteSellingSuccess) {
      setState(() {
        _isLoading = false;
      });
      if (state.items?.success == true) {
        getSellingData();
      } else {
        MySnackbar(context).errorSnackbar(
            state.items?.message ?? "Unknown error : delete selling success");
      }
    } else if (state is InitialState) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
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
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final _textTheme = Theme.of(context).textTheme;
    final _size = MediaQuery.of(context).size;

    Widget buildExpenseFundCard(bool isExpense, double value) {
      return Expanded(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      isExpense ? Icons.north_east : Icons.south_west,
                      color:
                      isExpense ? colorScheme.error : colorScheme.primary,
                      size: 12,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isExpense ? "Pengeluaran" : "Modal",
                      style: _textTheme.caption,
                    ),
                    Text(
                      NumberUtils.toRupiah(value),
                      style: _textTheme.subtitle1
                          ?.copyWith(color: colorScheme.primary),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget buildSellingCard(SellingData? sellingData) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateSellingPage(
                shift: sellingData?.shift,
                date: TimeUtils.toServerDateTime(sellingData?.date),
              ),
            ),
          ).then((value) => getSellingData());
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
                    deleteSelling(TimeUtils.toServerDateTime(sellingData?.date),
                        sellingData?.shift ?? -1);
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
                      TimeUtils.toCommonDateTime(sellingData?.date),
                      style: _textTheme.caption,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      sellingData?.employee ?? "",
                      style: _textTheme.caption,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        (sellingData?.shift ?? 0).toString(),
                        style: _textTheme.caption,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget buildHeaderData() {
      return Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Text(
            "Pendapatan Hari Ini",
            style: _textTheme.caption,
          ),
          Text(
            TimeUtils.toFullDateTime(DateTime.now()),
            style: _textTheme.caption,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            NumberUtils.toRupiah(_sellingResponse?.income?.toDouble() ?? 0.0),
            style: _textTheme.headline5?.copyWith(color: colorScheme.primary),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
            child: Row(
              children: [
                buildExpenseFundCard(
                    false, _sellingResponse?.fund?.toDouble() ?? 0.0),
                buildExpenseFundCard(
                    true, _sellingResponse?.expense?.toDouble() ?? 0.0),
              ],
            ),
          ),
          Padding(
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
                  Expanded(
                    child: Center(
                      child: Text(
                        "Shift",
                        style: _textTheme.subtitle2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.background,
        elevation: 0,
        title: Text(
          'Penjualan',
          style: _textTheme.headline6,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateSellingPage(),
            ),
          ).then((value) => getSellingData());
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: colorScheme.primary,
      ),
      body: BlocListener<SellingBloc, SellingState>(
        listener: sellingListener,
        child: SizedBox(
          width: _size.width,
          child: LazyLoadScrollView(
            onEndOfPage: () => null //bloc.add(GetSelling())
            ,
            child: _isLoading
                ? ShimmerLoading()
                : RefreshIndicator(
                    onRefresh: () async {
                      getSellingData();
                    },
                    child: ListView.builder(
                      itemCount: sellingData.length + 1,
                      itemBuilder: (context, position) {
                        if (position == 0) {
                          return buildHeaderData();
                        } else {
                          SellingData? data = sellingData[position - 1];
                          return buildSellingCard(data);
                        }
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
