import 'package:flutter/material.dart';
import '../repository/data_repository.dart';
import '../widgets/movie_card.dart';
import '../models/movie_model.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repo = DataRepository();
  bool isLoading = true;
  bool isError = false;
  String errorMsg = '';
  List<Movie> movies = [];
  final TextEditingController searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      await repo.loadMoviesFromApi();
      setState(() {
        movies = repo.getAllMovies();
      });
    } catch (e) {
      setState(() {
        isError = true;
        errorMsg = e.toString();
      });
    }

    setState(() => isLoading = false);
  }

  Future<void> searchMovies() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      await repo.searchMovies(searchC.text);
      setState(() => movies = repo.getAllMovies());
    } catch (e) {
      setState(() {
        isError = true;
        errorMsg = e.toString();
      });
    }

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Film Indonesia",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: loadMovies,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchC,
              decoration: InputDecoration(
                labelText: "Cari film...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    searchC.clear();
                    loadMovies();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (v) => searchMovies(),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
            if (isError)
              Expanded(
                child: Center(
                  child: Text(
                    "Gagal memuat film:\n$errorMsg",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            if (!isLoading && !isError)
              Expanded(
                child: movies.isEmpty
                    ? const Center(child: Text("Tidak ada film ditemukan"))
                    : ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, i) {
                          return MovieCard(movie: movies[i]);
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
