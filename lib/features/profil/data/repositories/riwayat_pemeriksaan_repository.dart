import 'dart:convert';
import 'package:core_services/core_services.dart';

import '../models/riwayat_pemeriksaan_model.dart';

/// [RiwayatPemeriksaanRepository] - Repository untuk mengelola riwayat pemeriksaan lokal.
class RiwayatPemeriksaanRepository {
  // ── Singleton ──────────────────────────────────────────────
  static final RiwayatPemeriksaanRepository instance =
      RiwayatPemeriksaanRepository._();
  RiwayatPemeriksaanRepository._();

  // ── Storage Keys ───────────────────────────────────────────
  late String _boxName;
  static const String _keyRiwayatList = 'riwayat_pemeriksaan_list';

  // ── Services ───────────────────────────────────────────────
  final StorageService _storage = StorageService.instance;

  // ── In-Memory Cache ────────────────────────────────────────
  List<RiwayatPemeriksaanModel> _riwayatList = [];
  bool _initialized = false;

  /// Dapatkan list riwayat ter-cache secara sinkron (hanya valid setelah [init] dipanggil).
  List<RiwayatPemeriksaanModel> get riwayatList =>
      List.unmodifiable(_riwayatList);

  /// Inisialisasi repository. Memuat riwayat pemeriksaan dari StorageService.
  Future<void> init() async {
    if (_initialized) return;

    final currentUser =
        await _storage.get<String>('auth_box', 'current_user') ?? 'guest';
    _boxName = 'hive_riwayat_pemeriksaan_$currentUser';

    final riwayatStr = await _storage.get<String>(_boxName, _keyRiwayatList);
    if (riwayatStr != null) {
      try {
        final List<dynamic> decoded = jsonDecode(riwayatStr) as List;
        _riwayatList = decoded
            .map(
              (item) => RiwayatPemeriksaanModel.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
      } catch (_) {
        _riwayatList = [];
      }
    } else {
      _riwayatList = [];
    }

    _sortRiwayat();
    _initialized = true;
  }

  /// Urutkan riwayat berdasarkan tanggal paling baru.
  void _sortRiwayat() {
    _riwayatList.sort((a, b) => b.date.compareTo(a.date));
  }

  /// Simpan riwayat terbaru ke StorageService.
  Future<void> _saveToStorage() async {
    final String encoded = jsonEncode(
      _riwayatList.map((item) => item.toJson()).toList(),
    );
    await _storage.put(_boxName, _keyRiwayatList, encoded);
  }

  /// Dapatkan semua riwayat pemeriksaan.
  Future<List<RiwayatPemeriksaanModel>> getRiwayatList() async {
    await init();
    return _riwayatList;
  }

  /// Tambahkan riwayat pemeriksaan baru secara permanen.
  Future<void> addRiwayat(RiwayatPemeriksaanModel model) async {
    await init();

    _riwayatList.removeWhere((item) => item.id == model.id);
    _riwayatList.add(model);
    _sortRiwayat();

    await _saveToStorage();
  }

  /// Hapus seluruh riwayat pemeriksaan lokal.
  Future<void> clearRiwayat() async {
    await init();
    _riwayatList.clear();
    await _storage.delete(_boxName, _keyRiwayatList);
  }

  /// Menghapus cache memory ketika logout
  void clearCache() {
    _riwayatList = [];
    _initialized = false;
  }
}
