import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../../data/obat_repository.dart';
import '../widgets/obat_progress_card.dart';
import '../widgets/minggu_ini_card.dart';
import '../widgets/streak_card.dart';
import '../widgets/jadwal_hari_ini_card.dart';
import '../widgets/statistik_kepatuhan_card.dart';
import '../widgets/pencapaian_section.dart';
import 'atur_jadwal_obat_page.dart';

/// [ObatPage] - Halaman manajemen jadwal obat TB Care.
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
    // TODO: Setelah kembali, refresh daftar dari Hive.
  }

  /// Navigasi ke halaman form dalam mode edit.
  void _editJadwal(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AturJadwalObatPage(isEditMode: true),
      ),
    );
    // TODO: Kirimkan data jadwal yang akan diedit.
  }

  /// Konfirmasi dan hapus jadwal.
  void _hapusJadwal(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Hapus Jadwal?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Jadwal obat "${_daftarJadwal[index]['namaObat']}" akan dihapus permanen.',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _daftarJadwal.removeAt(index));
              // TODO: Panggil DeleteJadwal use case saat Hive siap.
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
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
          /// Header halaman.
          _buildHeader(),

          /// Konten: list jadwal atau empty state.
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

      /// FAB untuk menambah jadwal baru.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahJadwal,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Jadwal',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
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
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.medication_rounded,
                      color: AppColors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Jadwal Obat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildHeaderStat(
                    label: 'Total Jadwal',
                    value: '${_daftarJadwal.length}',
                  ),
                  const SizedBox(width: 24),
                  _buildHeaderStat(
                    label: 'Aktif',
                    value: '$jadwalAktif',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget statistik kecil di dalam header.
  Widget _buildHeaderStat({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  /// Tampilan kosong saat belum ada jadwal.
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medication_outlined,
                size: 52,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum Ada Jadwal Obat',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan jadwal minum obat Anda\nagar tidak terlewat.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

