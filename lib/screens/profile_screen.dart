import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:intl/intl.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/quote/quote_bloc.dart';
import '../blocs/quote/quote_event.dart';
import '../blocs/quote/quote_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/message_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthAuthenticated) {
      context.read<QuoteBloc>().add(LoadUserQuotes());
    }
  }

  void _onLogout() {
    context.read<AuthBloc>().add(AuthLogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUserId =
        fb_auth.FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quotes'),
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
              // Reload data if auth state changes to authenticated
              if (authState is AuthAuthenticated) {
                context.read<QuoteBloc>().add(LoadUserQuotes());
              }
            },
          ),
          BlocListener<QuoteBloc, QuoteState>(
            listener: (context, quoteState) {
              if (quoteState.userQuotesError != null) {
                showMessageDialog(
                  context,
                  'Error Loading My Quotes',
                  quoteState.userQuotesError!,
                );
                context.read<QuoteBloc>().add(LoadUserQuotes());
              }
              if (quoteState.deleteQuoteError != null) {
                showMessageDialog(
                  context,
                  'Error Deleting Quote',
                  quoteState.deleteQuoteError!,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, quoteState) {
            if (quoteState.isLoadingUserQuotes) {
              return const LoadingIndicator();
            } else if (quoteState.userQuotes.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'You haven\'t added any quotes yet.',
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
            return ListView.builder(
              itemCount: quoteState.userQuotes.length,
              itemBuilder: (context, index) {
                final quote = quoteState.userQuotes[index];
                return Dismissible(
                  key: Key(quote.id!),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                            'Are you sure you want to delete this quote?',
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(false);
                              },
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return confirm ?? false;
                  },
                  onDismissed: (direction) {
                    context.read<QuoteBloc>().add(
                      DeleteQuote(quoteId: quote.id!),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Quote "${quote.text}" deleted')),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${quote.likes.length} Likes',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    onPressed:
                                        () => context.push(
                                          '/add-quote',
                                          extra: quote,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
