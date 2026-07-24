import 'package:flutter/material.dart';
import '../models/game_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/wishlist_service.dart';
import 'review_screen.dart';

// Ingat untuk meng-import file ReviewScreen kamu di sini
// import 'review_screen.dart'; 

class GameDetailScreen extends StatelessWidget {
  final GameModel game;
  final WishlistService wishlistService = WishlistService();

  GameDetailScreen({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              game.thumb,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              game.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Harga Diskon: \$${game.salePrice}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              "Harga Normal: \$${game.normalPrice}",
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(height: 20),
            
            // --- Tombol Tambah ke Wishlist ---
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                int userId = prefs.getInt('user_id') ?? 0;

                final result = await wishlistService.addWishlist(
                  userId: userId,
                  gameId: game.gameID,
                  title: game.title,
                  thumb: game.thumb,
                  price: double.parse(game.salePrice),
                );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Berhasil ditambahkan ke Wishlist ❤️",
                      ),
                    ),
                  );
                }

                print(result);
              },
              child: const Text("Tambah ke Wishlist"),
            ),

            const SizedBox(height: 10), // Jarak antara kedua tombol

            // --- Tombol Tulis Review (BARU ditambahkan) ---
            // --- Tombol Tulis Review ---
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReviewScreen(
                      gameId: game.gameID,
                      title: game.title,
                      thumb: game.thumb, // <--- TAMBAHKAN BARIS INI
                    ),
                  ),
                );
              },
              child: const Text(
                "Tulis Review ⭐",
              ),
            ),
            
            const SizedBox(height: 20), // Memberi sedikit ruang kosong di bagian bawah layar
          ],
        ),
      ),
    );
  }
}