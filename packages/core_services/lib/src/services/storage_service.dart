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
  Future<Box<dynamic>> openBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    return await Hive.openBox(boxName);
  }

  /// Menyimpan data (Key-Value).
  Future<void> put<T>(String boxName, String key, T value) async {
    final box = await openBox(boxName);
    await box.put(key, value);
  }

  /// Mengambil data berdasarkan key.
  Future<T?> get<T>(String boxName, String key) async {
    final box = await openBox(boxName);
    final value = box.get(key);
    if (value != null && value is T) {
      return value;
    }
    // Jika tipe tidak cocok, kembalikan null atau cast biasa (opsional).
    return value as T?;
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
