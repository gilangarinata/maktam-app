import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/res/my_colors.dart';
import 'package:maktampos/res/my_strings.dart';
import 'package:maktampos/services/param/login_param.dart';
import 'package:maktampos/ui-admin/screens/main/main_screen.dart';
import 'package:maktampos/ui/dashboard/dashboard_page.dart';
import 'package:maktampos/ui/login/login_bloc.dart';
import 'package:maktampos/ui/login/login_event.dart';
import 'package:maktampos/ui/login/login_state.dart';
import 'package:maktampos/ui/webview/webview_page.dart';
import 'package:maktampos/utils/my_snackbar.dart';
import 'package:maktampos/utils/screen_utils.dart';
import 'package:maktampos/widget/progress_loading.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.username,this.password});

  String? username;
  String? password;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late LoginBloc bloc;

  String? _errorUsername;
  String? _errorPassword;

  bool _isLoading = false;
  bool _isAdmin = false;

  void loginListener(BuildContext context, LoginState state) async {
    if (state is LoginSuccess) {
      setState(() {
        _isLoading = false;
      });
      if (state.items?.role?.roleName == "outlet") {
        ScreenUtils(context).navigateTo(const DashboardPage());
      } else {
        ScreenUtils(context).navigateTo(AdminMainScreen());
      }
    } else if (state is LoginLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is LoginError) {
      if (state.code == 401) {
        MySnackbar(context).errorSnackbar(MyStrings.wrongUsernameOrPass);
      } else {
        MySnackbar(context).errorSnackbar("${state.message} : ${state.code}");
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    bloc = context.read<LoginBloc>();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    if (widget.username != null &&
        widget.password != null) {
      LoginParam loginParam =
      LoginParam(widget.username!, widget.password!);
      bloc.add(ProcessLogin(loginParam));

      if (widget.username?.contains("admin") == true) {
        _isAdmin = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocListener<LoginBloc, LoginState>(
        listener: loginListener,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              child: SizedBox(
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/maktam.png',
                      width: 120.0,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      MyStrings.welcome,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.apply(color: MyColors.primary, fontWeightDelta: 10),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      MyStrings.loginToContinue,
                      style: Theme.of(context).textTheme.caption?.apply(),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: MyStrings.username,
                        errorText: _errorUsername,
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(
                          Icons.person,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        errorText: _errorPassword,
                        labelText: MyStrings.password,
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(
                          Icons.lock,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: size.width,
                      child: _isLoading
                          ? ProgressLoading()
                          : ElevatedButton(
                              onPressed: () {
                                String username = _usernameController.text;
                                String password = _passwordController.text;
                                if (username.isNotEmpty &&
                                    password.isNotEmpty) {
                                  LoginParam loginParam =
                                      LoginParam(username, password);
                                  bloc.add(ProcessLogin(loginParam));
                                }

                                if (username.contains("admin")) {
                                  _isAdmin = true;
                                }
                              },
                              child: Text(
                                MyStrings.login,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.apply(color: Colors.white),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
