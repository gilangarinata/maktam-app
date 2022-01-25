import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maktampos/preferences/pref_data.dart';
import 'package:maktampos/ui/dashboard/dashboard_page.dart';
import 'package:maktampos/ui/login/login_page.dart';
import 'package:maktampos/ui/webview/webview_page.dart';
import 'package:maktampos/utils/screen_utils.dart';
import 'package:maktampos/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    Future<void> _getPrefData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.containsKey(PrefData.accessToken);
      String? role = prefs.getString(PrefData.role);
      if (isLoggedIn) {
        if (role == "outlet") {
          ScreenUtils(context).navigateTo(DashboardPage(), replaceScreen: true);
        } else {
          ScreenUtils(context)
              .navigateTo(WebViewExample(), replaceScreen: true);
        }
      } else {
        ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
      }
    }

    Timer(Duration(seconds: 2), () {
      _getPrefData();
    });

    final _size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: _size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/maktam.png",
            width: 120,
          ),
          SizedBox(
            height: 50,
          ),
          ProgressLoading(
            size: 10,
            stroke: 1,
          )
        ],
      ),
    ));
  }
}
