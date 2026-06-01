import 'dart:convert';

/// [JadwalObat] - Entity murni untuk jadwal minum obat.
///
/// Digunakan oleh seluruh layer (domain, data, presentation).
/// Menyertakan [encodeList] dan [decodeList] untuk serialisasi
/// ke SharedPreferences.
class JadwalObat {
  /// ID unik jadwal (epoch milliseconds sebagai string).
  final String id;

  /// Nama obat (misal: "Rifampicin").
  final String namaObat;

  /// Jumlah dosis sebagai angka (misal: 1, 2).
  final int jumlahDosis;

  /// Satuan dosis (misal: "tablet", "kapsul", "ml").
  final String satuanDosis;

  /// List jam minum dalam format "HH:mm" (misal: ["08:00", "20:00"]).
  final List<String> waktuMinum;

  /// Kondisi makan ("Sebelum makan", "Saat makan", "Setelah makan").
  final String kondisiMakan;

  /// Frekuensi minum ("Setiap hari", "Setiap 2 hari", dll.) — opsional.
  final String? frekuensi;

  /// Catatan tambahan dari pengguna — opsional.
  final String? catatan;

  /// Apakah notifikasi aktif untuk jadwal ini.
  /// Default: `true` agar pengingat langsung aktif saat jadwal dibuat.
  final bool isNotifikasiAktif;

  /// Apakah getar (vibration) aktif saat notifikasi muncul.
  /// Hanya relevan jika [isNotifikasiAktif] bernilai `true`.
  final bool isGetar;

  /// Apakah suara (sound) aktif saat notifikasi muncul.
  /// Hanya relevan jika [isNotifikasiAktif] bernilai `true`.
  final bool isSuara;

  const JadwalObat({
    required this.id,
    required this.namaObat,
    required this.jumlahDosis,
    required this.satuanDosis,
    required this.waktuMinum,
    required this.kondisiMakan,
    this.frekuensi,
    this.catatan,
    this.isNotifikasiAktif = true,
    this.isGetar = true,
    this.isSuara = false,
  });

  // ── Serialisasi ────────────────────────────────────────────

  /// Konversi entity ke Map (untuk disimpan ke SharedPreferences / JSON).
  Map<String, dynamic> toJson() => {
    'id': id,
    'namaObat': namaObat,
    'jumlahDosis': jumlahDosis,
    'satuanDosis': satuanDosis,
    'waktuMinum': waktuMinum,
    'kondisiMakan': kondisiMakan,
    'frekuensi': frekuensi,
    'catatan': catatan,
    'isNotifikasiAktif': isNotifikasiAktif,
    'isGetar': isGetar,
    'isSuara': isSuara,
  };

  /// Buat entity dari Map JSON (setelah dibaca dari SharedPreferences).
  factory JadwalObat.fromJson(Map<String, dynamic> json) => JadwalObat(
    id: json['id'] as String,
    namaObat: json['namaObat'] as String,
    jumlahDosis: (json['jumlahDosis'] as num).toInt(),
    satuanDosis: json['satuanDosis'] as String,
    waktuMinum: List<String>.from(json['waktuMinum'] as List),
    kondisiMakan: json['kondisiMakan'] as String,
    frekuensi: json['frekuensi'] as String?,
    catatan: json['catatan'] as String?,
    isNotifikasiAktif: json['isNotifikasiAktif'] as bool? ?? true,
    isGetar: json['isGetar'] as bool? ?? true,
    isSuara: json['isSuara'] as bool? ?? false,
  );

  /// Enkode list jadwal ke String JSON (untuk disimpan ke SharedPreferences).
  static String encodeList(List<JadwalObat> list) =>
      jsonEncode(list.map((j) => j.toJson()).toList());

  /// Dekode String JSON menjadi list jadwal (setelah dibaca dari SharedPreferences).
  static List<JadwalObat> decodeList(String str) => (jsonDecode(str) as List)
      .map((j) => JadwalObat.fromJson(j as Map<String, dynamic>))
      .toList();
}
