import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../../data/repositories/auth_repository.dart';
import '../../models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final fb_auth.User? firebaseUser = await authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      if (firebaseUser != null) {
        emit(AuthAuthenticated(user: AppUser.fromFirebaseUser(firebaseUser)));
        print('User logged in: ${firebaseUser.email}');
      } else {
        emit(
          const AuthError(
            message: 'Login failed. Please check your credentials.',
          ),
        );
      }
    } catch (e) {
      String errorMessage = 'An unknown error occurred during login.';
      if (e is fb_auth.FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        }
      }
      emit(AuthError(message: errorMessage));
    }
  }
}
