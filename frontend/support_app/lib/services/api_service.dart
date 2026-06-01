import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_response.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:8000';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<ChatResponse> sendMessage({
    required String message,
    required String sessionId,
    required List<Map<String, String>> history,
  }) async {
    final uri = Uri.parse('$_baseUrl/chat');

    final body = jsonEncode({
      'session_id': sessionId,
      'message': message,
      'history': history,
    });

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ChatResponse.fromJson(json);
  }

  void dispose() => _client.close();
}
