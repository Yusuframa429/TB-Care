/// [JadwalObat] - Entity murni untuk jadwal minum obat.
///
/// Layer domain tidak mengenal Hive, database, atau Flutter.
/// Hanya berisi data dan tidak ada dependency eksternal.
class JadwalObat {
  /// ID unik jadwal (epoch milliseconds sebagai string).
  final String id;

  /// Nama obat (misal: "Rifampicin").
  final String namaObat;

  /// Jumlah dosis (misal: "1").
  final String dosis;

  /// Satuan dosis (misal: "tablet", "kapsul").
  final String satuanDosis;

  /// List jam minum dalam format "HH:mm" (misal: ["08:00", "20:00"]).
  final List<String> waktuMinum;

  /// Kondisi makan ("Sebelum makan", "Saat makan", "Setelah makan").
  final String kondisiMakan;

  /// Frekuensi minum ("Setiap hari", "Setiap 2 hari", dll.).
  final String frekuensi;

  /// Status notifikasi aktif.
  final bool isNotifikasiAktif;

  /// Status getar aktif.
  final bool isGetar;

  /// Status suara aktif.
  final bool isSuara;

  /// Catatan tambahan (opsional).
  final String catatan;

  const JadwalObat({
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
}
