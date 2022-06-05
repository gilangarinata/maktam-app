import 'package:alice_lightweight/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/res/my_colors.dart';
import 'package:maktampos/services/dio_client.dart';
import 'package:maktampos/services/repository/authentication_repository.dart';
import 'package:maktampos/services/repository/material_repository.dart';
import 'package:maktampos/services/repository/selling_repository.dart';
import 'package:maktampos/services/repository/stock_repository.dart';
import 'package:maktampos/ui-admin/screens/dashboard/dasboard_bloc.dart';
import 'package:maktampos/ui-admin/screens/maktam_bloc.dart';
import 'package:maktampos/ui-admin/screens/product/product_bloc.dart';
import 'package:maktampos/ui-admin/services/repository/dashboard_repository.dart';
import 'package:maktampos/ui-admin/services/repository/maktam_repository.dart';
import 'package:maktampos/ui-admin/services/repository/product_repository.dart';
import 'package:maktampos/ui/login/login_bloc.dart';
import 'package:maktampos/ui/login/login_page.dart';
import 'package:maktampos/ui/material/material_bloc.dart';
import 'package:maktampos/ui/selling/selling_bloc.dart';
import 'package:maktampos/ui/splashscreen/splash_screen_page.dart';
import 'package:maktampos/ui/stock/stock_bloc.dart';
import 'package:shake/shake.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


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
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
              AuthenticationRepositoryImpl(DioClient().init(kIsWeb ? null : alice)),
            ),
          ),
          BlocProvider<SellingBloc>(
            create: (context) => SellingBloc(
              SellingRepositoryImpl(DioClient().init(kIsWeb ? null :alice)),
            ),
          ),
          BlocProvider<StockBloc>(
            create: (context) => StockBloc(
              StockRepositoryImpl(DioClient().init(kIsWeb ? null :alice)),
            ),
          ),
          BlocProvider<MaterialBloc>(
            create: (context) => MaterialBloc(
              MaterialRepositoryImpl(DioClient().init(kIsWeb ? null :alice)),
            ),
          ),
        ],
        child: MyApp(kIsWeb ? null :alice)
    ),
  );
}

class MyApp extends StatelessWidget {

  Alice? alice;

  MyApp(this.alice);

  @override
  Widget build(BuildContext context) {
    ShakeDetector.autoStart(
        onPhoneShake: () {
          alice?.showInspector();
        }
    );
    return MaterialApp(
      navigatorKey: alice?.getNavigatorKey(),
      debugShowCheckedModeBanner: false,
      theme: _buildShrineTheme(),
      home: const SplashScreenPage()
    );
  }
}


IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: shrineBrown900);
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: shrinePink100,
    scaffoldBackgroundColor: shrineBackgroundWhite,
    cardColor: Colors.white,
    errorColor: shrineErrorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: _shrineColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    iconTheme: _customIconTheme(base.iconTheme), colorScheme: _shrineColorScheme.copyWith(secondary: shrineBrown900),
  );
}


const ColorScheme _shrineColorScheme = ColorScheme(
  primary: MyColors.primary,
  primaryVariant: MyColors.primaryVariants,
  secondary: MyColors.secondary,
  secondaryVariant: MyColors.secondaryVariant,
  surface: shrineSurfaceWhite,
  background: shrineBackgroundWhite,
  error: shrineErrorRed,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onBackground: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.light,
);

const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = MyColors.white;
const Color shrineBackgroundWhite = Color(0xFFf7f8fb);

const defaultLetterSpacing = 0.03;

