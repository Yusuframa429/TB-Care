import '../../domain/entities/jadwal_obat.dart';

/// [JadwalObatModel] - Model data layer untuk jadwal obat.
///
/// Bertanggung jawab untuk konversi antara:
/// - [JadwalObat] (entity domain) ↔ [Map<String, dynamic>] (format Hive)
///
/// Tidak menggunakan @HiveType/@HiveField agar tidak perlu
/// menjalankan build_runner.
class JadwalObatModel {
  final String id;
  final String namaObat;
  final String dosis;
  final String satuanDosis;
  final List<String> waktuMinum;
  final String kondisiMakan;
  final String frekuensi;
  final bool isNotifikasiAktif;
  final bool isGetar;
  final bool isSuara;
  final String catatan;

  const JadwalObatModel({
    required this.id,
    required this.namaObat,
    required this.dosis,
    required this.satuanDosis,
    required this.waktuMinum,
    required this.kondisiMakan,
    required this.frekuensi,
    required this.isNotifikasiAktif,
    required this.isGetar,
    required this.isSuara,
    required this.catatan,
  });

  /// Konversi dari entity domain ke model (untuk disimpan ke Hive).
  factory JadwalObatModel.fromEntity(JadwalObat entity) {
    return JadwalObatModel(
      id: entity.id,
      namaObat: entity.namaObat,
      dosis: entity.dosis,
      satuanDosis: entity.satuanDosis,
      waktuMinum: entity.waktuMinum,
      kondisiMakan: entity.kondisiMakan,
      frekuensi: entity.frekuensi,
      isNotifikasiAktif: entity.isNotifikasiAktif,
      isGetar: entity.isGetar,
      isSuara: entity.isSuara,
      catatan: entity.catatan,
    );
  }

  /// Konversi dari Map Hive ke model.
  factory JadwalObatModel.fromMap(Map<dynamic, dynamic> map) {
    return JadwalObatModel(
      id: map['id'] as String,
      namaObat: map['namaObat'] as String,
      dosis: map['dosis'] as String,
      satuanDosis: map['satuanDosis'] as String,
      waktuMinum: List<String>.from(map['waktuMinum'] as List),
      kondisiMakan: map['kondisiMakan'] as String,
      frekuensi: map['frekuensi'] as String,
      isNotifikasiAktif: map['isNotifikasiAktif'] as bool,
      isGetar: map['isGetar'] as bool,
      isSuara: map['isSuara'] as bool,
      catatan: map['catatan'] as String,
    );
  }

  /// Konversi dari model ke Map (untuk disimpan ke Hive).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaObat': namaObat,
      'dosis': dosis,
      'satuanDosis': satuanDosis,
      'waktuMinum': waktuMinum,
      'kondisiMakan': kondisiMakan,
      'frekuensi': frekuensi,
      'isNotifikasiAktif': isNotifikasiAktif,
      'isGetar': isGetar,
      'isSuara': isSuara,
      'catatan': catatan,
    };
  }

  /// Konversi dari model ke entity domain.
  JadwalObat toEntity() {
    return JadwalObat(
      id: id,
      namaObat: namaObat,
      dosis: dosis,
      satuanDosis: satuanDosis,
      waktuMinum: waktuMinum,
      kondisiMakan: kondisiMakan,
      frekuensi: frekuensi,
      isNotifikasiAktif: isNotifikasiAktif,
      isGetar: isGetar,
      isSuara: isSuara,
      catatan: catatan,
    );
  }
}
