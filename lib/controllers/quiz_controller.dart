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

  Future<void> startQuiz(String difficulty) async {
    state = state.copyWith(isLoading: true);

    final questions = await _service.fetchQuestions(difficulty);

    state = QuizState(questions: questions);
  }

  void answer(String selected) {
    final current = state.questions[state.index];

    if (current.correctAnswers.contains(selected)) {
      state = state.copyWith(score: state.score + 10);
    } else {
      final newLives = state.lives - 1;
      if (newLives == 0) {
        state = state.copyWith(lives: 0, isFinished: true);
        return;
      }
      state = state.copyWith(lives: newLives);
    }

    next();
  }

  void skip() {
    state = state.copyWith(score: state.score - 5);
    next();
  }

  void next() {
    if (state.index + 1 >= state.questions.length) {
      state = state.copyWith(isFinished: true);
    } else {
      state = state.copyWith(index: state.index + 1);
    }
  }

  void reset() {
    state = QuizState();
  }
}

final quizProvider = StateNotifierProvider<QuizController, QuizState>((ref) {
  return QuizController();
});
