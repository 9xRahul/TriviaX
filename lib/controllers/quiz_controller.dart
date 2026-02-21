import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triviax/models/questions.dart';
import 'package:triviax/services/api_service.dart';

class QuizState {
  final List<Question> questions;
  final int index;
  final int score;
  final int lives;
  final bool isLoading;
  final bool isFinished;

  QuizState({
    this.questions = const [],
    this.index = 0,
    this.score = 0,
    this.lives = 3,
    this.isLoading = false,
    this.isFinished = false,
  });

  QuizState copyWith({
    List<Question>? questions,
    int? index,
    int? score,
    int? lives,
    bool? isLoading,
    bool? isFinished,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      index: index ?? this.index,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      isLoading: isLoading ?? this.isLoading,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class QuizController extends StateNotifier<QuizState> {
  QuizController() : super(QuizState());

  final TriviaService _service = TriviaService();

  String? lastDifficulty;

  Future<void> startQuiz(String difficulty) async {
    lastDifficulty = difficulty; // ✅ remember difficulty

    state = QuizState(isLoading: true);

    final questions = await _service.fetchQuestions(difficulty);

    state = QuizState(
      questions: questions,
      index: 0,
      score: 0,
      lives: 3,
      isLoading: false,
      isFinished: false,
    );
  }

  void answer(String selected) {
    final current = state.questions[state.index];

    int newScore = state.score;
    int newLives = state.lives;

    if (current.correctAnswers.contains(selected)) {
      newScore += 10;
    } else {
      newLives -= 1;
    }

    if (newLives <= 0 || state.index + 1 >= state.questions.length) {
      state = state.copyWith(
        score: newScore,
        lives: newLives,
        isFinished: true,
      );
    } else {
      state = state.copyWith(
        score: newScore,
        lives: newLives,
        index: state.index + 1,
      );
    }
  }

  void skip() {
    int newScore = state.score - 5;

    if (state.index + 1 >= state.questions.length) {
      state = state.copyWith(score: newScore, isFinished: true);
    } else {
      state = state.copyWith(score: newScore, index: state.index + 1);
    }
  }

  void reset() {
    state = QuizState();
  }

  void startCustomQuiz(List<Question> customQuestions) {
    state = QuizState(
      questions: customQuestions,
      index: 0,
      score: 0,
      lives: 3,
      isLoading: false,
      isFinished: false,
    );
  }

  Future<void> reloadIfEmpty() async {
    if (state.questions.isEmpty && lastDifficulty != null) {
      state = state.copyWith(isLoading: true);

      final questions = await _service.fetchQuestions(lastDifficulty!);

      state = state.copyWith(
        questions: questions,
        index: 0,
        score: 0,
        lives: 3,
        isLoading: false,
        isFinished: false,
      );
    }
  }
}

final quizProvider = StateNotifierProvider<QuizController, QuizState>(
  (ref) => QuizController(),
);
