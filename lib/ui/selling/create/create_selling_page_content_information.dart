import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/res/my_colors.dart';
import 'package:maktampos/services/model/selling_detail_response.dart';
import 'package:maktampos/ui/selling/selling_bloc.dart';
import 'package:maktampos/utils/time_utils.dart';

class CreateSellingPageContentInformation extends StatefulWidget {
  Function onDateChanged;
  Function onShiftChanged;
  Function onFundChanged;
  Function onExpenseChanged;
  Function onNotesChanged;
  SellingDetailResponse? sellingDetailResponse;

  @override
  _CreateSellingPageContentInformationState createState() =>
      _CreateSellingPageContentInformationState();

  CreateSellingPageContentInformation(
      {Key? key,
      required this.onDateChanged,
      required this.onShiftChanged,
      required this.onFundChanged,
      required this.onExpenseChanged,
      required this.onNotesChanged,
      this.sellingDetailResponse})
      : super(key: key);
}

class _CreateSellingPageContentInformationState extends State<CreateSellingPageContentInformation> with AutomaticKeepAliveClientMixin<CreateSellingPageContentInformation> {
  DateTime selectedDate = DateTime.now();

  late TextEditingController _dateController;
  late TextEditingController _fundController;
  late TextEditingController _expenseController;
  late TextEditingController _noteController;

  bool isShift2 = false;

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

  String _currentSelectedShiftValue = "Shift 1";

  var _currencies = [
    "Shift 1",
    "Shift 2",
  ];

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _fundController = TextEditingController();
    _expenseController = TextEditingController();
    _noteController = TextEditingController();
    _dateController.text = TimeUtils.toServerDateTime(selectedDate);
    processEditPage();
  }

  void processEditPage() {
    SellingDetailResponse? sellingDetailResponse = widget.sellingDetailResponse;
    if (sellingDetailResponse != null) {
      _dateController.text =
          TimeUtils.toServerDateTime(sellingDetailResponse.date);
      _currentSelectedShiftValue =
          "Shift " + (sellingDetailResponse.shift ?? 1).toString();
      _fundController.text = sellingDetailResponse.fund.toString();
      _expenseController.text = sellingDetailResponse.expense.toString();
      _noteController.text = sellingDetailResponse.notes ?? "";
      setState(() {
        if (sellingDetailResponse.shift == 1) {
          isShift2 = false;
        } else {
          isShift2 = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SellingBloc>(context);
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
                  'Shift',
                  style: _textTheme.bodyText1,
                ),
              ),
              Expanded(child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        hintText: 'Please select expense',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    isEmpty: _currentSelectedShiftValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentSelectedShiftValue,
                        isDense: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _currentSelectedShiftValue = newValue ?? "1";
                            state.didChange(newValue);
                            if (newValue == _currencies[0]) {
                              widget.onShiftChanged(1);
                              isShift2 = false;
                            } else if (newValue == _currencies[1]) {
                              widget.onShiftChanged(2);
                              isShift2 = true;
                            }
                          });
                        },
                        items: _currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
        Visibility(
          visible: isShift2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Modal',
                    style: _textTheme.bodyText1,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _fundController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      widget.onFundChanged(int.parse(value));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: isShift2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Pengeluaran',
                    style: _textTheme.bodyText1,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _expenseController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      widget.onExpenseChanged(int.parse(value));
                    },
                  ),
                )
              ],
            ),
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
