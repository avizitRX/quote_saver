import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/quote.dart';

abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllQuotes extends QuoteEvent {
  final DocumentSnapshot? startAfterDocument;
  final bool isInitialLoad;
  final bool loadingMore;
  final int limit;

  const LoadAllQuotes({
    this.startAfterDocument,
    this.isInitialLoad = true,
    this.loadingMore = false,
    this.limit = 5,
  });

  @override
  List<Object?> get props => [startAfterDocument, isInitialLoad, loadingMore, limit];
}

class LoadUserQuotes extends QuoteEvent {}

class LoadLikedQuotes extends QuoteEvent {}

class AddQuote extends QuoteEvent {
  final Quote quote;

  const AddQuote({required this.quote});

  @override
  List<Object> get props => [quote];
}

class UpdateQuote extends QuoteEvent {
  final Quote quote;

  const UpdateQuote({required this.quote});

  @override
  List<Object> get props => [quote];
}

class DeleteQuote extends QuoteEvent {
  final String quoteId;

  const DeleteQuote({required this.quoteId});

  @override
  List<Object> get props => [quoteId];
}

class ToggleLikeQuote extends QuoteEvent {
  final Quote quote;

  const ToggleLikeQuote({required this.quote});

  @override
  List<Object> get props => [quote];
}