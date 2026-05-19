import '../entities/jadwal_obat.dart';

/// [JadwalObatRepository] - Kontrak (interface) repository jadwal obat.
///
/// Layer domain hanya mendefinisikan "apa yang bisa dilakukan",
/// tanpa tahu implementasinya (Hive, SQLite, API, dsb).
/// Implementasinya ada di layer data.
abstract class JadwalObatRepository {
  /// Menyimpan satu jadwal obat baru.
  Future<void> saveJadwal(JadwalObat jadwal);

  /// Mengambil semua jadwal obat yang tersimpan.
  Future<List<JadwalObat>> getAllJadwal();

  /// Menghapus jadwal berdasarkan [id].
  Future<void> deleteJadwal(String id);
}
