import 'dart:convert';

import 'package:chat_bot/const.dart';
import 'package:http/http.dart' as http;

class OpenAPI {


  Future<String> chatgptapi(String prompt) async {
    
    final List<Map<String,dynamic>>messages=[];
    messages.add({
      "role": "user", "content": " $prompt"
    });
    
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $APIkey",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages
        }),
      );
      print(response.body);

      if (response.statusCode == 200) {
        var resultcontent=jsonDecode(response.body)['choices'][0]['messages']['content'];
        resultcontent=resultcontent.trim();
        
        messages.add({"role": "assistant", "content": " $resultcontent"});
       
          return resultcontent;

      }

    }
    catch (e) {
      return e.toString();
    }
    return "An error occurred";
  }
  }


