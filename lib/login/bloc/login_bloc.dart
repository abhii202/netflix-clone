import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/login_api_services.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginApiService apiService;

  LoginBloc(this.apiService) : super(InitialState()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());

    try {
      final loginModel = await apiService.login(event.email, event.password);
      emit(LoginSuccessState(loginModel));
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(LoginErrorState(message));
    }
  }
}
