import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../service/chat_service.dart';
import '../views/components/chat_message.dart';

class ChatRepository {
  final ChatService _chatService;
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";

  ChatRepository(this._chatService);

  Future<List<ChatMessage>> getLocalMessages() async {
    return _chatService.getMessages();
  }

  Future<ChatMessage> sendMessage(String userMessage) async {
    final userChat = ChatMessage(text: userMessage, sender: "user", timestamp: DateTime.now());
    await _chatService.addMessage(userChat);

    // Fetch response from API
    final botResponse = await _fetchBotResponse(userMessage);
    final botChat = ChatMessage(text: botResponse, sender: "bot", timestamp: DateTime.now());

    await _chatService.addMessage(botChat);
    return botChat;
  }

  Future<String> _fetchBotResponse(String prompt) async {
    if (_apiKey.isEmpty) {
      return "Error: API key is missing";
    }

    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_apiKey"
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "No response";
    } else {
      return "Error: ${response.statusCode} - ${response.reasonPhrase}";
    }
  }
}