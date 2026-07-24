import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class AuthService {

  Future register(
    String name,
    String email,
    String password,
  ) async {
    
    print("KIRIM REQUEST REGISTER");

    final response = await http.post(
      Uri.parse(
        "${ApiService.baseUrl}/register",
      ),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json", 
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    
    print("STATUS:");
    print(response.statusCode);
    print("BODY:");
    print(response.body);

    return jsonDecode(response.body);
  }

  Future login(
    String email,
    String password,
  ) async {
    
    print("KIRIM REQUEST LOGIN");

    final response = await http.post(
      Uri.parse(
        "${ApiService.baseUrl}/login",
      ),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json", 
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    // --- CEK RESPONSE LOGIN ---
    print("STATUS:");
    print(response.statusCode);
    print("BODY:");
    print(response.body);

    return jsonDecode(response.body);
  }
}