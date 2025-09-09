class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final List<int> genreIds;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      genreIds: (json['genre_ids'] != null)
          ? List<int>.from(json['genre_ids'])
          : <int>[],
    );
  }
}
