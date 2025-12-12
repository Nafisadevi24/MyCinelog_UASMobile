import 'package:flutter/material.dart';
import '../repository/data_repository.dart';

class SignupPage extends StatefulWidget {
  static const routeName = '/signup';
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final repo = DataRepository();
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String info = '';

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (repo.usernameExists(username.trim())) {
        setState(() => info = 'Username sudah digunakan');
      } else {
        try {
          await repo.registerUser(username.trim(), password);
          if (!mounted) return;

          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Registrasi berhasil! Silakan login.'),
            backgroundColor: Colors.green,
          ));
        } catch (e) {
          if (!mounted) return;
          setState(() => info = 'Error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFBBDEFB),
              Color(0xFF90CAF9),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0), // warna sama login
                      ),
                    ),
                    const SizedBox(height: 24),

                    // USERNAME
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      onChanged: (v) => username = v,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Isi username' : null,
                    ),
                    const SizedBox(height: 12),

                    // PASSWORD
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      onChanged: (v) => password = v,
                      validator: (v) =>
                          v == null || v.length < 4
                              ? 'Minimal 4 karakter'
                              : null,
                    ),
                    const SizedBox(height: 20),

                    // TOMBOL DAFTAR
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                      ),
                      child: const Text(
                        'Daftar',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),

                    // INFO ERROR
                    if (info.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(info,
                          style: const TextStyle(color: Colors.red)),
                    ],

                    // TOMBOL KEMBALI KE LOGIN
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Kembali ke Login',
                        style: TextStyle(
                          color: Color(0xFF1E88E5), // warna biru sama login
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
