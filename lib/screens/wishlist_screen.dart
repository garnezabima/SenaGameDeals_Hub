import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahan Import
import '../services/wishlist_service.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistService service = WishlistService();

  late Future wishlistFuture;
  int currentUserId = 0; // Menyimpan userId untuk dipakai saat refresh data

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi perantara karena initState tidak bisa async
    wishlistFuture = _loadWishlist(); 
  }

  // Fungsi perantara untuk mengambil userId dari SharedPreferences
  Future _loadWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getInt('user_id') ?? 0;
    
    // Sesuaikan dengan nama fungsi di WishlistService kamu
    return service.getWishlist(currentUserId); 
  }

  // Fungsi untuk memuat ulang data setelah update/delete
  void _refreshWishlist() {
    setState(() {
      wishlistFuture = service.getWishlist(currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wishlist Saya ❤️",
        ),
      ),
      body: FutureBuilder(
        future: wishlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final data = snapshot.data ?? [];

          // Jika data kosong
          if (data.isEmpty) {
            return const Center(
              child: Text("Wishlist kamu masih kosong"),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Image.network(
                    item['thumb'],
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    item['title'],
                  ),
                  subtitle: Text(
                    item['status'] ?? 'Wishlist',
                  ),
                  
                  // --- FITUR POPUP MENU ---
                  trailing: PopupMenuButton<String>( 
                    onSelected: (value) async {
                      if (value == "delete") {
                        await service.deleteWishlist(
                          item['id'],
                        );
                        _refreshWishlist(); // Panggil fungsi refresh
                      } else {
                        await service.updateWishlist(
                          item['id'],
                          value, 
                        );
                        _refreshWishlist(); // Panggil fungsi refresh
                      }
                    },
                    itemBuilder: (context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: "Wishlist",
                        child: Text(
                          "Wishlist ❤️",
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: "Sedang Main",
                        child: Text(
                          "Sedang Main 🎮",
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: "Tamat",
                        child: Text(
                          "Tamat ✅",
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: "delete",
                        child: Text(
                          "Hapus 🗑️",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}