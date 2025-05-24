import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class AppUser extends Equatable {
  final String id;
  final String? email;

  const AppUser({required this.id, this.email});

  // create an AppUser
  factory AppUser.fromFirebaseUser(fb_auth.User firebaseUser) {
    return AppUser(id: firebaseUser.uid, email: firebaseUser.email);
  }

  @override
  List<Object?> get props => [id, email];
}
