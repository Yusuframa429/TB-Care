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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Muat data dari ObatRepository (singleton, shared dengan ObatPage).
  Future<void> _loadData() async {
    await _repo.init();
    _recalculate();
    if (mounted) setState(() => _loading = false);
  }

  /// Dipanggil oleh [MainShell] saat user kembali ke tab Beranda.
  /// Memastikan data kepatuhan dan pengingat selalu sinkron.
  void refreshData() {
    _recalculate();
    if (mounted) setState(() {});
  }

  /// Hitung ulang data kepatuhan & pengingat dari repository.
  void _recalculate() {
    _kepatuhanPersen = _repo.getKepatuhanPersen();
    _streak = _repo.getStreak();

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
            const CekAiCard(),
            const SizedBox(height: 24),

            /// Section riwayat kesehatan (2 stat cards).
            const RiwayatKesehatanSection(
              cekBulanIni: 3,
              konsultasiSelesai: 1,
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
