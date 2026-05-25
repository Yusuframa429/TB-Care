import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../../../obat/data/obat_repository.dart';
import '../widgets/beranda_header.dart';
import '../widgets/cek_ai_card.dart';
import '../widgets/riwayat_kesehatan_section.dart';
import '../widgets/pengingat_obat_card.dart';
import '../widgets/kepatuhan_obat_card.dart';
import '../widgets/edukasi_section.dart';
import '../widgets/tahukah_anda_card.dart';
import 'edukasi_list_page.dart';

import '../../../cek_ai/presentation/pages/cek_ai_page.dart';
import '../../../profil/data/repositories/riwayat_pemeriksaan_repository.dart';
import '../../../profil/presentation/pages/riwayat_pemeriksaan_page.dart';

/// [BerandaPage] - Halaman utama (Home) aplikasi TB Care.
///
/// Halaman ini merupakan halaman pertama yang dilihat pengguna
/// setelah membuka aplikasi. Menampilkan:
/// - Header dengan sapaan dinamis dan info pengguna
/// - Kartu fitur Cek AI
/// - Riwayat kesehatan (statistik)
/// - Pengingat obat (data live dari [ObatRepository])
/// - Kepatuhan obat (data live dari [ObatRepository])
/// - Edukasi & artikel
/// - Fakta menarik "Tahukah Anda?"
class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => BerandaPageState();
}

class BerandaPageState extends State<BerandaPage> {
  final ObatRepository _repo = ObatRepository.instance;
  bool _loading = true;

  // ── Data live dari ObatRepository ──
  int _kepatuhanPersen = 0;
  int _streak = 0;
  String _pengingatTitle = 'Pengingat Obat';
  String _pengingatTime = '--:--';
  bool _pengingatIsTaken = false;

  // ── Data live dari RiwayatPemeriksaanRepository ──
  int _cekBulanIni = 0;
  int _konsultasiSelesai = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Muat data dari ObatRepository dan RiwayatPemeriksaanRepository secara asinkron.
  Future<void> _loadData() async {
    await _repo.init();
    await RiwayatPemeriksaanRepository.instance.init();
    _recalculate();
    if (mounted) setState(() => _loading = false);
  }

  /// Dipanggil oleh [MainShell] saat user kembali ke tab Beranda.
  /// Memastikan seluruh data kepatuhan, pengingat, dan riwayat selalu sinkron.
  void refreshData() {
    _recalculate();
    if (mounted) setState(() {});
  }

  /// Hitung ulang data kepatuhan, pengingat, dan riwayat kesehatan.
  void _recalculate() {
    _kepatuhanPersen = _repo.getKepatuhanPersen();
    _streak = _repo.getStreak();

    // Hitung riwayat pemeriksaan dinamis dari database Hive
    final riwayatList = RiwayatPemeriksaanRepository.instance.riwayatList;
    final now = DateTime.now();
    _cekBulanIni = riwayatList
        .where((item) =>
            item.type == 'AI Check' &&
            item.date.month == now.month &&
            item.date.year == now.year)
        .length;
    _konsultasiSelesai = riwayatList
        .where((item) => item.type == 'Konsultasi')
        .length;

    // Cari sesi berikutnya yang belum diminum hari ini.
    final sesiHariIni = _repo.getSesiHariIni();
    final sesiBelum = sesiHariIni.where(
      (s) => s['sudahMinum'] == false,
    );

    if (sesiBelum.isNotEmpty) {
      final next = sesiBelum.first;
      _pengingatTitle = next['namaSesi'] as String;
      _pengingatTime = next['waktu'] as String;
      _pengingatIsTaken = false;
    } else if (sesiHariIni.isNotEmpty) {
      // Semua sudah diminum hari ini.
      final last = sesiHariIni.last;
      _pengingatTitle = last['namaSesi'] as String;
      _pengingatTime = last['waktu'] as String;
      _pengingatIsTaken = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header hijau dengan sapaan dinamis.
            const BerandaHeader(
              userName: 'Budi Santoso',
              userInitials: 'BS',
              status: 'Terdaftar',
            ),
            const SizedBox(height: 20),

            /// Kartu promosi fitur Cek AI.
            CekAiCard(
              onStartTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CekAiPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            /// Section riwayat kesehatan (2 stat cards).
            RiwayatKesehatanSection(
              cekBulanIni: _cekBulanIni,
              konsultasiSelesai: _konsultasiSelesai,
              onLihatSemua: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RiwayatPemeriksaanPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            /// Kartu pengingat obat — data live dari ObatRepository.
            _loading
                ? const SizedBox.shrink()
                : PengingatObatCard(
                    title: _pengingatTitle,
                    time: _pengingatTime,
                    isTaken: _pengingatIsTaken,
                  ),
            const SizedBox(height: 16),

            /// Kartu kepatuhan obat — data live dari ObatRepository.
            _loading
                ? const SizedBox.shrink()
                : KepatuhanObatCard(
                    percentage: _kepatuhanPersen.toDouble(),
                    streakDays: _streak,
                  ),
            const SizedBox(height: 24),

            /// Section edukasi & artikel.
            EdukasiSection(
              onSemuaArtikel: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EdukasiListPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            /// Kartu fakta "Tahukah Anda?".
            const TahukahAndaCard(
              fact: 'TBC adalah penyakit yang bisa disembuhkan dengan pengobatan tepat',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
