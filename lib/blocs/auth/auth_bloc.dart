import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../../data/repositories/auth_repository.dart';
import '../../models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  late StreamSubscription<fb_auth.User?> _userSubscription;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // Listen to Auth state changes
    _userSubscription = authRepository.userChanges().listen((
      fb_auth.User? firebaseUser,
    ) {
      add(AuthUserChanged(user: firebaseUser));
    });

    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthUserChanged>(_onUserChanged);
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

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final fb_auth.User? firebaseUser = await authRepository.signUp(
        email: event.email,
        password: event.password,
      );
      if (firebaseUser != null) {
        emit(AuthAuthenticated(user: AppUser.fromFirebaseUser(firebaseUser)));
      } else {
        emit(const AuthError(message: 'Signup failed. Please try again.'));
      }
    } catch (e) {
      String errorMessage = 'An unknown error occurred during signup.';
      if (e is fb_auth.FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        }
      }
      emit(AuthError(message: errorMessage));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      String errorMessage = 'An unknown error occurred during logout.';
      if (e is fb_auth.FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      }
      emit(AuthError(message: errorMessage));
    }
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthAuthenticated(user: AppUser.fromFirebaseUser(event.user!)));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
