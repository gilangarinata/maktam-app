import 'package:flutter/material.dart';
import 'package:maktampos/res/my_colors.dart';
import 'package:maktampos/services/model/stock_detail_response.dart';
import 'package:maktampos/utils/time_utils.dart';

class CreateStockPageContentInformation extends StatefulWidget {
  Function onDateChanged;
  Function onNotesChanged;
  StockDetailResponse? stockDetailResponse;

  @override
  _CreateStockPageContentInformationState createState() =>
      _CreateStockPageContentInformationState();

  CreateStockPageContentInformation(
      {required this.onDateChanged,
      required this.onNotesChanged,
      this.stockDetailResponse});
}

class _CreateStockPageContentInformationState
    extends State<CreateStockPageContentInformation>
    with AutomaticKeepAliveClientMixin<CreateStockPageContentInformation> {
  DateTime selectedDate = DateTime.now();

  late TextEditingController _dateController;
  late TextEditingController _noteController;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget? widget) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: MyColors.primary,
              colorScheme: ColorScheme.light(primary: MyColors.primary),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: widget ?? Container(),
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = TimeUtils.toServerDateTime(selectedDate);
        widget.onDateChanged(TimeUtils.toServerDateTime(selectedDate));
      });
  }

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _noteController = TextEditingController();
    _dateController.text = TimeUtils.toServerDateTime(selectedDate);
    processEditPage();
  }

  void processEditPage() {
    StockDetailResponse? stockDetailResponse = widget.stockDetailResponse;
    if (stockDetailResponse != null) {
      _dateController.text =
          TimeUtils.toServerDateTime(stockDetailResponse.date);
      _noteController.text = stockDetailResponse.notes ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Tanggal',
                  style: _textTheme.bodyText1,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {},
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Catatan',
                  style: _textTheme.bodyText1,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    widget.onNotesChanged(value);
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
