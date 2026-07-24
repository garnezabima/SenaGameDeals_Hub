import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_service.dart';

class DashboardService {

  Future getDashboard() async {

    final response = await http.get(
      Uri.parse(
        "${ApiService.baseUrl}/dashboard",
      ),
    );

    return jsonDecode(response.body);
  }
}