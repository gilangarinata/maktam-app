import 'package:flutter/material.dart';
import 'package:maktampos/services/model/caterory_item_response.dart';
import 'package:maktampos/services/model/stock_detail_response.dart';
import 'package:maktampos/services/param/stock_param.dart';

class CreateStockPageContent extends StatefulWidget {
  List<Item> itemProduct;
  StockDetailResponse? stockDetailResponse;
  int? categoryId;

  CreateStockPageContent(
      this.onMilkPlaceChange,
      this.categoryId,
      this.itemProduct,
      this.onMilkChange,
      this.onSpicesChange,
      this.onCupChange,
      {this.stockDetailResponse});

  Function(List<MilkPlaceParam>) onMilkPlaceChange;
  Function onMilkChange;
  Function onSpicesChange;
  Function onCupChange;

  @override
  _CreateStockPageContentState createState() => _CreateStockPageContentState();
}

class _CreateStockPageContentState extends State<CreateStockPageContent>
    with AutomaticKeepAliveClientMixin<CreateStockPageContent> {
  late final List<MilkPlace> _milkPlacesTake = [];
  final List<MilkPlace> _milkPlacesReceive = [];

  int MILK_CATEGORY_ID = 20;
  int SPICES_CATEGORY_ID = 22;
  int CUP_CATEGORY_ID = 21;

  List<Widget> generateItems(TextTheme _textTheme) {
    List<Widget> items = widget.itemProduct.map((item) {
      int stock = 0;
      int sold = 0;
      TextEditingController _leftController = TextEditingController();
      getInitialLeftValue(item, _leftController);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.itemName ?? "",
                    style: _textTheme.caption,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: getInitialStockValue(item),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Stok",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          stock = int.tryParse(value) ?? 0;
                          int? id = getInitialStockId(item);
                          if (widget.categoryId == MILK_CATEGORY_ID) {
                            widget.onMilkChange(
                                item.itemId ?? -1, stock, null, id);
                          } else if (widget.categoryId == SPICES_CATEGORY_ID) {
                            widget.onSpicesChange(
                                item.itemId ?? -1, stock, sold, id);
                          } else if (widget.categoryId == CUP_CATEGORY_ID) {
                            widget.onCupChange(
                                item.itemId ?? -1, stock, sold, id);
                          }
                          _leftController.text = (stock - sold).toString();
                        },
                      ),
                      Visibility(
                          visible: widget.categoryId != MILK_CATEGORY_ID,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                initialValue: getInitialSoldValue(item),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Terjual",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  int? id = getInitialStockId(item);
                                  sold = int.tryParse(value) ?? 0;
                                  if (widget.categoryId == SPICES_CATEGORY_ID) {
                                    widget.onSpicesChange(
                                        item.itemId ?? -1, stock, sold, id);
                                  } else if (widget.categoryId ==
                                      CUP_CATEGORY_ID) {
                                    widget.onCupChange(
                                        item.itemId ?? -1, stock, sold, id);
                                  }
                                  _leftController.text =
                                      (stock - sold).toString();
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _leftController,
                                enabled: false,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Sisa",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  int? id = getInitialStockId(item);
                                  if (widget.categoryId == SPICES_CATEGORY_ID) {
                                    widget.onSpicesChange(
                                        item.itemId ?? -1, stock, sold, id);
                                  } else if (widget.categoryId ==
                                      CUP_CATEGORY_ID) {
                                    widget.onCupChange(
                                        item.itemId ?? -1, stock, sold, id);
                                  }
                                },
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
            const Divider(
              thickness: 1,
            )
          ],
        ),
      );
    }).toList();

    if (widget.categoryId == MILK_CATEGORY_ID) {
      items.add(buildMilkPlace());
    }

    return items;
  }

  List<Widget> buildMilkPlaceReceiveTextInput() {
    int pos = 0;
    return _milkPlacesReceive.map((milkPlace) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: milkPlace.place ?? "",
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Tempat",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  milkPlace.type = "receive";
                  milkPlace.place = value;
                  List<MilkPlaceParam> milkPlaceParams = [];
                  var newListReceive = _milkPlacesReceive
                      .where((element) =>
                          element.place != null &&
                          element.stock != null &&
                          element.type != null)
                      .toList();
                  var newListTake = _milkPlacesTake
                      .where((element) =>
                          element.place != null &&
                          element.stock != null &&
                          element.type != null)
                      .toList();
                  milkPlaceParams
                      .addAll(newListReceive.map((e) => e.toParam()));
                  milkPlaceParams.addAll(newListTake.map((e) => e.toParam()));
                  widget.onMilkPlaceChange(milkPlaceParams);
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                initialValue: (milkPlace.stock ?? 0).toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Jumlah",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  milkPlace.type = "receive";
                  milkPlace.stock = int.tryParse(value) ?? 0;
                  List<MilkPlaceParam> milkPlaceParams = [];
                  var newListReceive = _milkPlacesReceive
                      .where((element) =>
                          element.place != null &&
                          element.stock != null &&
                          element.type != null)
                      .toList();
                  var newListTake = _milkPlacesTake
                      .where((element) =>
                          element.place != null &&
                          element.stock != null &&
                          element.type != null)
                      .toList();
                  milkPlaceParams
                      .addAll(newListReceive.map((e) => e.toParam()));
                  milkPlaceParams.addAll(newListTake.map((e) => e.toParam()));
                  print("milk p : " + milkPlaceParams.length.toString());
                  widget.onMilkPlaceChange(milkPlaceParams);
                },
              ),
            )
          ],
        ),
      );
      pos++;
    }).toList();
  }

  List<Widget> buildMilkPlaceTakeTextInput() {
    return _milkPlacesTake
        .map((milkPlace) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: milkPlace.place ?? "",
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Tempat",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        milkPlace.type = "take";
                        milkPlace.place = value;
                        List<MilkPlaceParam> milkPlaceParams = [];
                        var newListReceive = _milkPlacesReceive
                            .where((element) =>
                                element.place != null &&
                                element.stock != null &&
                                element.type != null)
                            .toList();
                        var newListTake = _milkPlacesTake
                            .where((element) =>
                                element.place != null &&
                                element.stock != null &&
                                element.type != null)
                            .toList();
                        milkPlaceParams
                            .addAll(newListReceive.map((e) => e.toParam()));
                        milkPlaceParams
                            .addAll(newListTake.map((e) => e.toParam()));

                        print("milk param" + milkPlaceParams.length.toString());
                        widget.onMilkPlaceChange(milkPlaceParams);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: (milkPlace.stock ?? 0).toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Jumlah",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        milkPlace.type = "take";
                        milkPlace.stock = int.tryParse(value) ?? 0;
                        List<MilkPlaceParam> milkPlaceParams = [];
                        var newListReceive = _milkPlacesReceive
                            .where((element) =>
                                element.place != null &&
                                element.stock != null &&
                                element.type != null)
                            .toList();
                        var newListTake = _milkPlacesTake
                            .where((element) =>
                                element.place != null &&
                                element.stock != null &&
                                element.type != null)
                            .toList();
                        milkPlaceParams
                            .addAll(newListReceive.map((e) => e.toParam()));
                        milkPlaceParams
                            .addAll(newListTake.map((e) => e.toParam()));
                        widget.onMilkPlaceChange(milkPlaceParams);
                      },
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  Widget buildMilkPlace() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text("Stok Dari"),
            SizedBox(
              height: 10,
            ),
            Column(
              children: buildMilkPlaceReceiveTextInput(),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _milkPlacesReceive.add(MilkPlace());
                });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
              ),
              child: const Text("Tambah"),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Stock Diambil"),
            SizedBox(
              height: 10,
            ),
            Column(
              children: buildMilkPlaceTakeTextInput(),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _milkPlacesTake.add(MilkPlace());
                });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
              ),
              child: const Text("Tambah"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setupEdit();
  }

  String getInitialStockValue(Item item) {
    String initial = "";
    StockDetailResponse? stockDetailResponse = widget.stockDetailResponse;
    if (stockDetailResponse != null) {
      if (widget.categoryId == MILK_CATEGORY_ID) {
        stockDetailResponse.milk?.forEach((element) {
          if (element.itemId == item.itemId) {
            initial = element.stock.toString();
          }
        });
      } else if (widget.categoryId == SPICES_CATEGORY_ID) {
        stockDetailResponse.spices?.forEach((element) {
          if (element.itemId == item.itemId) {
            initial = element.stock.toString();
          }
        });
      } else if (widget.categoryId == CUP_CATEGORY_ID) {
        stockDetailResponse.cups?.forEach((element) {
          if (element.itemId == item.itemId) {
            initial = element.stock.toString();
          }
        });
      }
    }
    return initial;
  }

  int? getInitialStockId(Item item) {
    int? initial;
    StockDetailResponse? stockDetailResponse = widget.stockDetailResponse;
    if (stockDetailResponse != null) {
      if (widget.categoryId == MILK_CATEGORY_ID) {
        stockDetailResponse.milk?.forEach((element) {
          if (element.itemId == item.itemId) {
            initial = element.id;
          }
        });
      } else if (widget.categoryId == SPICES_CATEGORY_ID) {
        stockDetailResponse.spices?.forEach((element) {
          if (element.itemId == item.itemId) {
            initial = element.id;
          }
        });
      } else if (widget.categoryId == CUP_CATEGORY_ID) {
        stockDetailResponse.cups?.forEach((element) {
          if (element.itemId == item.itemId) {
            initial = element.id;
          }
        });
      }
    }
    return initial;
  }

  String getInitialSoldValue(Item item) {
    String initial = "";
    StockDetailResponse? stockDetailResponse = widget.stockDetailResponse;
    if (stockDetailResponse != null) {
      if (widget.categoryId == SPICES_CATEGORY_ID) {
        stockDetailResponse.spices?.forEach((element) {
          if (element.itemId == item.itemId) {
            initial = element.sold.toString();
          }
        });
      } else if (widget.categoryId == CUP_CATEGORY_ID) {
        stockDetailResponse.cups?.forEach((element) {
          if (element.itemId == item.itemId) {
            initial = element.sold.toString();
          }
        });
      }
    }
    return initial;
  }

  void getInitialLeftValue(Item item, TextEditingController controller) {
    String initial = "";
    StockDetailResponse? stockDetailResponse = widget.stockDetailResponse;
    if (stockDetailResponse != null) {
      if (widget.categoryId == SPICES_CATEGORY_ID) {
        stockDetailResponse.spices?.forEach((element) {
          if (element.itemId == item.itemId) {
            initial = element.lefts.toString();
          }
        });
      } else if (widget.categoryId == CUP_CATEGORY_ID) {
        stockDetailResponse.cups?.forEach((element) {
          if (element.itemId == item.itemId) {
            initial = element.lefts.toString();
          }
        });
      }
    }
    controller.text = initial;
  }

  void setupEdit() {
    StockDetailResponse? stockDetailResponse = widget.stockDetailResponse;
    if (stockDetailResponse != null) {
      _milkPlacesTake.addAll(stockDetailResponse.milkPlace
              ?.toList()
              .where((element) => element.type == "take") ??
          []);
      _milkPlacesReceive.addAll(stockDetailResponse.milkPlace
              ?.toList()
              .where((element) => element.type == "receive") ??
          []);
    }
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
