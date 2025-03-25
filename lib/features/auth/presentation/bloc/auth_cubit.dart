import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login(String username, String password) {
    if (username == 'admin' && password == 'admin') {
      emit(AuthAuthenticated());
    } else {
      emit(AuthError('Invalid Credentials'));
    }
  }

  void logout() => emit(AuthInitial());
}
