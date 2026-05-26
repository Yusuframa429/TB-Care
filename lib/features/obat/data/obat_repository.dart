import 'dart:convert';
import 'package:core_services/core_services.dart';

import '../../../core/services/notification_service.dart';
import '../domain/entities/jadwal_obat.dart';

/// [ObatRepository] - Repository untuk mengelola seluruh data obat.
class ObatRepository {
  // ── Singleton ──────────────────────────────────────────────
  static final ObatRepository instance = ObatRepository._();
  ObatRepository._();

  // ── Storage Keys ───────────────────────────────────────────
  static const _boxName = 'hive_obat_data';
  static const _keyJadwal = 'obat_jadwal_list';
  static const _keyRiwayat = 'obat_riwayat_map';
  static const _keyTglMulai = 'obat_tgl_mulai';
  static const _keyTotalHari = 'obat_total_hari';
  static const _keySeeded = 'obat_seeded';

  // ── Services ───────────────────────────────────────────────
  final StorageService _storage = StorageService.instance;

  // ── In-memory cache ────────────────────────────────────────
  List<JadwalObat> _jadwalList = [];
  Map<String, bool> _riwayat = {};
  DateTime _tanggalMulai = DateTime.now();
  int _totalHari = 180;
  bool _initialized = false;

  // ── Init ───────────────────────────────────────────────────

  /// Inisialisasi repository.
  Future<void> init() async {
    if (_initialized) return;
    
    // Load jadwal
    final jadwalStr = await _storage.get<String>(_boxName, _keyJadwal);
    if (jadwalStr != null) {
      _jadwalList = JadwalObat.decodeList(jadwalStr);
    }

    // Load riwayat
    final riwayatStr = await _storage.get<String>(_boxName, _keyRiwayat);
    if (riwayatStr != null) {
      _riwayat = Map<String, bool>.from(
        jsonDecode(riwayatStr) as Map<String, dynamic>,
      );
    }

    // Load tanggal mulai
    final tglStr = await _storage.get<String>(_boxName, _keyTglMulai);
    if (tglStr != null) {
      _tanggalMulai = DateTime.parse(tglStr);
    }
    _totalHari = await _storage.get<int>(_boxName, _keyTotalHari) ?? 180;

    // Seed data awal jika belum pernah
    final seeded = await _storage.get<bool>(_boxName, _keySeeded) ?? false;
    if (!seeded) {
      await _seedInitialData();
    }

    _initialized = true;
  }

  // ── Seed Data ──────────────────────────────────────────────

  Future<void> _seedInitialData() async {
    _tanggalMulai = DateTime.now().subtract(const Duration(days: 14));
    _totalHari = 180;

    _jadwalList = [
      JadwalObat(
        id: 'seed_1',
        namaObat: 'Rifampicin',
        jumlahDosis: 1,
        satuanDosis: 'kapsul',
        waktuMinum: ['08:00', '20:00'],
        kondisiMakan: 'Sebelum makan',
        isNotifikasiAktif: false, // seed data: nonaktif agar tidak spam notif
        isGetar: true,
        isSuara: false,
      ),
      JadwalObat(
        id: 'seed_2',
        namaObat: 'INH',
        jumlahDosis: 1,
        satuanDosis: 'tablet',
        waktuMinum: ['08:00', '20:00'],
        kondisiMakan: 'Sebelum makan',
        isNotifikasiAktif: false,
        isGetar: true,
        isSuara: false,
      ),
      JadwalObat(
        id: 'seed_3',
        namaObat: 'PZA',
        jumlahDosis: 1,
        satuanDosis: 'tablet',
        waktuMinum: ['08:00'],
        kondisiMakan: 'Sebelum makan',
        isNotifikasiAktif: false,
        isGetar: true,
        isSuara: false,
      ),
      JadwalObat(
        id: 'seed_4',
        namaObat: 'EMB',
        jumlahDosis: 1,
        satuanDosis: 'tablet',
        waktuMinum: ['08:00'],
        kondisiMakan: 'Sebelum makan',
        isNotifikasiAktif: false,
        isGetar: true,
        isSuara: false,
      ),
    ];

    _riwayat = {};
    final waktuSet = _getAllWaktu();
    for (int i = 1; i <= 13; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateKey = _dateKey(date);
      for (final w in waktuSet) {
        _riwayat['${dateKey}_$w'] = true;
      }
    }

    await _persist();
    await _storage.put(_boxName, _keySeeded, true);
  }

  // ── Persistence ────────────────────────────────────────────

  Future<void> _persist() async {
    await _storage.put(_boxName, _keyJadwal, JadwalObat.encodeList(_jadwalList));
    await _storage.put(_boxName, _keyRiwayat, jsonEncode(_riwayat));
    await _storage.put(_boxName, _keyTglMulai, _tanggalMulai.toIso8601String());
    await _storage.put(_boxName, _keyTotalHari, _totalHari);
  }

  // ── CRUD Jadwal ────────────────────────────────────────────

  List<JadwalObat> getJadwalList() => List.unmodifiable(_jadwalList);

  Future<void> simpanJadwal(JadwalObat jadwal) async {
    // Jika update (id sudah ada), batalkan notifikasi lama dulu.
    final idx = _jadwalList.indexWhere((j) => j.id == jadwal.id);
    if (idx >= 0) {
      await NotificationService.instance.cancelForJadwal(jadwal.id);
      _jadwalList[idx] = jadwal;
    } else {
      _jadwalList.add(jadwal);
    }
    await _persist();

    // Jadwalkan notifikasi berulang harian (hanya jika aktif).
    await NotificationService.instance.scheduleForJadwal(jadwal);
  }

  Future<void> hapusJadwal(String id) async {
    _jadwalList.removeWhere((j) => j.id == id);
    await _persist();

    // Batalkan semua notifikasi yang terkait dengan jadwal ini.
    await NotificationService.instance.cancelForJadwal(id);
  }

  // ── Actions ────────────────────────────────────────────────

  /// Tandai waktu minum tertentu hari ini sebagai "sudah diminum".
  Future<void> tandaiSudahMinum(String waktu) async {
    final key = '${_dateKey(DateTime.now())}_$waktu';
    _riwayat[key] = true;
    await _persist();
  }

  /// Batalkan status "sudah minum" (untuk undo).
  Future<void> batalkanSudahMinum(String waktu) async {
    final key = '${_dateKey(DateTime.now())}_$waktu';
    _riwayat.remove(key);
    await _persist();
  }

  /// Cek status riwayat minum pada tanggal dan waktu tertentu.
  /// [dateKey] format "yyyy-MM-dd", [waktu] format "HH:mm".
  bool getRiwayatStatus(String dateKey, String waktu) {
    return _riwayat['${dateKey}_$waktu'] == true;
  }

  // ── Query: Sesi Hari Ini ───────────────────────────────────

  /// Mengembalikan daftar sesi minum obat hari ini,
  /// dikelompokkan berdasarkan waktu.
  ///
  /// Setiap sesi berisi: waktu, namaSesi, daftarObat (gabungan),
  /// sudahMinum.
  List<Map<String, dynamic>> getSesiHariIni() {
    final waktuSet = _getAllWaktu().toList()..sort();
    final todayKey = _dateKey(DateTime.now());
    final sesiList = <Map<String, dynamic>>[];

    for (final waktu in waktuSet) {
      // Kumpulkan nama obat yang diminum di waktu ini.
      final obatNames = _jadwalList
          .where((j) => j.waktuMinum.contains(waktu))
          .map((j) => j.namaObat)
          .toList();

      if (obatNames.isEmpty) continue;

      final sudahMinum = _riwayat['${todayKey}_$waktu'] == true;

      sesiList.add({
        'waktu': waktu,
        'namaSesi': _namaSesi(waktu),
        'daftarObat': obatNames.join(' + '),
        'sudahMinum': sudahMinum,
      });
    }
    return sesiList;
  }

  // ── Query: Progress ────────────────────────────────────────

  /// Hari ke-berapa dalam pengobatan (dimulai dari 1).
  int getHariKe() {
    final diff = DateTime.now().difference(_tanggalMulai).inDays + 1;
    return diff.clamp(1, _totalHari);
  }

  int getTotalHari() => _totalHari;

  /// Persentase kepatuhan keseluruhan (0-100).
  int getKepatuhanPersen() {
    final waktuSet = _getAllWaktu();
    if (waktuSet.isEmpty) return 100;

    final hariKe = getHariKe();
    int totalDosis = 0;
    int diminumDosis = 0;

    for (int i = 0; i < hariKe; i++) {
      final date = _tanggalMulai.add(Duration(days: i));
      final dateKey = _dateKey(date);
      for (final w in waktuSet) {
        totalDosis++;
        if (_riwayat['${dateKey}_$w'] == true) diminumDosis++;
      }
    }

    return totalDosis == 0 ? 100 : (diminumDosis * 100 ~/ totalDosis);
  }

  /// Label kualitas berdasarkan persentase kepatuhan.
  String getKualitasLabel() {
    final persen = getKepatuhanPersen();
    if (persen >= 95) return 'Excellent';
    if (persen >= 85) return 'Baik';
    if (persen >= 70) return 'Cukup';
    return 'Perlu Perbaikan';
  }

  // ── Query: Status Minggu Ini ───────────────────────────────

  /// Status per hari untuk minggu ini (Sen-Min).
  /// Nilai: 'done', 'missed', 'today', 'upcoming'.
  List<String> getStatusMingguIni() {
    final now = DateTime.now();
    // Cari Senin minggu ini.
    final senin = now.subtract(Duration(days: now.weekday - 1));
    final waktuSet = _getAllWaktu();

    return List.generate(7, (i) {
      final date = DateTime(senin.year, senin.month, senin.day + i);
      final dateKey = _dateKey(date);
      final today = DateTime(now.year, now.month, now.day);

      if (date.isAfter(today)) return 'upcoming';
      if (date.isAtSameMomentAs(today)) return 'today';

      if (waktuSet.isEmpty) return 'done';

      // Cek apakah semua waktu di hari itu sudah diminum.
      final allDone = waktuSet.every(
        (w) => _riwayat['${dateKey}_$w'] == true,
      );
      return allDone ? 'done' : 'missed';
    });
  }

  // ── Query: Streak ──────────────────────────────────────────

  /// Menghitung streak (hari berturut-turut) minum obat lengkap.
  /// Dihitung mundur dari kemarin.
  int getStreak() {
    final waktuSet = _getAllWaktu();
    if (waktuSet.isEmpty) return 0;

    int streak = 0;
    final now = DateTime.now();

    // Cek hari ini dulu, kalau sudah lengkap include.
    final todayKey = _dateKey(now);
    final todayAllDone =
        waktuSet.every((w) => _riwayat['${todayKey}_$w'] == true);
    if (todayAllDone) streak++;

    // Mundur dari kemarin.
    for (int i = 1; i <= 365; i++) {
      final date = now.subtract(Duration(days: i));
      if (date.isBefore(_tanggalMulai)) break;
      final dateKey = _dateKey(date);
      final allDone =
          waktuSet.every((w) => _riwayat['${dateKey}_$w'] == true);
      if (!allDone) break;
      streak++;
    }

    return streak;
  }

  /// Pesan motivasi berdasarkan streak.
  String getPesanStreak() {
    final s = getStreak();
    if (s >= 30) return 'Luar biasa! Kamu hebat sekali! 🏆';
    if (s >= 14) return 'Luar biasa! Pertahankan konsistensi ini 💪';
    if (s >= 7) return 'Seminggu penuh! Terus semangat! 🔥';
    if (s >= 3) return 'Awal yang bagus! Jangan menyerah! ✨';
    if (s >= 1) return 'Mulai bagus! Lanjutkan besok ya! 💊';
    return 'Yuk mulai minum obat teratur! 💪';
  }

  // ── Query: Statistik Kepatuhan ─────────────────────────────

  /// Statistik hari ini: "X/Y" (diminum/total).
  String getStatHariIni() {
    final waktuSet = _getAllWaktu();
    if (waktuSet.isEmpty) return '0/0';
    final todayKey = _dateKey(DateTime.now());
    int diminum = 0;
    for (final w in waktuSet) {
      if (_riwayat['${todayKey}_$w'] == true) diminum++;
    }
    return '$diminum/${waktuSet.length}';
  }

  /// Statistik minggu ini: "X/Y".
  String getStatMingguIni() {
    final waktuSet = _getAllWaktu();
    if (waktuSet.isEmpty) return '0/0';
    final now = DateTime.now();
    final senin = now.subtract(Duration(days: now.weekday - 1));
    int total = 0;
    int diminum = 0;

    for (int i = 0; i <= 6; i++) {
      final date = DateTime(senin.year, senin.month, senin.day + i);
      if (date.isAfter(now)) break;
      final dateKey = _dateKey(date);
      for (final w in waktuSet) {
        total++;
        if (_riwayat['${dateKey}_$w'] == true) diminum++;
      }
    }
    return '$diminum/$total';
  }

  /// Statistik bulan ini: persentase string "X%".
  String getStatBulanIni() {
    final waktuSet = _getAllWaktu();
    if (waktuSet.isEmpty) return '100%';
    final now = DateTime.now();
    final awalBulan = DateTime(now.year, now.month, 1);
    int total = 0;
    int diminum = 0;

    for (var d = awalBulan;
        !d.isAfter(now);
        d = d.add(const Duration(days: 1))) {
      if (d.isBefore(_tanggalMulai)) continue;
      final dateKey = _dateKey(d);
      for (final w in waktuSet) {
        total++;
        if (_riwayat['${dateKey}_$w'] == true) diminum++;
      }
    }
    return total == 0 ? '100%' : '${diminum * 100 ~/ total}%';
  }

  // ── Query: Pencapaian ──────────────────────────────────────

  /// Daftar pencapaian/badge dan status unlock-nya.
  List<Map<String, dynamic>> getPencapaian() {
    final streak = getStreak();
    final kepatuhan = getKepatuhanPersen();
    final hariKe = getHariKe();

    return [
      {
        'emoji': '🔥',
        'label': 'Streak 14 Hari',
        'unlocked': streak >= 14,
        'bgColor': 0xFFFFF8E1,
      },
      {
        'emoji': '⭐',
        'label': 'Kepatuhan 90%+',
        'unlocked': kepatuhan >= 90,
        'bgColor': 0xFFFFF8E1,
      },
      {
        'emoji': '🏆',
        'label': 'Seminggu Penuh',
        'unlocked': streak >= 7,
        'bgColor': 0xFFFFF8E1,
      },
      {
        'emoji': '💎',
        'label': '1 Bulan Sempurna',
        'unlocked': streak >= 30,
        'bgColor': 0xFFF3F4F6,
      },
      {
        'emoji': '🎯',
        'label': '3 Bulan Konsisten',
        'unlocked': hariKe >= 90 && kepatuhan >= 90,
        'bgColor': 0xFFF3F4F6,
      },
      {
        'emoji': '🎓',
        'label': 'Pengobatan Selesai',
        'unlocked': hariKe >= _totalHari,
        'bgColor': 0xFFF3F4F6,
      },
    ];
  }

  // ── Helpers ────────────────────────────────────────────────

  /// Semua waktu unik dari seluruh jadwal.
  Set<String> _getAllWaktu() {
    final set = <String>{};
    for (final j in _jadwalList) {
      set.addAll(j.waktuMinum);
    }
    return set;
  }

  /// Format tanggal jadi key "yyyy-MM-dd".
  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// Nama sesi berdasarkan jam.
  String _namaSesi(String waktu) {
    final hour = int.tryParse(waktu.split(':')[0]) ?? 0;
    if (hour < 12) return 'Obat Pagi';
    if (hour < 17) return 'Obat Siang';
    return 'Obat Malam';
  }

  /// Warna sesi (sebagai index untuk AppColors lookup di UI).
  /// 'pagi' | 'siang' | 'malam'
  String getWarnaSesiKey(String waktu) {
    final hour = int.tryParse(waktu.split(':')[0]) ?? 0;
    if (hour < 12) return 'pagi';
    if (hour < 17) return 'siang';
    return 'malam';
  }
}
