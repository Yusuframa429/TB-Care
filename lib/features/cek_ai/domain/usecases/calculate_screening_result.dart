import '../entities/question.dart';
import '../entities/screening_result.dart';

/// [CalculateScreeningResult] - Use case untuk menghitung skor dan risiko.
class CalculateScreeningResult {
  ScreeningResult call(Map<String, QuestionOption> answers) {
    int totalScore = 0;
    List<String> detected = [];
    List<String> notDetected = [];

    // Hitung total skor dan kumpulkan gejala terdeteksi
    // G1-G6 adalah daftar gejala utama & sekunder
    answers.forEach((questionId, option) {
      totalScore += option.score;
      if (questionId.startsWith('G')) {
        if (option.score > 0) {
          detected.add(option.shortText);
        } else {
          notDetected.add(option.shortText);
        }
      }
    });

    // Klasifikasi Risiko Dasar
    RiskLevel risk = RiskLevel.low;
    if (totalScore >= 5) {
      risk = RiskLevel.high;
    } else if (totalScore >= 4) {
      risk = RiskLevel.medium;
    }

    // --- Safety Rules (Algoritma Keamanan) ---
    int g1Score = answers['G1']?.score ?? 0;
    int g2Score = answers['G2']?.score ?? 0;
    int g3Score = answers['G3']?.score ?? 0;
    int g4Score = answers['G4']?.score ?? 0;
    int g5Score = answers['G5']?.score ?? 0;
    int g7Score = answers['G7']?.score ?? 0;
    int r2Score = answers['R2']?.score ?? 0;

    // Rule 1: G1 == 3 (batuk >3 minggu) DAN G2 >= 1 (dahak) -> Naik 1 tingkat
    if (g1Score == 3 && g2Score >= 1) {
      if (risk == RiskLevel.low) {
        risk = RiskLevel.medium;
      } else if (risk == RiskLevel.medium) {
        risk = RiskLevel.high;
      }
    }

    // Rule 2: Trias Klasik TBC -> Naik 1 tingkat
    if (g3Score == 2 && g4Score == 2 && g5Score >= 1) {
      if (risk == RiskLevel.low) {
        risk = RiskLevel.medium;
      } else if (risk == RiskLevel.medium) {
        risk = RiskLevel.high;
      }
    }

    // Rule 3: R2 >= 2 (HIV+) -> Minimal Medium
    if (r2Score >= 2) {
      if (risk == RiskLevel.low) {
        risk = RiskLevel.medium;
      }
    }

    // Rule 4: Semua gejala = 0 -> Low
    bool allSymptomsZero =
        g1Score == 0 &&
        g2Score == 0 &&
        g3Score == 0 &&
        g4Score == 0 &&
        g5Score == 0 &&
        g7Score == 0 &&
        (answers['G6']?.score ?? 0) == 0;

    if (allSymptomsZero) {
      risk = RiskLevel.low;
    }

    return ScreeningResult(
      totalScore: totalScore,
      riskLevel: risk,
      detectedSymptoms: detected,
      notDetectedSymptoms: notDetected,
    );
  }
}
