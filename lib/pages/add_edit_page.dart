import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../repository/data_repository.dart';

class AddEditPage extends StatefulWidget {
  static const routeName = '/add_edit';
  const AddEditPage({Key? key}) : super(key: key);

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  // 🔹 Semua kemungkinan status (lama + baru + dari TMDB)
  static const List<String> _statusOptions = [
    'Rilis', // dari TMDB
    'Belum Ditonton', // data lama
    'Sudah Ditonton', // data lama
    'Ingin Ditonton',
    'Sedang Ditonton',
    'Selesai Ditonton',
  ];

  late DataRepository repo;
  final _form = GlobalKey<FormState>();
  bool isEdit = false;
  Movie? editing;

  final _judulController = TextEditingController();
  final _tahunController = TextEditingController();
  final _reviewController = TextEditingController();
  final _posterController = TextEditingController();

  String genre = '';
  String status = 'Ingin Ditonton'; // default
  int rating = 3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    repo = DataRepository();

    final argsRaw = ModalRoute.of(context)!.settings.arguments;

    // ⬇ ambil id film kalau dipanggil untuk EDIT
    if (argsRaw is Map) {
      final id = argsRaw['id'] as int?;
      if (id != null) _loadMovie(id);
    } else if (argsRaw is int) {
      _loadMovie(argsRaw);
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _tahunController.dispose();
    _reviewController.dispose();
    _posterController.dispose();
    super.dispose();
  }

  void _loadMovie(int id) {
    final m = repo.getMovieById(id);
    if (m != null) {
      setState(() {
        isEdit = true;
        editing = m;

        _judulController.text = m.judul;
        genre = m.genre;

        // kalau status di data tidak ada di list, fallback ke "Ingin Ditonton"
        status = _statusOptions.contains(m.status) ? m.status : 'Ingin Ditonton';

        _tahunController.text = m.tahun.toString();
        rating = m.rating;
        _reviewController.text = m.review;
        _posterController.text = m.poster;
      });
    }
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;

    final judul = _judulController.text.trim();
    final tahun = int.tryParse(_tahunController.text) ?? DateTime.now().year;
    final review = _reviewController.text.trim();
    final poster = _posterController.text.trim().isEmpty
        ? 'assets/posters/default.jpg'
        : _posterController.text.trim();

    if (genre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih genre terlebih dahulu')),
      );
      return;
    }

    // 🔹 SUSUN OBJEK MOVIE DARI FORM
    final Movie dataBaru = Movie(
      id: isEdit && editing != null
          ? editing!.id
          : repo.nextMovieId(),
      judul: judul,
      tahun: tahun,
      genre: genre,
      rating: rating,
      status: status,
      review: review,
      poster: poster,
    );

    if (isEdit && editing != null) {
      // EDIT → ganti entry yang lama
      await repo.updateMovie(dataBaru);
    } else {
      // TAMBAH BARU
      await repo.addMovie(dataBaru);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF121212), Color(0xFF1E1E1E), Color(0xFF000000)]
              : const [Color(0xFFB3E5FC), Color(0xFF81D4FA), Color(0xFF0288D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(isEdit ? 'Edit Film' : 'Tambah Film'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color(0xFF0D47A1),
          ),
          titleTextStyle: const TextStyle(
            color: Color(0xFF0D47A1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                // JUDUL
                TextFormField(
                  controller: _judulController,
                  decoration: _decoration('Judul Film'),
                  validator: (v) => v == null || v.isEmpty
                      ? 'Judul tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 12),

                // GENRE
                DropdownButtonFormField<String>(
                  value: genre.isNotEmpty ? genre : null,
                  decoration: _decoration('Genre'),
                  dropdownColor: const Color(0xFF81D4FA),
                  items: const [
                    'Film Indonesia', // biar film dari TMDB aman
                    'Action',
                    'Comedy',
                    'Fantasy',
                    'Horror',
                    'Romance',
                    'Lainnya',
                  ].map((g) {
                    return DropdownMenuItem(
                      value: g,
                      child: Text(
                        g,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => genre = v ?? ''),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Pilih genre' : null,
                ),
                const SizedBox(height: 12),

                // TAHUN
                TextFormField(
                  controller: _tahunController,
                  decoration: _decoration('Tahun'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final year = int.tryParse(v ?? '');
                    if (v == null || v.isEmpty) {
                      return 'Tahun tidak boleh kosong';
                    }
                    if (year == null) return 'Masukkan tahun valid';
                    if (year < 1900 || year > 2100) {
                      return 'Tahun tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // STATUS
                DropdownButtonFormField<String>(
                  value: _statusOptions.contains(status)
                      ? status
                      : 'Ingin Ditonton',
                  decoration: _decoration('Status'),
                  dropdownColor: const Color(0xFF81D4FA),
                  items: _statusOptions
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(
                            s,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => status = v ?? status),
                ),
                const SizedBox(height: 12),

                // RATING
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Rating:',
                        style: TextStyle(
                          color: Color(0xFF0D47A1),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButton<int>(
                          value: rating,
                          isExpanded: true,
                          dropdownColor: Color(0xFF81D4FA),
                          underline: const SizedBox(),
                          onChanged: (int? val) {
                            setState(() {
                              rating = val ?? rating;
                            });
                          },
                          items: List.generate(
                            5,
                            (index) => DropdownMenuItem<int>(
                              value: index + 1,
                              child: Row(
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: const TextStyle(color: Color(0xFF1565C0)),
                                  ),
                                  const SizedBox(width: 8),
                                  ...List.generate(
                                    index + 1,
                                    (i) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // REVIEW
                TextFormField(
                  controller: _reviewController,
                  decoration: _decoration('Review Singkat'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),

                // POSTER
                TextFormField(
                  controller: _posterController,
                  decoration: _decoration('Path Poster'),
                ),
                const SizedBox(height: 24),

                // BUTTON SIMPAN
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF0D47A1), // label biru tua
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black, // garis hitam
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black, // garis hitam saat fokus
            width: 2,
          ),
        ),
      );
}
