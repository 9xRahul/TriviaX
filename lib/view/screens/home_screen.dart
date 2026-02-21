import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:triviax/controllers/admni_controller.dart';
import '../../controllers/quiz_controller.dart';
import '../../controllers/theme_controller.dart';
import 'quiz_screen.dart';
import 'admin_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          onPressed: () {
            Get.find<ThemeController>().toggleTheme();
          },
        ),
        title: const Text("TriviaX"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Text(
              "Choose Difficulty",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            _difficultyCard(ref, "Easy", Colors.green),
            _difficultyCard(ref, "Medium", Colors.orange),
            _difficultyCard(ref, "Hard", Colors.red),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.play_circle_outline),
                label: const Text("Play Custom Quiz"),
                onPressed: () {
                  final customQuestions = ref.read(adminProvider);

                  if (customQuestions.isEmpty) {
                    Get.snackbar(
                      "No Questions",
                      "Please create questions in Admin Mode first",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  ref
                      .read(quizProvider.notifier)
                      .startCustomQuiz(customQuestions);

                  Get.to(() => const QuizScreen());
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text("Admin Mode"),
                onPressed: () {
                  Get.to(() => const AdminScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _difficultyCard(WidgetRef ref, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          final difficulty = label.toLowerCase();

          await ref.read(quizProvider.notifier).startQuiz(difficulty);

          Get.to(() => const QuizScreen());
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
