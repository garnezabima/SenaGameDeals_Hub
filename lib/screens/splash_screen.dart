import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Variabel untuk trigger animasi
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();

    // Jalankan animasi 100 milidetik setelah layar pertama kali dimuat
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isAnimated = true;
        });
      }
    });

    // Pindah ke layar berikutnya setelah 3 detik
    Timer(
      const Duration(seconds: 3),
      cekLogin,
    );
  }

  Future cekLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (!mounted) return;

    if (userId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigation(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF312E81),
              Color(0xFF6366F1),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            // --- BAGIAN LOGO DENGAN ANIMASI & GLOW ---
            AnimatedOpacity(
              opacity: _isAnimated ? 1.0 : 0.0, 
              duration: const Duration(seconds: 1),
              child: AnimatedScale(
                scale: _isAnimated ? 1.0 : 0.5, 
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutBack, 
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, 
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6366F1),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    "assets/images/sena.png", // NAMA FILE SUDAH DISESUAIKAN
                    width: 140,
                  ),
                ),
              ),
            ),
            // --- AKHIR BAGIAN LOGO ---

            const SizedBox(height: 30),

            // --- TEKS PREMIUM ---
            const Text(
              "SenaGameDeals Hub",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2, 
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Best Deals • Wishlist\nReviews • Dashboard",
              textAlign: TextAlign.center, 
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5, 
              ),
            ),
            
            const SizedBox(height: 40),

            const CircularProgressIndicator(
              color: Colors.white,
            ),
            
            const SizedBox(height: 15),
            
            const Text(
              "Loading...",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}