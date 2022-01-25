import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/services/model/caterory_item_response.dart';
import 'package:maktampos/services/model/selling_detail_response.dart';
import 'package:maktampos/ui/selling/selling_bloc.dart';

class CreateSellingPageContent extends StatefulWidget {
  List<Item> itemProduct;
  SellingDetailResponse? sellingDetailResponse;

  CreateSellingPageContent(this.itemProduct, this.onChange,
      {this.sellingDetailResponse});

  Function onChange;

  @override
  _CreateSellingPageContentState createState() =>
      _CreateSellingPageContentState();
}

class _CreateSellingPageContentState extends State<CreateSellingPageContent> with AutomaticKeepAliveClientMixin<CreateSellingPageContent> {
  late SellingBloc bloc;
  late TextEditingController _soldController;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<SellingBloc>(context);
  }

  String getInitialValue(Item item) {
    String initial = "";
    SellingDetailResponse? sellingDetail = widget.sellingDetailResponse;
    if (sellingDetail != null) {
      sellingDetail.items.forEach((element) {
        if (element.itemId == item.itemId) {
          initial = element.sold.toString();
        }
      });
    }
    return initial;
  }

  List<Widget> generateItems(TextTheme _textTheme) {
    return widget.itemProduct.map((item) {
      _soldController = TextEditingController();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.itemName ?? "",
                style: _textTheme.caption,
              ),
            ),
            Expanded(
              child: TextFormField(
                initialValue: getInitialValue(item),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Terjual",
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  widget.onChange(item.itemId ?? -1, int.parse(value), 10000);
                },
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;

    return ListView(
      children: generateItems(_textTheme),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
