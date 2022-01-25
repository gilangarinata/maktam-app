import 'package:flutter/material.dart';
import 'package:maktampos/utils/number_utils.dart';
import 'package:maktampos/utils/time_utils.dart';

class SellingAdminPage extends StatefulWidget {
  const SellingAdminPage({Key? key}) : super(key: key);

  @override
  _SellingAdminPageState createState() => _SellingAdminPageState();
}

class _SellingAdminPageState extends State<SellingAdminPage> {
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

    Widget buildIncomeBalanceCard(bool isIncome, double value) {
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
                      isIncome ? Icons.attach_money : Icons.money_sharp,
                      color:
                          isIncome ? colorScheme.primary : colorScheme.primary,
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
                      isIncome ? "Pendapatan" : "Saldo",
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
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Text(
            "Omset",
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
            NumberUtils.toRupiah(100000),
            style: _textTheme.headline5?.copyWith(color: colorScheme.primary),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 5.0),
            child: Row(
              children: [
                buildExpenseFundCard(false, 20000),
                buildExpenseFundCard(true, 30000),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0.0),
            child: Row(
              children: [
                buildIncomeBalanceCard(false, 20000),
                buildIncomeBalanceCard(true, 30000),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
