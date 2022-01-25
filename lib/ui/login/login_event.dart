import 'package:equatable/equatable.dart';
import 'package:maktampos/services/param/login_param.dart';

abstract class LoginEvent extends Equatable {}

class ProcessLogin extends LoginEvent {
  final LoginParam loginPram;

  @override
  List<Object> get props => [loginPram];

  ProcessLogin(this.loginPram);
}

class UsernameChanged extends LoginEvent {
  final String username;

  UsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}

class PasswordChanged extends LoginEvent {
  final String pasword;

  PasswordChanged(this.pasword);

  @override
  List<Object> get props => [pasword];
}
