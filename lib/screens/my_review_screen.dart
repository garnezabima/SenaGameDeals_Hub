import 'package:flutter/material.dart';
import '../services/review_service.dart';

class MyReviewScreen extends StatefulWidget {
  const MyReviewScreen({super.key});

  @override
  State<MyReviewScreen> createState() => _MyReviewScreenState();
}

class _MyReviewScreenState extends State<MyReviewScreen> {
  final ReviewService service = ReviewService();

  late Future reviewFuture;

  @override
  void initState() {
    super.initState();
    reviewFuture = service.getReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Review Saya ⭐",
        ),
      ),
      body: FutureBuilder(
        future: reviewFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text("Kamu belum menulis review apapun."),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: item['thumb'] != null
                      ? Image.network(
                          item['thumb'],
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.videogame_asset, size: 70),
                  title: Text(
                    item['title'] ?? 'Game Tanpa Judul',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "⭐ ${item['rating']}",
                      ),
                      Text(
                        item['komentar'] ?? '',
                      ),
                    ],
                  ),
                  
                  // --- POPUP MENU BUTTON MULAI DI SINI ---
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      
                      // KITA SIAPKAN ID REVIEW-NYA DULU (AMANKAN JADI ANGKA)
                      int idReview = int.parse(item['id'].toString());

                      if (value == "delete") {
                        await service.deleteReview(idReview);
                        setState(() {
                          reviewFuture = service.getReviews();
                        });
                      } 
                      
                      // --- FITUR EDIT DENGAN ALERT DIALOG ---
                      else if (value == "edit") {
                        final komentarController = TextEditingController(
                          text: item['komentar'] ?? '',
                        );

                        // Amankan rating jadi angka (default 5 kalau gagal)
                        int rating = int.tryParse(item['rating'].toString()) ?? 5;

                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Edit Review"),
                              content: StatefulBuilder(
                                builder: (context, setDialogState) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DropdownButton<int>(
                                        value: rating,
                                        items: [1, 2, 3, 4, 5]
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text("$e ⭐"),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setDialogState(() {
                                            rating = value!;
                                          });
                                        },
                                      ),
                                      TextField(
                                        controller: komentarController,
                                        decoration: const InputDecoration(
                                          labelText: "Komentar",
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Batal"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    // Update menggunakan idReview yang sudah dijamin angka
                                    await service.updateReview(
                                      idReview,
                                      rating,
                                      komentarController.text,
                                    );

                                    if (!mounted) return;
                                    Navigator.pop(context);

                                    setState(() {
                                      reviewFuture = service.getReviews();
                                    });
                                  },
                                  child: const Text("Simpan"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      // --- AKHIR FITUR EDIT ---
                    },
                    itemBuilder: (context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: "edit",
                        child: Text("Edit ✏️"),
                      ),
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