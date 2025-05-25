import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/repositories/quote_repository.dart';
import '../../models/quote.dart';
import 'quote_event.dart';
import 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final QuoteRepository quoteRepository;

  QuoteBloc({required this.quoteRepository}) : super(QuoteState()) {
    on<LoadAllQuotes>(_onLoadAllQuotes);
    on<LoadUserQuotes>(_onLoadUserQuotes);
    on<LoadLikedQuotes>(_onLoadLikedQuotes);
    on<AddQuote>(_onAddQuote);
    on<UpdateQuote>(_onUpdateQuote);
    on<DeleteQuote>(_onDeleteQuote);
    on<ToggleLikeQuote>(_onToggleLikeQuote);
  }

  String _getCurrentUserId() {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('QuoteBloc: _getCurrentUserId: User not authenticated, throwing error.');
      throw Exception('User not authenticated.');
    }
    return userId;
  }

  Future<void> _onLoadAllQuotes(
      LoadAllQuotes event,
      Emitter<QuoteState> emit,
      ) async {
    if (event.isInitialLoad) {
      emit(state.copyWith(
        globalQuotes: [],
        isLoadingGlobalQuotes: true,
        lastGlobalQuoteDocument: null,
        hasMoreGlobalQuotes: true,
        globalQuotesError: null,
        isLoadingMoreGlobalQuotes: false,
      ));
    } else if (event.loadingMore) {
      if (state.isLoadingMoreGlobalQuotes || !state.hasMoreGlobalQuotes) {
        return;
      }
      emit(state.copyWith(isLoadingMoreGlobalQuotes: true, globalQuotesError: null));
    }

    try {
      await emit.forEach<PaginationResult>(
        quoteRepository.getAllQuotesPaginatedStream(
          limit: event.limit,
          startAfterDocument: event.startAfterDocument,
        ),
        onData: (snapshot) {
          final DocumentSnapshot? lastDoc = snapshot.lastDocument;
          final List<Quote> streamedQuotes = snapshot.quotes;
          final bool hasMore = streamedQuotes.length == event.limit;

          final List<Quote> updatedGlobalQuotesList = List.from(state.globalQuotes);

          if (event.isInitialLoad) {
            updatedGlobalQuotesList.clear();
            updatedGlobalQuotesList.addAll(streamedQuotes);
          } else {
            final Map<String, Quote> combinedQuotesMap = {
              for (var q in updatedGlobalQuotesList) q.id!: q
            };

            for (var newQuote in streamedQuotes) {
              if (newQuote.id != null) {
                combinedQuotesMap[newQuote.id!] = newQuote;
              }
            }

            updatedGlobalQuotesList.clear();
            updatedGlobalQuotesList.addAll(combinedQuotesMap.values.toList());
            updatedGlobalQuotesList.sort((a, b) => (b.timestamp ?? DateTime(0)).compareTo(a.timestamp ?? DateTime(0)));
          }

          print('QuoteBloc: onData: Total global quotes after update: ${updatedGlobalQuotesList.length}');
          print('QuoteBloc: onData: hasMoreGlobalQuotes will be: $hasMore');
          print('QuoteBloc: onData: isLoadingGlobalQuotes will be: false');
          print('QuoteBloc: onData: isLoadingMoreGlobalQuotes will be: false');


          return state.copyWith(
            globalQuotes: updatedGlobalQuotesList,
            isLoadingGlobalQuotes: false,
            isLoadingMoreGlobalQuotes: false,
            lastGlobalQuoteDocument: lastDoc,
            hasMoreGlobalQuotes: hasMore,
            globalQuotesError: null,
          );
        },
        onError: (error, stackTrace) {
          String errorMessage = 'Failed to load global quotes.';
          if (error is FirebaseException) {
            errorMessage = error.message ?? errorMessage;
          }
          return state.copyWith(
            isLoadingGlobalQuotes: false,
            isLoadingMoreGlobalQuotes: false,
            globalQuotesError: errorMessage,
          );
        },
      );
    } catch (e) {
      String errorMessage = 'Failed to load global quotes: ${e.toString()}';
      emit(state.copyWith(
        isLoadingGlobalQuotes: false,
        isLoadingMoreGlobalQuotes: false,
        globalQuotesError: errorMessage,
      ));
    }
  }

  Future<void> _onLoadUserQuotes(
      LoadUserQuotes event,
      Emitter<QuoteState> emit,
      ) async {
    emit(state.copyWith(isLoadingUserQuotes: true, userQuotesError: null));

    try {
      final String userId = _getCurrentUserId();
      await emit.forEach<List<Quote>>(
        quoteRepository.getUserQuotesStream(userId),
        onData: (quotes) {
          return state.copyWith(userQuotes: quotes, isLoadingUserQuotes: false, userQuotesError: null);
        },
        onError: (error, stackTrace) {
          String errorMessage = 'Failed to load your quotes.';
          if (error is FirebaseException) {
            errorMessage = error.message ?? errorMessage;
          }
          return state.copyWith(isLoadingUserQuotes: false, userQuotesError: errorMessage);
        },
      );
    } catch (e) {
      String errorMessage = 'Failed to load your quotes: ${e.toString()}';
      emit(state.copyWith(isLoadingUserQuotes: false, userQuotesError: errorMessage));
    }
  }

  Future<void> _onLoadLikedQuotes(
      LoadLikedQuotes event,
      Emitter<QuoteState> emit,
      ) async {
    emit(state.copyWith(isLoadingLikedQuotes: true, likedQuotesError: null));

    try {
      final String userId = _getCurrentUserId();
      await emit.forEach<List<Quote>>(
        quoteRepository.getLikedQuotesStream(userId),
        onData: (quotes) {
          return state.copyWith(likedQuotes: quotes, isLoadingLikedQuotes: false, likedQuotesError: null);
        },
        onError: (error, stackTrace) {
          String errorMessage = 'Failed to load liked quotes.';
          if (error is FirebaseException) {
            errorMessage = error.message ?? errorMessage;
          } else {
          }
          return state.copyWith(isLoadingLikedQuotes: false, likedQuotesError: errorMessage);
        },
      );
    } catch (e) {
      String errorMessage = 'Failed to load liked quotes: ${e.toString()}';
      emit(state.copyWith(isLoadingLikedQuotes: false, likedQuotesError: errorMessage));
    }
  }

  Future<void> _onAddQuote(
      AddQuote event,
      Emitter<QuoteState> emit,
      ) async {
    emit(state.copyWith(addQuoteError: null));
    try {
      final String userId = _getCurrentUserId();
      final Quote quoteWithTimestamp = event.quote.copyWith(
        userId: userId,
        timestamp: DateTime.now(),
      );
      await quoteRepository.addQuote(quoteWithTimestamp);
    } catch (e) {
      String errorMessage = 'Failed to add quote.';
      if (e is FirebaseException) {
        errorMessage = e.message ?? errorMessage;
      }
      emit(state.copyWith(addQuoteError: errorMessage));
    }
  }

  Future<void> _onUpdateQuote(
      UpdateQuote event,
      Emitter<QuoteState> emit,
      ) async {
    emit(state.copyWith(updateQuoteError: null));
    try {
      final String userId = _getCurrentUserId();
      await quoteRepository.updateQuote(userId, event.quote);
    } catch (e) {
      String errorMessage = 'Failed to update quote.';
      if (e is FirebaseException) {
        errorMessage = e.message ?? errorMessage;
      }
      emit(state.copyWith(updateQuoteError: errorMessage));
    }
  }

  Future<void> _onDeleteQuote(
      DeleteQuote event,
      Emitter<QuoteState> emit,
      ) async {
    emit(state.copyWith(deleteQuoteError: null));
    try {
      final String userId = _getCurrentUserId();
      await quoteRepository.deleteQuote(userId, event.quoteId);
    } catch (e) {
      String errorMessage = 'Failed to delete quote.';
      if (e is FirebaseException) {
        errorMessage = e.message ?? errorMessage;
      }
      emit(state.copyWith(deleteQuoteError: errorMessage));
    }
  }

  Future<void> _onToggleLikeQuote(
      ToggleLikeQuote event,
      Emitter<QuoteState> emit,
      ) async {
    emit(state.copyWith(toggleLikeError: null));

    final String likingUserId = _getCurrentUserId();
    final Quote quote = event.quote;
    final bool wasLiked = quote.likes.contains(likingUserId);

    final List<String> newLikes = List.from(quote.likes);
    if (wasLiked) {
      newLikes.remove(likingUserId);
    } else {
      newLikes.add(likingUserId);
    }
    final Quote optimisticallyUpdatedQuote = quote.copyWith(likes: newLikes);

    final List<Quote> updatedGlobalQuotes = state.globalQuotes.map((q) {
      return q.id == optimisticallyUpdatedQuote.id ? optimisticallyUpdatedQuote : q;
    }).toList();

    final List<Quote> updatedUserQuotes = state.userQuotes.map((q) {
      return q.id == optimisticallyUpdatedQuote.id ? optimisticallyUpdatedQuote : q;
    }).toList();

    final List<Quote> updatedLikedQuotes = List.from(state.likedQuotes);
    if (wasLiked) { // If it was liked and now unliked, remove it from the liked list
      updatedLikedQuotes.removeWhere((q) => q.id == optimisticallyUpdatedQuote.id);
    }

    emit(state.copyWith(
      globalQuotes: updatedGlobalQuotes,
      userQuotes: updatedUserQuotes,
      likedQuotes: updatedLikedQuotes,
      toggleLikeError: null,
    ));

    try {
      await quoteRepository.toggleLike(likingUserId, quote);
    } catch (e) {
      String errorMessage = 'Failed to toggle like.';
      if (e is FirebaseException) {
        errorMessage = e.message ?? errorMessage;
      }
      emit(state.copyWith(toggleLikeError: errorMessage));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}