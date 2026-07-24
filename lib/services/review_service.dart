import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ReviewService {

  // --- METHOD 1: addReview ---
  Future addReview({
    required int userId,
    required String gameId,
    required int rating,
    required String komentar,
    required String title,
    required String thumb,
  }) async {
    final response = await http.post(
      Uri.parse(
        "${ApiService.baseUrl}/reviews",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "user_id": userId,
        "game_id": gameId,
        "rating": rating,
        "komentar": komentar,
        "title": title,
        "thumb": thumb,
      }),
    );

    return jsonDecode(response.body);
  }

  // --- METHOD 2: getReviews ---
  Future getReviews() async {
    final response = await http.get(
      Uri.parse(
        "${ApiService.baseUrl}/reviews",
      ),
    );

    return jsonDecode(response.body);
  }

  // --- METHOD 3: updateReview (BARU DITAMBAHKAN) ---
  Future updateReview(
    int id,
    int rating,
    String komentar,
  ) async {
    final response = await http.put(
      Uri.parse(
        "${ApiService.baseUrl}/reviews/$id",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "rating": rating,
        "komentar": komentar,
      }),
    );

    return jsonDecode(response.body);
  }

  // --- METHOD 4: deleteReview (BARU DITAMBAHKAN - INI YANG BIKIN MERAH TADI) ---
  Future deleteReview(
    int id,
  ) async {
    final response = await http.delete(
      Uri.parse(
        "${ApiService.baseUrl}/reviews/$id",
      ),
    );

    return jsonDecode(response.body);
  }
}