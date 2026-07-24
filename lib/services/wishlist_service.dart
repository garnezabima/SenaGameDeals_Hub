import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_service.dart';

class WishlistService {

  // --- METHOD 1: addWishlist ---
  Future addWishlist({
    required int userId,
    required String gameId,
    required String title,
    required String thumb,
    required double price,
  }) async {
    final response = await http.post(
      Uri.parse(
        "${ApiService.baseUrl}/wishlists",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "user_id": userId,
        "game_id": gameId,
        "title": title,
        "thumb": thumb,
        "price": price,
        "status": "Wishlist"
      }),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    return jsonDecode(response.body);
  }

  // --- METHOD 2: getWishlists ---
  Future getWishlist(
  int userId,
) async {

  final response =
      await http.get(
    Uri.parse(
      "${ApiService.baseUrl}/wishlists?user_id=$userId",
    ),
  );

  return jsonDecode(
    response.body,
  );
}

  // --- METHOD 3: updateWishlist ---
  Future updateWishlist(
    int id,
    String status,
  ) async {
    final response = await http.put(
      Uri.parse(
        "${ApiService.baseUrl}/wishlists/$id",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "status": status,
      }),
    );

    return jsonDecode(response.body);
  }

  //---method delete--
  Future deleteWishlist(
  int id,
) async {

  final response = await http.delete(
    Uri.parse(
      "${ApiService.baseUrl}/wishlists/$id",
    ),
  );

  return jsonDecode(response.body);
}
}