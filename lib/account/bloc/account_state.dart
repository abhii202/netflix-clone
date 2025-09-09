import '../model/profile_model.dart';

abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final List<ProfileModel> profiles;
  AccountLoaded(this.profiles);
}

class AccountError extends AccountState {
  final String message;
  AccountError(this.message);
}
