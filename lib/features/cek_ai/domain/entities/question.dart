/// [QuestionOption] - Pilihan jawaban untuk kuesioner.
class QuestionOption {
  final String text;
  final int score;
  final String shortText;

  const QuestionOption({
    required this.text,
    required this.score,
    required this.shortText,
  });
}

/// [ScreeningQuestion] - Entitas untuk pertanyaan kuesioner.
class ScreeningQuestion {
  final String id;
  final String text;
  final List<QuestionOption> options;

  const ScreeningQuestion({
    required this.id,
    required this.text,
    required this.options,
  });
}
