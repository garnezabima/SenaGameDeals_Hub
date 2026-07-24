import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/game_model.dart';

class CheapSharkService {
  
  // --- PERUBAHAN DI SINI: Tambahkan (int page) ---
  Future<List<GameModel>> getGames(int page) async {
    final response = await http.get(
      Uri.parse(
        // --- PERUBAHAN DI SINI: Tambahkan &pageNumber=$page di akhir URL ---
        "https://www.cheapshark.com/api/1.0/deals?pageSize=20&pageNumber=$page",
      ),
    );

    final data = jsonDecode(response.body);

    return data
        .map<GameModel>(
          (item) => GameModel.fromJson(item),
        )
        .toList();
  }
}