import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learnforge_app/core/constants/api_constants.dart';
import 'package:learnforge_app/features/arena/data/models/question_model.dart';

class ArenaRepository {
  Future<List<QuestionModel>> getQuestions({
    required String topic,
    required String difficulty,
    int count = 5,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.arenaStart}')
        .replace(queryParameters: {
      'topic': topic,
      'difficulty': difficulty,
      'count': count.toString(),
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => QuestionModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> submitAnswers({
    required String userId,
    required Map<int, String> answers,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.arenaSubmit}')
        .replace(queryParameters: {'userId': userId}); // userId is @RequestParam

    try {
      // Map<int, String> to Map<String, String> because JSON keys must be strings
      final body = answers.map((key, value) => MapEntry(key.toString(), value));
      
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to submit answers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
