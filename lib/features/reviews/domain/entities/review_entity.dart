// ============================================================
// FILE: lib/features/reviews/domain/entities/review_entity.dart
// ============================================================
class ReviewEntity {
  final String id;
  final String reviewerId;
  final String reviewerName;
  final String? reviewerAvatar;
  final String providerId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.reviewerId,
    required this.reviewerName,
    this.reviewerAvatar,
    required this.providerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
