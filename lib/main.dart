import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'config/app_router.dart';
import 'config/theme.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/quote/quote_bloc.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/quote_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  late final AuthRepository _authRepository;
  late final QuoteRepository _quoteRepository;

  // Blocs
  late final AuthBloc _authBloc;
  late final QuoteBloc _quoteBloc;

  // GoRouter
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(firebaseAuth: _firebaseAuth);
    _quoteRepository = QuoteRepository(firestore: _firebaseFirestore);

    _authBloc = AuthBloc(authRepository: _authRepository);
    _quoteBloc = QuoteBloc(quoteRepository: _quoteRepository);

    _router = AppRouter.createRouter(_authBloc); // Pass AuthBloc to AppRouter

    // Check user's authentication status
    _authBloc.add(AuthUserChanged(user: _firebaseAuth.currentUser));
  }

  @override
  void dispose() {
    _authBloc.close();
    _quoteBloc.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<QuoteRepository>.value(value: _quoteRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: _authBloc),
          BlocProvider<QuoteBloc>.value(value: _quoteBloc),
        ],
        child: MaterialApp.router(
          title: 'Quote Saver',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: _router,
        ),
      ),
    );
  }
}
