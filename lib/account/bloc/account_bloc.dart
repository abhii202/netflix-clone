import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/account_api_services.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountApiService apiService;

  AccountBloc(this.apiService) : super(AccountInitial()) {
    on<FetchProfiles>(_onFetchProfiles);
  }

  Future<void> _onFetchProfiles(
    FetchProfiles event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      final profiles = await apiService.fetchProfiles();
      emit(AccountLoaded(profiles));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}
