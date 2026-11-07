class MovieRating {
  final int? id;
  final String createdAt;
  final double rating;
  final String note;
  final String movieId;
  final String watchDate;
  final int userId;
  final bool favorite;

  MovieRating({
    this.id,
    required this.createdAt,
    required this.rating,
    required this.note,
    required this.movieId,
    required this.watchDate,
    required this.userId,
    required this.favorite,
  });

  factory MovieRating.fromJson(Map<String, dynamic> json) {
    return MovieRating(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      createdAt: json['created_at']?.toString() ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      note: json['note']?.toString() ?? '',
      movieId: json['movie_id']?.toString() ?? '',
      watchDate: json['watch_date']?.toString() ?? '',
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? '1') ?? 1,
      favorite: json['favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'created_at': createdAt,
      'rating': rating,
      'note': note,
      'movie_id': movieId,
      'watch_date': watchDate,
      'user_id': userId,
      'favorite': favorite,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}