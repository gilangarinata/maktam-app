import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maktampos/services/model/login_response.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class InitialState extends LoginState {
  const InitialState();

  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  final LoginResponse? items;

  const LoginSuccess({@required this.items});

  @override
  List<Object?> get props => [items];
}

class LoginError extends LoginState {
  final String message;
  final int code;

  const LoginError(this.message, this.code);

  @override
  List<Object> get props => [message];
}

class LoginLoading extends LoginState {
  const LoginLoading();

  @override
  List<Object> get props => [];
}
