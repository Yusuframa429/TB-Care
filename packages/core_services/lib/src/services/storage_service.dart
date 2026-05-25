import 'package:hive_flutter/hive_flutter.dart';

/// [StorageService] - Abstraksi penyimpanan lokal menggunakan Hive.
class StorageService {
  static final StorageService instance = StorageService._();
  StorageService._();

  /// Inisialisasi Hive untuk Flutter.
  Future<void> init() async {
    await Hive.initFlutter();
  }

  /// Membuka box Hive.
  Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }

  /// Menyimpan data (Key-Value).
  Future<void> put<T>(String boxName, String key, T value) async {
    final box = await openBox<T>(boxName);
    await box.put(key, value);
  }

  /// Mengambil data berdasarkan key.
  Future<T?> get<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    return box.get(key);
  }

  /// Menghapus data berdasarkan key.
  Future<void> delete(String boxName, String key) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  /// Membersihkan seluruh isi box.
  Future<void> clear(String boxName) async {
    final box = await openBox(boxName);
    await box.clear();
  }
}
