import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/quote.dart';

class QuoteState extends Equatable {
  // Global Feed State
  final List<Quote> globalQuotes;
  final bool isLoadingGlobalQuotes;
  final bool isLoadingMoreGlobalQuotes;
  final DocumentSnapshot? lastGlobalQuoteDocument;
  final bool hasMoreGlobalQuotes;
  final String? globalQuotesError;

  // User Quotes State
  final List<Quote> userQuotes;
  final bool isLoadingUserQuotes;
  final String? userQuotesError;

  // Liked Quotes State
  final List<Quote> likedQuotes;
  final bool isLoadingLikedQuotes;
  final String? likedQuotesError;

  // General operation errors
  final String? addQuoteError;
  final String? updateQuoteError;
  final String? deleteQuoteError;
  final String? toggleLikeError;

  const QuoteState({
    this.globalQuotes = const [],
    this.isLoadingGlobalQuotes = true,
    this.isLoadingMoreGlobalQuotes = false,
    this.lastGlobalQuoteDocument,
    this.hasMoreGlobalQuotes = true,
    this.globalQuotesError,
    this.userQuotes = const [],
    this.isLoadingUserQuotes = false,
    this.userQuotesError,
    this.likedQuotes = const [],
    this.isLoadingLikedQuotes = false,
    this.likedQuotesError,
    this.addQuoteError,
    this.updateQuoteError,
    this.deleteQuoteError,
    this.toggleLikeError,
  });

  QuoteState copyWith({
    List<Quote>? globalQuotes,
    bool? isLoadingGlobalQuotes,
    bool? isLoadingMoreGlobalQuotes,
    DocumentSnapshot? lastGlobalQuoteDocument,
    bool? hasMoreGlobalQuotes,
    String? globalQuotesError,
    List<Quote>? userQuotes,
    bool? isLoadingUserQuotes,
    String? userQuotesError,
    List<Quote>? likedQuotes,
    bool? isLoadingLikedQuotes,
    String? likedQuotesError,
    String? addQuoteError,
    String? updateQuoteError,
    String? deleteQuoteError,
    String? toggleLikeError,
  }) {
    return QuoteState(
      globalQuotes: globalQuotes ?? this.globalQuotes,
      isLoadingGlobalQuotes: isLoadingGlobalQuotes ?? this.isLoadingGlobalQuotes,
      isLoadingMoreGlobalQuotes: isLoadingMoreGlobalQuotes ?? this.isLoadingMoreGlobalQuotes,
      lastGlobalQuoteDocument: lastGlobalQuoteDocument,
      hasMoreGlobalQuotes: hasMoreGlobalQuotes ?? this.hasMoreGlobalQuotes,
      globalQuotesError: globalQuotesError,
      userQuotes: userQuotes ?? this.userQuotes,
      isLoadingUserQuotes: isLoadingUserQuotes ?? this.isLoadingUserQuotes,
      userQuotesError: userQuotesError,
      likedQuotes: likedQuotes ?? this.likedQuotes,
      isLoadingLikedQuotes: isLoadingLikedQuotes ?? this.isLoadingLikedQuotes,
      likedQuotesError: likedQuotesError,
      addQuoteError: addQuoteError,
      updateQuoteError: updateQuoteError,
      deleteQuoteError: deleteQuoteError,
      toggleLikeError: toggleLikeError,
    );
  }

  @override
  List<Object?> get props => [
    globalQuotes,
    isLoadingGlobalQuotes,
    isLoadingMoreGlobalQuotes,
    lastGlobalQuoteDocument,
    hasMoreGlobalQuotes,
    globalQuotesError,
    userQuotes,
    isLoadingUserQuotes,
    userQuotesError,
    likedQuotes,
    isLoadingLikedQuotes,
    likedQuotesError,
    addQuoteError,
    updateQuoteError,
    deleteQuoteError,
    toggleLikeError,
  ];
}