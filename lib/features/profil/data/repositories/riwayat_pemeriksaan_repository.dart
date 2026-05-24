import 'dart:convert';
import 'package:hive/hive.dart';

import '../models/riwayat_pemeriksaan_model.dart';

/// [RiwayatPemeriksaanRepository] - Repository untuk mengelola riwayat pemeriksaan lokal.
///
/// Menggunakan [Hive] sebagai database lokal untuk kinerja maksimal dan konsistensi.
/// Sesuai instruksi pengguna, database ini dimulai dari keadaan kosong (tanpa data awal/seed).
class RiwayatPemeriksaanRepository {
  // ── Singleton ──────────────────────────────────────────────
  static final RiwayatPemeriksaanRepository instance =
      RiwayatPemeriksaanRepository._();
  RiwayatPemeriksaanRepository._();

  // ── Storage Key ────────────────────────────────────────────
  static const String _keyRiwayatList = 'riwayat_pemeriksaan_list';

  // ── In-Memory Cache ────────────────────────────────────────
  List<RiwayatPemeriksaanModel> _riwayatList = [];
  bool _initialized = false;

  /// Inisialisasi repository. Memuat riwayat pemeriksaan dari Box Hive.
  Future<void> init() async {
    if (_initialized) return;
    
    // Buka Box Hive khusus untuk riwayat pemeriksaan
    final box = await Hive.openBox('hive_riwayat_pemeriksaan');

    final riwayatStr = box.get(_keyRiwayatList) as String?;
    if (riwayatStr != null) {
      try {
        final List<dynamic> decoded = jsonDecode(riwayatStr) as List;
        _riwayatList = decoded
            .map((item) => RiwayatPemeriksaanModel.fromJson(
                item as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _riwayatList = [];
      }
    } else {
      // Mulai dari kosong sesuai permintaan pengguna (no seeding)
      _riwayatList = [];
    }

    _sortRiwayat();
    _initialized = true;
  }

  /// Urutkan riwayat berdasarkan tanggal paling baru.
  void _sortRiwayat() {
    _riwayatList.sort((a, b) => b.date.compareTo(a.date));
  }

  /// Simpan riwayat terbaru ke Box Hive.
  Future<void> _saveToPrefs(Box box) async {
    final String encoded =
        jsonEncode(_riwayatList.map((item) => item.toJson()).toList());
    await box.put(_keyRiwayatList, encoded);
  }

  /// Dapatkan semua riwayat pemeriksaan.
  Future<List<RiwayatPemeriksaanModel>> getRiwayatList() async {
    await init();
    return _riwayatList;
  }

  /// Tambahkan riwayat pemeriksaan baru secara permanen.
  Future<void> addRiwayat(RiwayatPemeriksaanModel model) async {
    await init();

    // Hapus duplikat ID jika tidak sengaja ada
    _riwayatList.removeWhere((item) => item.id == model.id);
    _riwayatList.add(model);
    _sortRiwayat();

    final box = Hive.box('hive_riwayat_pemeriksaan');
    await _saveToPrefs(box);
  }

  /// Hapus seluruh riwayat pemeriksaan lokal.
  Future<void> clearAll() async {
    _riwayatList.clear();
    final box = await Hive.openBox('hive_riwayat_pemeriksaan');
    await box.delete(_keyRiwayatList);
  }
}
