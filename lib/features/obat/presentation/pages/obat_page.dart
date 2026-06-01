import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../../data/obat_repository.dart';
import '../../domain/entities/jadwal_obat.dart';
import '../widgets/obat_progress_card.dart';
import '../widgets/minggu_ini_card.dart';
import '../widgets/streak_card.dart';
import '../widgets/jadwal_hari_ini_card.dart';
import '../widgets/statistik_kepatuhan_card.dart';
import '../widgets/pencapaian_section.dart';
import 'atur_jadwal_obat_page.dart';
import 'detail_obat_page.dart';

/// [ObatPage] - Halaman dashboard pengingat dan kepatuhan minum obat.
///
/// Seluruh data diambil dari [ObatRepository] dan disimpan secara
/// persisten ke SharedPreferences. Data mencakup jadwal obat,
/// riwayat minum, statistik, streak, dan pencapaian.
class ObatPage extends StatefulWidget {
  const ObatPage({super.key});

  @override
  State<ObatPage> createState() => _ObatPageState();
}

class _ObatPageState extends State<ObatPage> {
  final ObatRepository _repo = ObatRepository.instance;
  bool _loading = true;

  // ── Data yang dihitung dari repository ──
  int _hariKe = 1;
  int _totalHari = 180;
  int _kepatuhanPersen = 0;
  String _kualitasLabel = '';
  List<String> _statusMingguIni = List.filled(7, 'upcoming');
  int _streak = 0;
  String _pesanStreak = '';
  List<Map<String, dynamic>> _sesiHariIni = [];
  String _statHariIni = '0/0';
  String _statMingguIni = '0/0';
  String _statBulanIni = '0%';
  List<Map<String, dynamic>> _pencapaian = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  /// Inisialisasi repository dan muat semua data.
  Future<void> _initData() async {
    await _repo.init();
    _recalculate();
    if (mounted) setState(() => _loading = false);
  }

  /// Hitung ulang seluruh data dari repository.
  void _recalculate() {
    _hariKe = _repo.getHariKe();
    _totalHari = _repo.getTotalHari();
    _kepatuhanPersen = _repo.getKepatuhanPersen();
    _kualitasLabel = _repo.getKualitasLabel();
    _statusMingguIni = _repo.getStatusMingguIni();
    _streak = _repo.getStreak();
    _pesanStreak = _repo.getPesanStreak();
    _sesiHariIni = _repo.getSesiHariIni();
    _statHariIni = _repo.getStatHariIni();
    _statMingguIni = _repo.getStatMingguIni();
    _statBulanIni = _repo.getStatBulanIni();
    _pencapaian = _repo.getPencapaian();
  }

  /// Tandai obat sebagai "sudah diminum" pada waktu tertentu.
  Future<void> _onSudahMinum(String waktu) async {
    await _repo.tandaiSudahMinum(waktu);
    setState(() => _recalculate());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ Obat berhasil dicatat!'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Tunda pengingat obat 30 menit (feedback visual).
  void _onTunda(String waktu) {
    // Hitung waktu baru setelah ditunda 30 menit.
    final parts = waktu.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    final newTime = TimeOfDay(hour: hour, minute: minute)
        .replacing(minute: (minute + 30) % 60, hour: minute + 30 >= 60 ? hour + 1 : hour);
    final newTimeStr =
        '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⏰ Pengingat ditunda ke $newTimeStr'),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Navigasi ke halaman detail setelah user memilih obat dari bottom sheet.
  void _onTapSesi(String waktu) {
    // Cari semua jadwal obat yang memiliki waktu ini.
    final obatSesi = _repo.getJadwalList().where(
      (j) => j.waktuMinum.contains(waktu),
    ).toList();

    if (obatSesi.isEmpty) return;

    // Jika hanya satu obat, langsung ke detail.
    if (obatSesi.length == 1) {
      _navigateToDetail(obatSesi.first);
      return;
    }

    // Jika lebih dari satu, tampilkan bottom sheet pilihan.
    _showPilihObatSheet(obatSesi);
  }

  /// Tampilkan bottom sheet daftar obat dalam sesi ini.
  void _showPilihObatSheet(List<JadwalObat> daftarObat) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Handle bar.
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pilih Obat',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap untuk melihat detail obat',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 16),
                ...daftarObat.map((obat) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ObatListItem(
                      jadwal: obat,
                      onTap: () {
                        Navigator.pop(ctx);
                        _navigateToDetail(obat);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Navigasi ke halaman detail obat.
  void _navigateToDetail(JadwalObat jadwal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailObatPage(jadwal: jadwal),
      ),
    );
  }

  /// Navigasi ke halaman tambah jadwal, reload data saat kembali.
  Future<void> _navigasiTambahJadwal() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AturJadwalObatPage()),
    );
    // Jika jadwal baru berhasil disimpan, recalculate.
    if (result == true) {
      setState(() => _recalculate());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  /// Kartu progress pengobatan (hijau).
                  ObatProgressCard(
                    hariKe: _hariKe,
                    totalHari: _totalHari,
                    kepatuhanPersen: _kepatuhanPersen,
                    kualitasLabel: _kualitasLabel,
                  ),
                  const SizedBox(height: 16),

                  /// Tracker mingguan.
                  MingguIniCard(statusPerHari: _statusMingguIni),
                  const SizedBox(height: 12),

                  /// Kartu streak motivasi.
                  StreakCard(
                    streakHari: _streak,
                    pesan: _pesanStreak,
                  ),
                  const SizedBox(height: 20),

                  /// Section: Jadwal Hari Ini.
                  const SectionHeader(emoji: '⏰', title: 'Jadwal Hari Ini'),
                  const SizedBox(height: 12),

                  /// Daftar kartu jadwal hari ini (dinamis dari repository).
                  if (_sesiHariIni.isEmpty)
                    _buildEmptyJadwal()
                  else
                    ..._sesiHariIni.map((sesi) {
                      final waktu = sesi['waktu'] as String;
                      final warnaKey = _repo.getWarnaSesiKey(waktu);
                      Color warnaSesi;
                      switch (warnaKey) {
                        case 'siang':
                          warnaSesi = AppColors.info;
                          break;
                        case 'malam':
                          warnaSesi = AppColors.warning;
                          break;
                        default:
                          warnaSesi = AppColors.primary;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: JadwalHariIniCard(
                          waktu: waktu,
                          namaSesi: sesi['namaSesi'] as String,
                          daftarObat: sesi['daftarObat'] as String,
                          isSudahMinum: sesi['sudahMinum'] as bool,
                          warnaSesi: warnaSesi,
                          onSudahMinum: () => _onSudahMinum(waktu),
                          onTunda: () => _onTunda(waktu),
                          onTap: () => _onTapSesi(waktu),
                        ),
                      );
                    }),
                  const SizedBox(height: 8),

                  /// Section: Statistik Kepatuhan.
                  const SectionHeader(
                    emoji: '📈',
                    title: 'Statistik Kepatuhan',
                  ),
                  const SizedBox(height: 12),

                  StatistikKepatuhanCard(
                    hariIni: _statHariIni,
                    mingguIni: _statMingguIni,
                    bulanIni: _statBulanIni,
                  ),
                  const SizedBox(height: 20),

                  /// Section: Pencapaian.
                  const SectionHeader(emoji: '🏅', title: 'Pencapaian'),
                  const SizedBox(height: 12),

                  PencapaianSection(pencapaianList: _pencapaian),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tampilan kosong jika belum ada jadwal obat.
  Widget _buildEmptyJadwal() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.medication_outlined,
            size: 48,
            color: AppColors.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada jadwal obat',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tekan tombol "+ Tambah" untuk menambahkan',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  /// AppBar kustom dengan judul "Pengingat Obat" dan tombol "+ Tambah".
  Widget _buildAppBar() {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  /// Tombol back hanya muncul jika halaman di-push (bukan tab).
                  if (Navigator.canPop(context)) ...[
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Expanded(
                    child: Text(
                      'Pengingat Obat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _navigasiTambahJadwal,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text(
                      'Tambah',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
          ],
        ),
      ),
    );
  }
}

/// [_ObatListItem] - Item daftar obat untuk bottom sheet.
class _ObatListItem extends StatelessWidget {
  final JadwalObat jadwal;
  final VoidCallback onTap;

  const _ObatListItem({
    required this.jadwal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.medication_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jadwal.namaObat,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${jadwal.jumlahDosis} ${jadwal.satuanDosis}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
