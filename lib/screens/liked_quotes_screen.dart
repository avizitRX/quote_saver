import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:intl/intl.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/quote/quote_bloc.dart';
import '../blocs/quote/quote_event.dart';
import '../blocs/quote/quote_state.dart';
import '../widgets/animated_like_button.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/message_dialog.dart';
import '../models/quote.dart';

class LikedQuotesScreen extends StatefulWidget {
  const LikedQuotesScreen({super.key});

  @override
  State<LikedQuotesScreen> createState() => _LikedQuotesScreenState();
}

class _LikedQuotesScreenState extends State<LikedQuotesScreen> {
  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthAuthenticated) {
      context.read<QuoteBloc>().add(LoadLikedQuotes());
    }
  }

  void _onLogout() {
    context.read<AuthBloc>().add(AuthLogoutRequested());
  }

  void _toggleLike(Quote quote) {
    final String? currentUserId =
        fb_auth.FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      showMessageDialog(
        context,
        'Login Required',
        'Please log in to like quotes.',
      );
      return;
    }
    context.read<QuoteBloc>().add(ToggleLikeQuote(quote: quote));
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUserId =
        fb_auth.FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Quotes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _onLogout,
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, authState) {
              if (authState is AuthAuthenticated) {
                context.read<QuoteBloc>().add(LoadLikedQuotes());
              }
            },
          ),
          BlocListener<QuoteBloc, QuoteState>(
            listener: (context, quoteState) {
              if (quoteState.likedQuotesError != null) {
                showMessageDialog(
                  context,
                  'Error Loading Liked Quotes',
                  quoteState.likedQuotesError!,
                );
                context.read<QuoteBloc>().add(
                  LoadLikedQuotes(),
                ); // Attempt to clear error
              }
              if (quoteState.toggleLikeError != null) {
                showMessageDialog(
                  context,
                  'Like Error',
                  quoteState.toggleLikeError!,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, quoteState) {
            if (quoteState.isLoadingLikedQuotes) {
              return const LoadingIndicator();
            } else if (quoteState.likedQuotes.isEmpty) {
              return const Center(
                child: Text(
                  'You haven\'t liked any quotes yet.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              itemCount: quoteState.likedQuotes.length,
              itemBuilder: (context, index) {
                final quote = quoteState.likedQuotes[index];
                final bool isLikedByUser = quote.likes.contains(currentUserId);
                final bool isOwnQuote = quote.userId == currentUserId;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Stack(
                    children: [
                      // Watermark quotation mark
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '“',
                            style: TextStyle(
                              fontSize: 200,
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.black.withOpacity(0.05),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                '"${quote.text}"',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.color,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '- ${quote.author}',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                            if (quote.timestamp != null)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  DateFormat(
                                    'MMM dd,yyyy',
                                  ).format(quote.timestamp!),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // Like button
                                    if (!isOwnQuote)
                                      AnimatedLikeButton(
                                        isLiked: isLikedByUser,
                                        likeCount: quote.likes.length,
                                        onPressed: () => _toggleLike(quote),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
