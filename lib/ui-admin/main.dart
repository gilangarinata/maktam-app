import 'package:alice_lightweight/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/ui-admin/screens/dashboard/dasboard_bloc.dart';
import 'package:maktampos/ui-admin/screens/main/main_screen.dart';
import 'package:maktampos/ui-admin/screens/maktam_bloc.dart';
import 'package:maktampos/ui-admin/screens/product/product_bloc.dart';
import 'package:maktampos/ui-admin/services/dio_client.dart';
import 'package:maktampos/ui-admin/services/repository/dashboard_repository.dart';
import 'package:maktampos/ui-admin/services/repository/maktam_repository.dart';
import 'package:maktampos/ui-admin/services/repository/product_repository.dart';

void main() {
  Alice alice = Alice();
  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(
              DashboardRepositoryImpl(DioClient().init(alice)),
            ),
          ),
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(
              ProductRepositoryImpl(DioClient().init(alice)),
            ),
          ),
          BlocProvider<MaktamBloc>(
            create: (context) => MaktamBloc(
              MaktamRepositoryImpl(DioClient().init(alice)),
            ),
          ),
        ],
        child: MyApp(alice)
    ),
  );
  // runApp(MyApp(alice));
}

class MyApp extends StatelessWidget {

  Alice? alice;

  MyApp(this.alice);

  @override
  Widget build(BuildContext context) {
    // ShakeDetector.autoStart(
    //     onPhoneShake: () {
    //       alice?.showInspector();
    //     }
    // );
    return MaterialApp(
        navigatorKey: alice?.getNavigatorKey(),
        debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: AdminMainScreen(),
    );
  }
}

