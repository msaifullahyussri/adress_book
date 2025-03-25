import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 2)); // Fake API delay
      if (event.username == 'admin' && event.password == '1234') {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError('Invalid username or password'));
      }
    });

    on<LogoutRequested>((event, emit) => emit(AuthInitial()));
  }
}
