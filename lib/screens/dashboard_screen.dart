import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {

  final Map data;

  const DashboardScreen({
    super.key,
    required this.data,
  });

  Widget card(
    String title,
    dynamic value,
    IconData icon,
  ) {
    return Card(
      elevation: 5,
      child: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              size: 40,
            ),

            const SizedBox(height: 10),

            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Text(title),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Dashboard"),
      ),

      body: GridView.count(
        crossAxisCount: 2,
        padding:
            const EdgeInsets.all(16),

        children: [

          card(
            "Wishlist",
            data['total_wishlist'],
            Icons.favorite,
          ),

          card(
            "Sedang Main",
            data['sedang_main'],
            Icons.sports_esports,
          ),

          card(
            "Tamat",
            data['tamat'],
            Icons.check_circle,
          ),

          card(
            "Review",
            data['total_review'],
            Icons.star,
          ),
        ],
      ),
    );
  }
}