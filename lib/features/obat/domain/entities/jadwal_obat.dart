import 'dart:convert';

/// [JadwalObat] - Entity yang merepresentasikan satu jadwal obat.
///
/// Setiap JadwalObat mewakili satu jenis obat dengan jadwal
/// waktu minumnya. Misalnya: Rifampicin diminum jam 08:00 dan 20:00.
class JadwalObat {
  final String id;
  final String namaObat;
  final int jumlahDosis;
  final String satuanDosis;
  final List<String> waktuMinum; // ["08:00", "20:00"]
  final String kondisiMakan;
  final String frekuensi;
  final String? catatan;

  JadwalObat({
    required this.id,
    required this.namaObat,
    this.jumlahDosis = 1,
    this.satuanDosis = 'tablet',
    required this.waktuMinum,
    this.kondisiMakan = 'Sebelum makan',
    this.frekuensi = 'Setiap hari',
    this.catatan,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'namaObat': namaObat,
        'jumlahDosis': jumlahDosis,
        'satuanDosis': satuanDosis,
        'waktuMinum': waktuMinum,
        'kondisiMakan': kondisiMakan,
        'frekuensi': frekuensi,
        'catatan': catatan,
      };

  factory JadwalObat.fromJson(Map<String, dynamic> json) => JadwalObat(
        id: json['id'] as String,
        namaObat: json['namaObat'] as String,
        jumlahDosis: json['jumlahDosis'] as int? ?? 1,
        satuanDosis: json['satuanDosis'] as String? ?? 'tablet',
        waktuMinum: List<String>.from(json['waktuMinum'] as List),
        kondisiMakan: json['kondisiMakan'] as String? ?? 'Sebelum makan',
        frekuensi: json['frekuensi'] as String? ?? 'Setiap hari',
        catatan: json['catatan'] as String?,
      );

  /// Encode list ke JSON string untuk SharedPreferences.
  static String encodeList(List<JadwalObat> list) =>
      jsonEncode(list.map((e) => e.toJson()).toList());

  /// Decode JSON string ke list JadwalObat.
  static List<JadwalObat> decodeList(String jsonStr) =>
      (jsonDecode(jsonStr) as List)
          .map((e) => JadwalObat.fromJson(e as Map<String, dynamic>))
          .toList();
}
