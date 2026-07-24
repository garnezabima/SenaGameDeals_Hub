import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GameDeals Hub',
      
      // --- TEMA DARK MODE DITAMBAHKAN DI SINI ---
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF6366F1),
        cardColor: const Color(0xFF1E293B),
        
        // Opsional: Bikin AppBar menyatu dengan warna background biar makin elegan
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          elevation: 0,
        ),
      ),
      // --- AKHIR TEMA ---

      home: const SplashScreen(),
    );
  }
}