import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../controllers/quiz_controller.dart';
import 'result_screen.dart';
import '../widgets/life_widget.dart';
import '../widgets/option_tile.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  bool _isReloading = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizProvider);


    if (state.questions.isEmpty && !_isReloading) {
      _isReloading = true;

      Future.microtask(() async {
        final controller = ref.read(quizProvider.notifier);

        // Reload with last difficulty if stored
        if (controller.lastDifficulty != null) {
          await controller.startQuiz(controller.lastDifficulty!);
        }

        _isReloading = false;
      });

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

 
    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }


    if (state.isFinished) {
      Future.microtask(() {
        Get.off(() => ResultScreen(score: state.score));
      });
      return const SizedBox();
    }

    final question = state.questions[state.index];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LifeWidget(lives: state.lives),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: (state.index + 1) / state.questions.length,
              ),
              const SizedBox(height: 30),
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ...question.options.map(
                (opt) => OptionTile(option: opt, question: question),
              ),
              const Spacer(),
              TextButton(
                onPressed: ref.read(quizProvider.notifier).skip,
                child: const Text("Skip Question"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
