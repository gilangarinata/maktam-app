import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:maktampos/services/model/material_response.dart';
import 'package:maktampos/ui/login/login_page.dart';
import 'package:maktampos/ui/material/create/create_material_page.dart';
import 'package:maktampos/ui/material/material_bloc.dart';
import 'package:maktampos/ui/material/material_event.dart';
import 'package:maktampos/ui/material/material_state.dart';
import 'package:maktampos/utils/my_snackbar.dart';
import 'package:maktampos/utils/screen_utils.dart';
import 'package:maktampos/utils/time_utils.dart';
import 'package:maktampos/widget/shimmer_loading.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class MaterialDataPage extends StatefulWidget {
  const MaterialDataPage({Key? key}) : super(key: key);

  @override
  _MaterialDataPageState createState() => _MaterialDataPageState();
}

class _MaterialDataPageState extends State<MaterialDataPage> {
  late MaterialBloc bloc;
  bool _isLoading = true;
  List<MaterialResponse> _materialItems = [];

  void getMaterials() {
    bloc.add(GetMaterial());
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<MaterialBloc>(context);
    getMaterials();
  }

  void blocListener(BuildContext context, MaterialsState state) async {
    if (state is GetMaterialLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is GetMaterialsSuccess) {
      setState(() {
        _isLoading = false;
        _materialItems = state.items ?? [];
      });
    } else if (state is DeleteMaterialLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is DeleteMaterialSuccess) {
      if (state.items?.success == true) {
        getMaterials();
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
        ScreenUtils(context).navigateTo(const LoginPage(), replaceScreen: true);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final _textTheme = Theme.of(context).textTheme;
    final _size = MediaQuery.of(context).size;

    Widget buildMaterialCard(MaterialResponse? materialItem) {
      return InkWell(
        onTap: () {
          ScreenUtils(context).navigateTo(
              CreateMaterialPage(
                date: TimeUtils.toServerDateTime(materialItem?.date),
              ), listener: (value) {
            if (value == 200) {
              getMaterials();
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
                    bloc.add(DeleteMaterial(
                        TimeUtils.toServerDateTime(materialItem?.date)));
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
                      TimeUtils.toCommonDateTime(materialItem?.date),
                      style: _textTheme.caption,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      materialItem?.employee ?? "",
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
          'Material',
          style: _textTheme.headline6,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: buildHeaders(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateMaterialPage(),
            ),
          ).then((value) => {
                if (value == 200) {getMaterials()}
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: colorScheme.primary,
      ),
      body: BlocListener<MaterialBloc, MaterialsState>(
        listener: blocListener,
        child: SizedBox(
          width: _size.width,
          child: LazyLoadScrollView(
            onEndOfPage: () {
              // getMaterials();
            },
            child: _isLoading
                ? const ShimmerLoading()
                : Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          getMaterials();
                        },
                        child: ListView.builder(
                          itemCount: _materialItems.length,
                          itemBuilder: (context, position) {
                            MaterialResponse? data = _materialItems[position];
                            return buildMaterialCard(data);
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
