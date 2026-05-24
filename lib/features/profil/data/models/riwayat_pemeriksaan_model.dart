import '../../../cek_ai/domain/entities/screening_result.dart';

/// [RiwayatPemeriksaanModel] - Model data untuk menyimpan riwayat pemeriksaan di database lokal.
///
/// Mendukung tipe pemeriksaan 'AI Check' dan 'Konsultasi'.
class RiwayatPemeriksaanModel {
  final String id;
  final String type; // 'AI Check' atau 'Konsultasi'
  final DateTime date;
  final String status; // 'RENDAH', 'SEDANG', 'TINGGI' atau 'Selesai'
  final String description; // Contoh: '3/6 gejala terdeteksi' atau nama dokter
  final String actionLabel; // 'Lihat Detail' atau 'Lihat Rekaman'

  // Field khusus untuk rekontruksi ScreeningResult (jika type == 'AI Check')
  final int? totalScore;
  final List<String>? detectedSymptoms;
  final List<String>? notDetectedSymptoms;

  RiwayatPemeriksaanModel({
    required this.id,
    required this.type,
    required this.date,
    required this.status,
    required this.description,
    required this.actionLabel,
    this.totalScore,
    this.detectedSymptoms,
    this.notDetectedSymptoms,
  });

  /// Konversi model ke format JSON untuk disimpan di SharedPreferences.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'date': date.toIso8601String(),
      'status': status,
      'description': description,
      'actionLabel': actionLabel,
      'totalScore': totalScore,
      'detectedSymptoms': detectedSymptoms,
      'notDetectedSymptoms': notDetectedSymptoms,
    };
  }

  /// Konstruksi model dari format JSON.
  factory RiwayatPemeriksaanModel.fromJson(Map<String, dynamic> json) {
    return RiwayatPemeriksaanModel(
      id: json['id'] as String,
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      description: json['description'] as String,
      actionLabel: json['actionLabel'] as String,
      totalScore: json['totalScore'] as int?,
      detectedSymptoms: json['detectedSymptoms'] != null
          ? List<String>.from(json['detectedSymptoms'] as List)
          : null,
      notDetectedSymptoms: json['notDetectedSymptoms'] != null
          ? List<String>.from(json['notDetectedSymptoms'] as List)
          : null,
    );
  }

  /// Konversi dari entitas [ScreeningResult] (Cek AI) ke [RiwayatPemeriksaanModel].
  factory RiwayatPemeriksaanModel.fromScreeningResult({
    required String id,
    required ScreeningResult result,
    required DateTime date,
  }) {
    String statusStr = 'RENDAH';
    if (result.riskLevel == RiskLevel.medium) statusStr = 'SEDANG';
    if (result.riskLevel == RiskLevel.high) statusStr = 'TINGGI';

    return RiwayatPemeriksaanModel(
      id: id,
      type: 'AI Check',
      date: date,
      status: statusStr,
      description: '${result.detectedSymptoms.length}/6 gejala terdeteksi',
      actionLabel: 'Lihat Detail',
      totalScore: result.totalScore,
      detectedSymptoms: result.detectedSymptoms,
      notDetectedSymptoms: result.notDetectedSymptoms,
    );
  }

  /// Rekonstruksi dari model ini kembali ke entitas [ScreeningResult] untuk detail halaman.
  ScreeningResult toScreeningResult() {
    RiskLevel rl = RiskLevel.low;
    if (status == 'SEDANG') rl = RiskLevel.medium;
    if (status == 'TINGGI') rl = RiskLevel.high;

    return ScreeningResult(
      totalScore: totalScore ?? 0,
      riskLevel: rl,
      detectedSymptoms: detectedSymptoms ?? [],
      notDetectedSymptoms: notDetectedSymptoms ?? [],
    );
  }

  /// Format tanggal ramah pengguna (Indonesian Style, contoh: "24 Mei 2026").
  String get formattedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
