import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:intl/intl.dart';
import 'package:quote_saver/widgets/animated_like_button.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/quote/quote_bloc.dart';
import '../blocs/quote/quote_event.dart';
import '../blocs/quote/quote_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/message_dialog.dart';
import '../models/quote.dart';

class GlobalFeedScreen extends StatefulWidget {
  const GlobalFeedScreen({super.key});

  @override
  State<GlobalFeedScreen> createState() => _GlobalFeedScreenState();
}

class _GlobalFeedScreenState extends State<GlobalFeedScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthAuthenticated) {
      context.read<QuoteBloc>().add(const LoadAllQuotes(isInitialLoad: true));
    }

    _pageController.addListener(() {
      // load more quotes
      if (_pageController.position.pixels ==
          _pageController.position.maxScrollExtent) {
        final quoteBloc = context.read<QuoteBloc>();
        if (!quoteBloc.state.isLoadingMoreGlobalQuotes &&
            quoteBloc.state.hasMoreGlobalQuotes) {
          quoteBloc.add(
            LoadAllQuotes(
              isInitialLoad: false,
              loadingMore: true,
              startAfterDocument: quoteBloc.state.lastGlobalQuoteDocument,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
    if (quote.userId == currentUserId) {
      showMessageDialog(
        context,
        'Cannot Like Own Quote',
        'You cannot like your own quote.',
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
        title: const Text('Global Feed'),
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
                // initial load
                if (context.read<QuoteBloc>().state.globalQuotes.isEmpty &&
                    !context.read<QuoteBloc>().state.isLoadingGlobalQuotes) {
                  context.read<QuoteBloc>().add(
                    const LoadAllQuotes(isInitialLoad: true),
                  );
                }
              }
            },
          ),
          BlocListener<QuoteBloc, QuoteState>(
            listener: (context, quoteState) {
              if (quoteState.globalQuotesError != null) {
                showMessageDialog(
                  context,
                  'Error Loading Feed',
                  quoteState.globalQuotesError!,
                );
                context.read<QuoteBloc>().add(
                  const LoadAllQuotes(isInitialLoad: false, loadingMore: false),
                );
              }
              if (quoteState.toggleLikeError != null) {
                showMessageDialog(
                  context,
                  'Like Error',
                  quoteState.toggleLikeError!,
                );
                // Clear the error after showing
                context.read<QuoteBloc>().add(
                  const LoadAllQuotes(isInitialLoad: false, loadingMore: false),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, quoteState) {
            if (quoteState.isLoadingGlobalQuotes &&
                quoteState.globalQuotes.isEmpty) {
              return const LoadingIndicator();
            } else if (quoteState.globalQuotes.isEmpty &&
                !quoteState.isLoadingGlobalQuotes) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No quotes available in the feed yet!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/add-quote'),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Your First Quote'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount:
                  quoteState.globalQuotes.length +
                  (quoteState.hasMoreGlobalQuotes ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == quoteState.globalQuotes.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final quote = quoteState.globalQuotes[index];
                final bool isLikedByUser = quote.likes.contains(currentUserId);
                final bool isOwnQuote = quote.userId == currentUserId;

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Stack(
                    children: [
                      // Watermark for the quotation mark
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '“',
                            style: TextStyle(
                              fontSize: 300,
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.black.withOpacity(0.05),
                              fontWeight: FontWeight.bold,
                              // fontFamily:
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '"${quote.text}"',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium?.copyWith(
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineMedium?.color,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '- ${quote.author}',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.color,
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
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // like button
                                    AnimatedLikeButton(
                                      isLiked: isLikedByUser,
                                      likeCount: quote.likes.length,
                                      isOwnQuote: isOwnQuote,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-quote'),
        tooltip: 'Add New Quote',
        child: const Icon(Icons.add),
      ),
    );
  }
}
