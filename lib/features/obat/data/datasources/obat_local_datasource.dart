/// [ObatLocalDatasource] - Stub datasource lokal untuk jadwal obat.
///
/// Catatan: Tim memilih menggunakan [ObatRepository] dengan SharedPreferences
/// sebagai penyimpanan utama. File ini dipertahankan sebagai referensi
/// arsitektur Clean Architecture untuk implementasi Hive di masa depan.
///
/// TODO: Implementasikan dengan Hive jika akan digunakan kembali:
/// ```yaml
/// # pubspec.yaml
/// hive: ^2.2.3
/// hive_flutter: ^1.1.0
/// ```
class ObatLocalDatasource {
  /// Nama box yang akan digunakan jika menggunakan Hive.
  static const String boxName = 'jadwal_obat';
}
