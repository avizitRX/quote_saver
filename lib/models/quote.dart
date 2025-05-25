import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final String? id; // Firestore document ID
  final String text;
  final String author;
  final String? userId;
  final List<String> likes;
  final DateTime? timestamp;

  const Quote({
    this.id,
    required this.text,
    required this.author,
    this.userId,
    this.likes = const [],
    this.timestamp,
  });

  // create a Quote from a Firestore DocumentSnapshot
  factory Quote.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception("Document data was null for Quote.fromSnapshot");
    }
    return Quote(
      id: snap.id,
      text: data['text'] as String? ?? '',
      author: data['author'] as String? ?? '',
      userId: data['userId'] as String?,
      likes: List<String>.from(data['likes'] as List? ?? []),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  // Quote object to a Map
  Map<String, dynamic> toDocument() {
    return {
      'text': text,
      'author': author,
      'userId': userId,
      'likes': likes,
      'timestamp':
          timestamp != null
              ? Timestamp.fromDate(timestamp!)
              : FieldValue.serverTimestamp(),
    };
  }

  Quote copyWith({
    String? id,
    String? text,
    String? author,
    String? userId,
    List<String>? likes,
    DateTime? timestamp,
  }) {
    return Quote(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      userId: userId ?? this.userId,
      likes: likes ?? this.likes,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [id, text, author, userId, likes, timestamp];
}
