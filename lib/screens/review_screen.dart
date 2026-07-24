import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/review_service.dart';

class ReviewScreen extends StatefulWidget {
  final String gameId;
  final String title;
  final String thumb; 

  const ReviewScreen({
    super.key,
    required this.gameId,
    required this.title,
    required this.thumb, 
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final komentarController = TextEditingController();
  final ReviewService reviewService = ReviewService();

  int rating = 5;

  Future simpanReview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt('user_id') ?? 0;

    final result = await reviewService.addReview(
      userId: userId,
      gameId: widget.gameId,
      rating: rating,
      komentar: komentarController.text,
      title: widget.title, 
      thumb: widget.thumb, 
    );

    print(result);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Review berhasil disimpan",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tulis Review",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<int>(
              value: rating,
              items: [1, 2, 3, 4, 5]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        "$e ⭐",
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  rating = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: komentarController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Komentar",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: simpanReview,
              child: const Text(
                "Simpan Review",
              ),
            ),
          ],
        ),
      ),
    );
  }
}