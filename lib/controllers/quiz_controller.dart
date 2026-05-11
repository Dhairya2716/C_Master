import 'package:c_master/controllers/progress_controller.dart';
import 'package:c_master/models/progress_model.dart';
import 'package:c_master/models/question_model.dart';
import 'package:c_master/views/quiz/quiz_data.dart';
import 'package:get/get.dart';

class QuizController extends GetxController {
  final questions = <Question>[].obs;
  final currentIndex = 0.obs;
  final selectedAnswers = <int, int>{}.obs; // questionIndex → chosenOption
  final score = 0.obs;
  final isFinished = false.obs;
  final currentTopic = ''.obs;

  // Shortcut getters
  Question? get currentQuestion =>
      questions.isNotEmpty && currentIndex.value < questions.length
          ? questions[currentIndex.value]
          : null;

  int? get selectedAnswerForCurrent => selectedAnswers[currentIndex.value];
  bool get hasAnswered => selectedAnswers.containsKey(currentIndex.value);
  bool get isLastQuestion => currentIndex.value == questions.length - 1;

  double get progressPercent =>
      questions.isEmpty ? 0 : (currentIndex.value + 1) / questions.length;

  // ── Start ─────────────────────────────────────────────────────────────────

  void startQuiz(String topic) {
    currentTopic.value = topic;
    final q = questionsForTopic(topic).toList();
    q.shuffle();
    questions.value = q;
    currentIndex.value = 0;
    selectedAnswers.clear();
    score.value = 0;
    isFinished.value = false;
  }

  void startAllTopicsQuiz() {
    currentTopic.value = 'All Topics';
    final q = List<Question>.from(allQuestions)..shuffle();
    questions.value = q.take(20).toList(); // 20-question mixed quiz
    currentIndex.value = 0;
    selectedAnswers.clear();
    score.value = 0;
    isFinished.value = false;
  }

  // ── Answer ────────────────────────────────────────────────────────────────

  void selectAnswer(int optionIndex) {
    if (hasAnswered) return; // prevent changing answer
    selectedAnswers[currentIndex.value] = optionIndex;
    if (optionIndex == currentQuestion!.correctIndex) {
      score.value++;
    }
  }

  void nextQuestion() {
    if (!hasAnswered) return;
    if (isLastQuestion) {
      finishQuiz();
    } else {
      currentIndex.value++;
    }
  }

  // ── Finish ────────────────────────────────────────────────────────────────

  Future<void> finishQuiz() async {
    isFinished.value = true;

    final attempt = QuizAttempt(
      topic: currentTopic.value,
      score: score.value,
      total: questions.length,
      date: DateTime.now(),
    );

    // Save via ProgressController
    final progressCtrl = Get.find<ProgressController>();
    await progressCtrl.recordQuizAttempt(attempt);

    Get.toNamed('/quiz_result');
  }
}
