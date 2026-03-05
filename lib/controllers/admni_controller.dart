import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triviax/models/questions.dart';

class AdminController extends StateNotifier<List<Question>> {
  AdminController() : super([]);

  void addQuestion(Question q) {
    state = [...state, q];
  }

  void deleteQuestion(int index) {
    final updated = [...state]..removeAt(index);
    state = updated;
  }
}

final adminProvider = StateNotifierProvider<AdminController, List<Question>>(
  (ref) => AdminController(),
);
