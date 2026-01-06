import 'package:flutter_bloc/flutter_bloc.dart';

// Eventos
abstract class AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}
class LogoutRequested extends AuthEvent {}

// Estados
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String userId;
  AuthSuccess(this.userId);
}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // TODO: Chamar Firebase/API
        await Future.delayed(const Duration(seconds: 2));
        emit(AuthSuccess("user_123"));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
