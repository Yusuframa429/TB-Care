import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../widgets/obat_progress_card.dart';
import '../widgets/minggu_ini_card.dart';
import '../widgets/streak_card.dart';
import '../widgets/jadwal_hari_ini_card.dart';
import '../widgets/statistik_kepatuhan_card.dart';
import '../widgets/pencapaian_section.dart';
import 'atur_jadwal_obat_page.dart';

/// [ObatPage] - Halaman dashboard pengingat dan kepatuhan minum obat.
///
/// Menampilkan ringkasan lengkap pengobatan TBC pengguna:
/// - Progress hari pengobatan dan persentase kepatuhan
/// - Tracker mingguan (sudah/belum minum tiap hari)
/// - Kartu streak motivasi
/// - Jadwal minum obat hari ini dengan tombol aksi
/// - Statistik kepatuhan (hari ini, minggu, bulan)
/// - Badge pencapaian
///
/// Saat ini menggunakan data dummy. Akan disambungkan ke
/// penyimpanan lokal (Hive) pada implementasi berikutnya.
class ObatPage extends StatefulWidget {
  const ObatPage({super.key});

  @override
  State<ObatPage> createState() => _ObatPageState();
}

class _ObatPageState extends State<ObatPage> {
  /// Status minum obat per hari minggu ini.
  /// Index 0 = Senin, 6 = Minggu.
  /// Nilai: 'done', 'missed', 'today', 'upcoming'.
  final List<String> _statusMingguIni = [
    'done', // Senin
    'done', // Selasa
    'done', // Rabu
    'done', // Kamis
    'done', // Jumat
    'done', // Sabtu
    'today', // Minggu (hari ini)
  ];

  /// Status minum obat untuk jadwal hari ini.
  bool _obatPagiSudahMinum = true;
  bool _obatMalamSudahMinum = false;

  /// Navigasi ke halaman form Atur Jadwal Obat.
  void _navigasiTambahJadwal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AturJadwalObatPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  const ObatProgressCard(
                    hariKe: 14,
                    totalHari: 180,
                    kepatuhanPersen: 96,
                    kualitasLabel: 'Excellent',
                  ),
                  const SizedBox(height: 16),

                  /// Tracker mingguan.
                  MingguIniCard(statusPerHari: _statusMingguIni),
                  const SizedBox(height: 12),

                  /// Kartu streak motivasi.
                  const StreakCard(
                    streakHari: 14,
                    pesan: 'Luar biasa! Pertahankan konsistensi ini 💪',
                  ),
                  const SizedBox(height: 20),

                  /// Section: Jadwal Hari Ini.
                  const SectionHeader(emoji: '⏰', title: 'Jadwal Hari Ini'),
                  const SizedBox(height: 12),

                  /// Kartu Obat Pagi.
                  JadwalHariIniCard(
                    waktu: '08:00',
                    namaSesi: 'Obat Pagi',
                    daftarObat: 'Rifampicin + INH + PZA + EMB',
                    isSudahMinum: _obatPagiSudahMinum,
                    warnaSesi: AppColors.primary,
                    onSudahMinum: () {
                      setState(() => _obatPagiSudahMinum = true);
                    },
                    onTunda: () {
                      // TODO: Implementasi tunda notifikasi.
                    },
                  ),
                  const SizedBox(height: 12),

                  /// Kartu Obat Malam.
                  JadwalHariIniCard(
                    waktu: '20:00',
                    namaSesi: 'Obat Malam',
                    daftarObat: 'Rifampicin + INH',
                    isSudahMinum: _obatMalamSudahMinum,
                    warnaSesi: AppColors.warning,
                    onSudahMinum: () {
                      setState(() => _obatMalamSudahMinum = true);
                    },
                    onTunda: () {
                      // TODO: Implementasi tunda notifikasi.
                    },
                  ),
                  const SizedBox(height: 20),

                  /// Section: Statistik Kepatuhan.
                  const SectionHeader(
                    emoji: '📈',
                    title: 'Statistik Kepatuhan',
                  ),
                  const SizedBox(height: 12),

                  const StatistikKepatuhanCard(
                    hariIni: '1/2',
                    mingguIni: '13/14',
                    bulanIni: '96%',
                  ),
                  const SizedBox(height: 20),

                  /// Section: Pencapaian.
                  const SectionHeader(emoji: '🏅', title: 'Pencapaian'),
                  const SizedBox(height: 12),

                  const PencapaianSection(),
                ],
              ),
            ),
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
