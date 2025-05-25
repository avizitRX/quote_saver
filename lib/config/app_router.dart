import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';
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
    );
  }
}
