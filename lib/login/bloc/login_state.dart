import '../models/users_model.dart';

abstract class LoginState {}

class InitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final UserModel user;

  LoginSuccessState(this.user);
}

class LoginErrorState extends LoginState {
  final String error;

  LoginErrorState(this.error);
}
