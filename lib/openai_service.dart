import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> messages = [];
  final YOUR_API_KEY ="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";

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $YOUR_API_KEY',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      print("the status code is ${res.statusCode}");
      print("the response body is ${res.body}");

      if (res.statusCode == 200) {
        String content =
        jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

}