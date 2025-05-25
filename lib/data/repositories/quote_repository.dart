import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/quote.dart';

class PaginationResult {
  final List<Quote> quotes;
  final DocumentSnapshot? lastDocument;

  PaginationResult({required this.quotes, this.lastDocument});
}

class QuoteRepository {
  final FirebaseFirestore firestore;

  QuoteRepository({required this.firestore});

  // Add new quote
  Future<void> addQuote(Quote quote) async {
    if (quote.userId == null || quote.userId!.isEmpty) {
      throw Exception('User ID is required to add a quote.');
    }
    try {
      await firestore
          .collection('users')
          .doc(quote.userId)
          .collection('quotes')
          .add(quote.toDocument());
    } on FirebaseException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred while adding quote: $e');
    }
  }

  // Update existing quote
  Future<void> updateQuote(String userId, Quote quote) async {
    if (quote.id == null || quote.id!.isEmpty) {
      throw Exception('Quote ID is required to update a quote.');
    }
    if (quote.userId == null || quote.userId!.isEmpty) {
      throw Exception('Quote owner ID is required to update a quote.');
    }
    try {
      await firestore
          .collection('users')
          .doc(quote.userId)
          .collection('quotes')
          .doc(quote.id)
          .update(quote.toDocument());
    } on FirebaseException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred while updating quote: $e');
    }
  }

  // Get quotes for a specific user
  Stream<List<Quote>> getUserQuotesStream(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('quotes')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Quote.fromSnapshot(doc)).toList();
        });
  }

  // Get all quotes for global feed
  Stream<PaginationResult> getAllQuotesPaginatedStream({
    required int limit,
    DocumentSnapshot? startAfterDocument,
  }) {
    Query query = firestore
        .collectionGroup('quotes')
        .orderBy('timestamp', descending: true);

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    query = query.limit(limit);

    return query.snapshots().map((snapshot) {
      final List<Quote> quotes =
          snapshot.docs.map((doc) => Quote.fromSnapshot(doc)).toList();
      final DocumentSnapshot? lastDocument =
          snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      return PaginationResult(quotes: quotes, lastDocument: lastDocument);
    });
  }

  // Get quotes liked by a user
  Stream<List<Quote>> getLikedQuotesStream(String likingUserId) {
    return firestore
        .collection('users')
        .doc(likingUserId)
        .collection('liked_quotes')
        .orderBy('likedAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          // fetch the actual quote from its original location
          final List<Future<Quote?>> fetchFutures =
              snapshot.docs.map((doc) async {
                final data = doc.data();
                final String? originalQuoteId =
                    data['originalQuoteId'] as String?;
                final String? originalQuoteOwnerId =
                    data['originalQuoteOwnerId'] as String?;

                if (originalQuoteId != null && originalQuoteOwnerId != null) {
                  try {
                    final DocumentSnapshot originalQuoteSnap =
                        await firestore
                            .collection('users')
                            .doc(originalQuoteOwnerId)
                            .collection('quotes')
                            .doc(originalQuoteId)
                            .get();
                    if (originalQuoteSnap.exists) {
                      return Quote.fromSnapshot(originalQuoteSnap);
                    }
                  } catch (e) {
                  }
                }
                return null;
              }).toList();

          // filter out nulls
          final List<Quote> likedQuotes =
              (await Future.wait(fetchFutures)).whereType<Quote>().toList();
          return likedQuotes;
        });
  }

  // Delete a quote
  Future<void> deleteQuote(String userId, String quoteId) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('quotes')
          .doc(quoteId)
          .delete();
    } on FirebaseException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred while deleting quote: $e');
    }
  }

  // toggle like status
  Future<void> toggleLike(String likingUserId, Quote quote) async {
    final DocumentReference originalQuoteRef = firestore
        .collection('users')
        .doc(quote.userId) // The owner of the quote
        .collection('quotes')
        .doc(quote.id);

    final DocumentReference likedQuoteRef = firestore
        .collection('users')
        .doc(likingUserId) // The user who is liking/unliking
        .collection('liked_quotes')
        .doc(
          quote.id,
        ); // original quote ID as the liked_quote document ID

    await firestore.runTransaction((transaction) async {
      final DocumentSnapshot snapshot = await transaction.get(originalQuoteRef);

      if (!snapshot.exists) {
        throw Exception("Original quote does not exist!");
      }

      final List<String> currentLikes = List<String>.from(
        snapshot.get('likes') as List? ?? [],
      );

      if (currentLikes.contains(likingUserId)) {
        // User has already liked it, so unlike
        currentLikes.remove(likingUserId);
        transaction.update(originalQuoteRef, {'likes': currentLikes});
        transaction.delete(
          likedQuoteRef,
        ); // Remove from liked_quotes subcollection
      } else {
        // User has not liked it, so like
        currentLikes.add(likingUserId);
        transaction.update(originalQuoteRef, {'likes': currentLikes});
        transaction.set(likedQuoteRef, {
          // Add to liked_quotes subcollection
          'originalQuoteOwnerId': quote.userId,
          'originalQuoteId': quote.id,
          'likedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }
}
