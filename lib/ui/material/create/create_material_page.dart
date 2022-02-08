import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/services/model/material_detail_response.dart';
import 'package:maktampos/services/model/material_item_response.dart';
import 'package:maktampos/services/param/material_param.dart';
import 'package:maktampos/ui/login/login_page.dart';
import 'package:maktampos/ui/material/create/create_material_page_content.dart';
import 'package:maktampos/ui/material/create/create_material_page_content_information.dart';
import 'package:maktampos/ui/material/material_bloc.dart';
import 'package:maktampos/ui/material/material_event.dart';
import 'package:maktampos/ui/material/material_state.dart';
import 'package:maktampos/utils/my_snackbar.dart';
import 'package:maktampos/utils/screen_utils.dart';
import 'package:maktampos/utils/time_utils.dart';
import 'package:maktampos/widget/progress_loading.dart';
import 'package:maktampos/widget/shimmer_loading.dart';

class CreateMaterialPage extends StatefulWidget {
  String? date;

  CreateMaterialPage({Key? key, this.date}) : super(key: key);

  @override
  _CreateMaterialPageState createState() => _CreateMaterialPageState();
}

class _CreateMaterialPageState extends State<CreateMaterialPage> {
  bool _isLoading = false;
  bool _createIsLoading = false;
  MaterialParam _materialParam = MaterialParam();
  final List<MaterialItemParam> _itemDataParams = [];
  MaterialDetailResponse? _materialDetailResponse;
  List<MaterialItem> materialItems = [];
  late MaterialBloc bloc;

  @override
  void initState() {
    super.initState();
    initData();
    bloc = BlocProvider.of<MaterialBloc>(context);
    getDetailData();
    bloc.add(GetMaterialItems());
  }

  void getDetailData() {
    var date = widget.date;
    if (date != null) {
      bloc.add(GetMaterialDetails(date));
    }
  }

  void initData() {
    setState(() {
      _materialParam = _materialParam.copyWith(
          date: widget.date ?? TimeUtils.toServerDateTime(DateTime.now()));
    });
  }

  late CreateMaterialPageContent materialPageContent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final _textTheme = Theme.of(context).textTheme;
    final _size = MediaQuery.of(context).size;

    materialPageContent = CreateMaterialPageContent(
      materialDetailResponse: _materialDetailResponse,
      materialItems: materialItems,
    );

    List<Widget> generateTabs() {
      List<Widget> allTabsWithInfo = [
        Tab(
          child: Text(
            'Informasi',
            style: _textTheme.bodyText2,
          ),
        ),
        Tab(
          child: Text(
            'Material',
            style: _textTheme.bodyText2,
          ),
        ),
      ];
      return allTabsWithInfo;
    }

    List<Widget> generateTabsContent() {
      List<Widget> allTabContentsWithInfo = [
        CreateMaterialPageContentInformation(
          onDateChanged: (String date) {
            _materialParam = _materialParam.copyWith(date: date);
          },
          onNotesChanged: (String notes) {
            _materialParam = _materialParam.copyWith(notes: notes);
          },
          materialDetailResponse: _materialDetailResponse,
        ),
        materialPageContent
      ];
      return allTabContentsWithInfo;
    }

    return Scaffold(
      body: BlocListener<MaterialBloc, MaterialsState>(
        listener: (context, state) {
          if (state is GetMaterialDetailLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is GetMaterialDetailSuccess) {
            setState(() {
              _isLoading = false;
              _materialDetailResponse = state.items;
            });
          }else if (state is GetMaterialItemSuccess) {
            setState(() {
              _isLoading = false;
              materialItems = state.items ?? [];
            });
          } else if (state is CreateUpdateMaterialLoading) {
            setState(() {
              _createIsLoading = true;
            });
          } else if (state is CreateUpdateMaterialSuccess) {
            setState(() {
              if (state.items?.success == true) {
                Navigator.pop(context, 200);
              } else {
                MySnackbar(context).errorSnackbar(state.items?.message ?? "");
              }
              _createIsLoading = false;
            });
          } else if (state is FailedState) {
            setState(() {
              _isLoading = false;
              _createIsLoading = false;
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
          length: 2,
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
                  'Tambah Material',
                  style: _textTheme.bodyText2,
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                width: _size.width,
                child: _createIsLoading
                    ? ProgressLoading()
                    : ElevatedButton(
                        onPressed: () {
                          var isEdit = widget.date != null;
                          var params = materialPageContent.getParams();
                          _materialParam =
                              _materialParam.copyWith(items: params);
                          if (isEdit) {
                            bloc.add(UpdateMaterial(_materialParam));
                          } else {
                            bloc.add(InsertMaterial(_materialParam));
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
            ),
            body: _isLoading
                ? const ShimmerLoading()
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
