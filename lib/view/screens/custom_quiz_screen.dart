import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triviax/controllers/admni_controller.dart';
import 'package:triviax/models/questions.dart';

import '../widgets/option_tile.dart';

class CustomQuizScreen extends ConsumerStatefulWidget {
  const CustomQuizScreen({super.key});

  @override
  ConsumerState<CustomQuizScreen> createState() => _CustomQuizScreenState();
}

class _CustomQuizScreenState extends ConsumerState<CustomQuizScreen> {
  int index = 0;
  int score = 0;
  int lives = 3;

  void _answer(String selected, Question question) {
    if (question.correctAnswers.contains(selected)) {
      score += 10;
    } else {
      lives--;
    }

    if (index + 1 < ref.read(adminProvider).length && lives > 0) {
      setState(() => index++);
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Quiz Finished"),
        content: Text("Your Score: $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Back"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(adminProvider);

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No Custom Questions Created")),
      );
    }

    final question = questions[index];

    return Scaffold(
      appBar: AppBar(title: Text("Lives: $lives")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              question.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...question.options.map(
              (opt) => Container(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () => _answer(opt, question),
                    child: Text(opt),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
