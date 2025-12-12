class Movie {
  int id;
  String judul;
  int tahun;
  String genre;
  int rating;
  String status;
  String review;
  String poster;

  Movie({
    required this.id,
    required this.judul,
    required this.tahun,
    required this.genre,
    required this.rating,
    required this.status,
    required this.review,
    required this.poster,
  });

  /// Data dari TMDB (film Indonesia)
  factory Movie.fromTmdbJson(Map<String, dynamic> j) {
    final releaseDate = j['release_date'] as String? ?? '';
    final yearString = releaseDate.isNotEmpty
        ? releaseDate.split('-').first
        : '0';
    final tahun = int.tryParse(yearString) ?? 0;

    // TMDB vote (0–10) → rating 1–5
    final voteAverage = (j['vote_average'] ?? 0) as num;
    int rating5 = (voteAverage / 2).round();
    if (rating5 < 1) rating5 = 1;
    if (rating5 > 5) rating5 = 5;

    // Ambil genre dari TMDB
    final List genreIds = j['genre_ids'] ?? [];

    // Mapping ID genre TMDB → nama genre
    final genreMap = {
      28: "Action",
      35: "Comedy",
      14: "Fantasy",
      27: "Horror",
      10749: "Romance",
    };

    String genre = "Lainnya";

    if (genreIds.isNotEmpty) {
      final id = genreIds.first;
      genre = genreMap[id] ?? "Lainnya";
    }

    return Movie(
      id: j['id'] as int,
      judul: j['title'] ?? '',
      tahun: tahun,
      genre: genre,
      rating: rating5,
      status: "Belum Ditonton", // ⬅ default baru agar tidak "Rilis"
      review: "",
      poster: j['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${j['poster_path']}'
          : 'assets/posters/default.jpg',
    );
  }

  /// Data dari storage lokal
  factory Movie.fromJson(Map<String, dynamic> j) => Movie(
    id: j['id'],
    judul: j['judul'],
    tahun: j['tahun'],
    genre: j['genre'],
    rating: j['rating'],
    status: j['status'],
    review: j['review'],
    poster: j['poster'] ?? 'assets/posters/default.jpg',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'judul': judul,
    'tahun': tahun,
    'genre': genre,
    'rating': rating,
    'status': status,
    'review': review,
    'poster': poster,
  };
}
