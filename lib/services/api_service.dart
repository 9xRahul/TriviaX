import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:triviax/models/questions.dart';

class TriviaService {
  Future<List<Question>> fetchQuestions(String difficulty) async {
    final url = Uri.parse(
      "https://opentdb.com/api.php?amount=10&difficulty=$difficulty&type=multiple",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("questions loaded");
      final data = jsonDecode(response.body);
      return (data['results'] as List).map((q) => Question.fromApi(q)).toList();
    } else {
      throw Exception("Failed to load questions");
    }
  }
}
