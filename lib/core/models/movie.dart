class Movie {
  final String id;
  final String createdAt;
  final String synopsis;
  final int year;
  final String directors;
  final String posterUrl;
  final String category;
  final String country;
  final String title;

  Movie({
    required this.id,
    required this.createdAt,
    required this.synopsis,
    required this.year,
    required this.directors,
    required this.posterUrl,
    required this.category,
    required this.country,
    required this.title,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      synopsis: json['synopsis']?.toString() ?? '',
      year: int.tryParse(json['year']?.toString() ?? '') ?? 0,
      directors: json['directors']?.toString() ?? '',
      posterUrl: json['poster_url']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'synopsis': synopsis,
      'year': year,
      'directors': directors,
      'poster_url': posterUrl,
      'category': category,
      'country': country,
      'title': title,
    };
  }
}