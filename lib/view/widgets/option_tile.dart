import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triviax/controllers/quiz_controller.dart';
import 'package:triviax/models/questions.dart';

class OptionTile extends ConsumerWidget {
  final String option;
  final Question question;

  const OptionTile({super.key, required this.option, required this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(quizProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: 300,
        child: ElevatedButton(
          onPressed: () => controller.answer(option),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(option),
        ),
      ),
    );
  }
}
