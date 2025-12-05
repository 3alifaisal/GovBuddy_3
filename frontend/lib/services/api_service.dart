import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class ApiService {
  // Use localhost for Android/iOS emulator mapping if needed, but for web/macOS localhost is fine.
  // For Android emulator use 10.0.2.2, for iOS/macOS use 127.0.0.1
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  /// Sends a chat message to the backend and returns the response.
  /// 
  /// [messages] is the list of chat history (including the new user message).
  /// [categoryId] is the ID of the current category (e.g. 'wohnen_und_mietvertrag').
  Future<String> sendChatRequest(List<ChatMessage> messages, String categoryId) async {
    final url = Uri.parse('$baseUrl/ask');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'messages': messages.map((m) => m.toJson()).toList(),
          'category': categoryId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Backend returns the full response object from the LLM service
        // Based on llm_service.py, it returns response.json() from the Academic Cloud API
        // which usually has the structure: { "choices": [ { "message": { "content": "..." } } ] }
        
        if (data is Map<String, dynamic>) {
          if (data.containsKey('choices') && (data['choices'] as List).isNotEmpty) {
             final choice = data['choices'][0];
             if (choice['message'] != null && choice['message']['content'] != null) {
               return choice['message']['content'];
             }
          }
          // Fallback if structure is different (e.g. direct content return)
          if (data.containsKey('content')) {
            return data['content'];
          }
        }
        
        return "Received response but could not parse content.";
      } else {
        throw Exception('Failed to load chat response: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
