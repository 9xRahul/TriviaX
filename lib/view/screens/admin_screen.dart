import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triviax/controllers/admni_controller.dart';
import 'package:triviax/models/questions.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  late final GlobalKey<FormState> _formKey1;

  final questionController = TextEditingController();
  final optionControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  int correctIndex = 0;

  @override
  void initState() {
    super.initState();
    _formKey1 = GlobalKey<FormState>();
  }

  void _addQuestion() {
    if (_formKey1.currentState!.validate()) {
      final options = optionControllers.map((e) => e.text.trim()).toList();

      final question = Question(
        question: questionController.text.trim(),
        options: options,
        correctAnswers: [options[correctIndex]],
      );

      ref.read(adminProvider.notifier).addQuestion(question);

      questionController.clear();
      for (var c in optionControllers) {
        c.clear();
      }
      setState(() => correctIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(adminProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildForm(),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            const Text(
              "Created Questions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            for (int i = 0; i < questions.length; i++)
              _questionCard(questions[i], i),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey1,
      child: Column(
        children: [
          const Text(
            "Add New Question",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          TextFormField(
            controller: questionController,
            decoration: const InputDecoration(
              labelText: "Question",
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? "Enter question" : null,
          ),

          const SizedBox(height: 15),

          ...List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: optionControllers[index],
                decoration: InputDecoration(
                  labelText: "Option ${index + 1}",
                  border: const OutlineInputBorder(),
                  suffixIcon: Radio<int>(
                    value: index,
                    groupValue: correctIndex,
                    onChanged: (val) {
                      setState(() => correctIndex = val!);
                    },
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter option" : null,
              ),
            );
          }),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addQuestion,
              child: const Text("Add Question"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionCard(Question q, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              q.question,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            ...q.options.map(
              (opt) => Text(
                opt,
                style: TextStyle(
                  color: q.correctAnswers.contains(opt) ? Colors.green : null,
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  ref.read(adminProvider.notifier).deleteQuestion(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    questionController.dispose();
    for (var c in optionControllers) {
      c.dispose();
    }
    super.dispose();
  }
}
