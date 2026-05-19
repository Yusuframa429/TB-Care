import 'package:hive_flutter/hive_flutter.dart';

import '../models/jadwal_obat_model.dart';

/// [ObatLocalDatasource] - Sumber data lokal menggunakan Hive.
///
/// Bertanggung jawab untuk operasi CRUD langsung ke Hive box.
/// Hive box harus sudah dibuka sebelum class ini digunakan
/// (dilakukan di [main.dart]).
class ObatLocalDatasource {
  /// Nama box Hive untuk jadwal obat.
  static const String boxName = 'jadwal_obat';

  /// Getter untuk mengakses box Hive yang sudah terbuka.
  Box get _box => Hive.box(boxName);

  /// Menyimpan jadwal obat ke Hive.
  /// Key yang digunakan adalah [model.id] agar mudah di-update/hapus.
  Future<void> saveJadwal(JadwalObatModel model) async {
    await _box.put(model.id, model.toMap());
  }

  /// Mengambil semua jadwal obat dari Hive.
  Future<List<JadwalObatModel>> getAllJadwal() async {
    return _box.values
        .map((value) => JadwalObatModel.fromMap(value as Map))
        .toList();
  }

  /// Menghapus jadwal obat berdasarkan [id].
  Future<void> deleteJadwal(String id) async {
    await _box.delete(id);
  }
}
