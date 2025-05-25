import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../screens/liked_quotes_screen.dart';
import '../screens/login_screen.dart';
import '../screens/global_feed_screen.dart';
import '../screens/add_quote_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/scaffold_with_nav_bar.dart';

class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),

        // ShellRoute for bottom navigation
        ShellRoute(
          builder: (context, state, child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: [
            GoRoute(
              path: '/global-feed',
              name: 'global_feed',
              builder: (context, state) => const GlobalFeedScreen(),
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: '/liked-quotes',
              name: 'liked_quotes',
              builder: (context, state) => const LikedQuotesScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/add-quote',
          name: 'add_quote',
          builder: (context, state) => AddQuoteScreen(),
        ),
      ],

      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = authBloc.state is AuthAuthenticated;
        final bool loggingIn = state.fullPath == '/';
        final bool signingUp = state.fullPath == '/signup';
        final bool onProtectedPath =
            state.fullPath != '/' && state.fullPath != '/signup';

        // Validation: If the user is logged in, but trying to access the login/signup page, redirect to global feed
        if (loggedIn && (loggingIn || signingUp)) {
          return '/global-feed';
        }
        // Validation: If the user is not logged in, and trying to access a protected page, redirect to login
        if (!loggedIn && onProtectedPath) {
          return '/';
        }
        return null;
      },
      // Listen to changes in AuthBloc state for redirection
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
    );
  }
}

// React to BLoC state changes
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;

  GoRouterRefreshStream(Stream<AuthState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
