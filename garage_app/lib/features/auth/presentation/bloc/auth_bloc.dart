import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkingzero/features/auth/domain/repositories/auth_repository.dart';

// Eventos
abstract class AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}
class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterRequested(this.name, this.email, this.password);
}
class GoogleLoginRequested extends AuthEvent {}
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
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // Email/Password login
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential cred = await authRepository.signInWithEmail(
          event.email,
          event.password,
        );
        emit(AuthSuccess(cred.user!.uid));
      } on FirebaseAuthException catch (e) {
        emit(AuthFailure(e.message ?? 'Falha na autenticação'));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Email/Password register
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential cred = await authRepository.signUpWithEmail(
          event.name,
          event.email,
          event.password,
        );
        emit(AuthSuccess(cred.user!.uid));
      } on FirebaseAuthException catch (e) {
        emit(AuthFailure(e.message ?? 'Falha ao criar conta'));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Google Sign-In login
    on<GoogleLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential cred = await authRepository.signInWithGoogle();
        emit(AuthSuccess(cred.user!.uid));
      } on FirebaseAuthException catch (e) {
        emit(AuthFailure(e.message ?? 'Falha no Google Sign-In'));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Logout
    on<LogoutRequested>((event, emit) async {
      try {
        await authRepository.signOut();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
