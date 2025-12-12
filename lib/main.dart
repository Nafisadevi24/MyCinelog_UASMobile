import 'package:flutter/material.dart';
import 'repository/data_repository.dart';
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/main_page.dart';
import 'pages/home_page.dart';
import 'pages/add_edit_page.dart';
import 'pages/detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataRepository().loadInitialData();
  runApp(const CineLogApp());
}

// ⬇⬇ CINELOG APP JADI STATEFUL + PUNYA of() & toggleTheme()
class CineLogApp extends StatefulWidget {
  const CineLogApp({Key? key}) : super(key: key);

  // supaya bisa dipanggil dari mana saja: CineLogApp.of(context)
  static _CineLogAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_CineLogAppState>()!;
  }

  @override
  State<CineLogApp> createState() => _CineLogAppState();
}

class _CineLogAppState extends State<CineLogApp> {
  ThemeMode _themeMode = ThemeMode.light;

  // dipanggil dari switch "Mode Gelap"
  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    // THEME TERANG (TIDAK DIUBAH)
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF1565C0),
      scaffoldBackgroundColor: const Color(0xFFE3F2FD),
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFF0D47A1)),
      ),
    );

    // THEME GELAP
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0D47A1),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );

    return MaterialApp(
      title: 'CineLog+',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode, // ⬅ PENTING
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (_) => const SplashPage(),
        LoginPage.routeName: (_) => LoginPage(),
        SignupPage.routeName: (_) => SignupPage(),
        MainPage.routeName: (_) => const MainPage(),
        HomePage.routeName: (_) => const HomePage(),
        AddEditPage.routeName: (_) => const AddEditPage(),
        DetailPage.routeName: (_) => const DetailPage(),
      },
    );
  }
}
