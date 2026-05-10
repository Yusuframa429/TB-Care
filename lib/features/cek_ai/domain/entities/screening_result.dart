/// Tingkat risiko hasil skrining.
enum RiskLevel { low, medium, high }

/// [ScreeningResult] - Entitas hasil perhitungan skrining TBC.
class ScreeningResult {
  final int totalScore;
  final RiskLevel riskLevel;
  final List<String> detectedSymptoms;
  final List<String> notDetectedSymptoms;

  ScreeningResult({
    required this.totalScore,
    required this.riskLevel,
    required this.detectedSymptoms,
    required this.notDetectedSymptoms,
  });
}
