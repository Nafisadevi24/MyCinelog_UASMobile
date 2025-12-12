import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';
import '../models/movie_model.dart';
import '../models/user_model.dart';

class DataRepository {
  static final DataRepository _instance = DataRepository._internal();
  factory DataRepository() => _instance;
  DataRepository._internal();

  final _storage = LocalStorage('cinelog_data.json');

  List<User> users = [];
  List<Movie> movies = [];

  static const String _moviesKey = 'movies_data';
  static const String _usersKey = 'users_data';

  // 🔹 BASE URL TMDB
  static const String _tmdbBaseUrl = 'https://api.themoviedb.org/3';

  // 🔹 GANTI INI DENGAN "API Read Access Token" PUNYAMU (yang PANJANG)
  //    JANGAN pakai API Key yang pendek di sini.
  static const String _tmdbReadAccessToken =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0OTFmNWQ0MmNkMzRhOWIxYWNmZjQ1NTAyZGMyZGQ4NCIsIm5iZiI6MTc2NTIwNTYwNS40NjUsInN1YiI6IjY5MzZlNjY1NzBlNzc0NWNmYjA1ZGE1NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Tng_AExW3JhgjOHodTfnWhBan5NXYhQozwtYSTbh_hs';

  /// Muat data awal aplikasi (users + movies lokal / API)
  Future<void> loadInitialData() async {
    if (kIsWeb) {
      await _storage.ready;
      final storedMovies = _storage.getItem(_moviesKey);
      final storedUsers = _storage.getItem(_usersKey);

      if (storedMovies != null && storedUsers != null) {
        movies = (storedMovies as List)
            .map((e) => Movie.fromJson(e as Map<String, dynamic>))
            .toList();
        users = (storedUsers as List)
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        await _loadFromAssets();
        // coba ambil dari API, kalau gagal ya sudah pakai lokal saja
        try {
          await reloadMovies();
        } catch (e) {
          debugPrint('Gagal load TMDB pertama kali (web): $e');
        }
        await _saveAll();
      }
      return;
    }

    // 🔹 Android/iOS
    final prefs = await SharedPreferences.getInstance();
    final usersData = prefs.getString(_usersKey);
    final moviesData = prefs.getString(_moviesKey);

    if (usersData != null && moviesData != null) {
      final List ulist = json.decode(usersData);
      final List mlist = json.decode(moviesData);
      users = ulist.map((e) => User.fromJson(e)).toList();
      movies = mlist.map((e) => Movie.fromJson(e)).toList();
    } else {
      await _loadFromAssets();
      try {
        await reloadMovies();
      } catch (e) {
        debugPrint('Gagal load TMDB pertama kali (mobile): $e');
      }
      await _saveAll();
    }
  }

  /// 🔹 Ambil daftar film Indonesia dari TMDB (pakai Bearer Token v4)
  Future<void> loadMoviesFromApi({String? query}) async {
    Uri url;

    if (query == null || query.isEmpty) {
      // film Indonesia populer
      url = Uri.parse(
        '$_tmdbBaseUrl/discover/movie'
        '?language=id-ID'
        '&with_original_language=id'
        '&sort_by=popularity.desc',
      );
    } else {
      // pencarian film Indonesia
      url = Uri.parse(
        '$_tmdbBaseUrl/search/movie'
        '?language=id-ID'
        '&query=$query'
        '&include_adult=false',
      );
    }

    final headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer $_tmdbReadAccessToken',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final List results = body['results'] ?? [];

      movies = results
          .map((e) => Movie.fromTmdbJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Gagal mengambil data film dari TMDB (${response.statusCode})',
      );
    }
  }

  /// 🔹 Pencarian film
  Future<void> searchMovies(String query) async {
    await loadMoviesFromApi(query: query);
  }

  /// 🔹 users dari assets, movies dari API (kalau berhasil)
  Future<void> _loadFromAssets() async {
    final usersJson = await rootBundle.loadString('assets/users.json');
    final List ulist = json.decode(usersJson);
    users = ulist.map((e) => User.fromJson(e)).toList();

    // coba isi movies dengan API, tapi biarkan error naik ke atas
    await loadMoviesFromApi();
  }

  /// 🔹 Simpan ke storage
  Future<void> _saveAll() async {
    if (kIsWeb) {
      await _storage.ready;
      _storage.setItem(
        _moviesKey,
        movies.map((m) => m.toJson()).toList(),
      );
      _storage.setItem(
        _usersKey,
        users.map((u) => u.toJson()).toList(),
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _moviesKey,
        json.encode(movies.map((m) => m.toJson()).toList()),
      );
      await prefs.setString(
        _usersKey,
        json.encode(users.map((u) => u.toJson()).toList()),
      );
    }
  }

  // -------- AUTH ----------
  User? authenticate(String username, String password) {
    try {
      return users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  bool usernameExists(String username) {
    return users.any((u) => u.username == username);
  }

  Future<void> registerUser(String username, String password) async {
    users.add(User(username: username, password: password));
    await _saveAll();
  }

  // -------- MOVIE CRUD ----------
  List<Movie> getAllMovies() => movies;

  Movie? getMovieById(int id) {
    try {
      return movies.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addMovie(Movie m) async {
    movies.add(m);
    await _saveAll();
  }

  Future<void> updateMovie(Movie updated) async {
    final idx = movies.indexWhere((m) => m.id == updated.id);
    if (idx != -1) {
      movies[idx] = updated;
      await _saveAll();
    }
  }

  Future<void> deleteMovie(int id) async {
    movies.removeWhere((m) => m.id == id);
    await _saveAll();
  }

  int nextMovieId() {
    if (movies.isEmpty) return 1;
    return movies.map((m) => m.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  /// 🔹 Reload daftar film dari API lagi
  Future<void> reloadMovies() async {
    await loadMoviesFromApi();
    await _saveAll();
  }

  Future<void> resetToDefault() async {
    await _loadFromAssets();
    await _saveAll();
  }
}
