import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktampos/services/model/login_response.dart';
import 'package:maktampos/services/repository/authentication_repository.dart';
import 'package:maktampos/ui/login/login_event.dart';
import 'package:maktampos/ui/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthenticationRepository repository;

  LoginBloc(this.repository) : super(const InitialState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is ProcessLogin) {
      try {
        yield const LoginLoading();
        LoginResponse? items = await repository.postLogin(event.loginPram);
        yield LoginSuccess(items: items);
      } catch (e) {
        yield LoginError(e.toString(), -1);
      }
    }
  }
}
