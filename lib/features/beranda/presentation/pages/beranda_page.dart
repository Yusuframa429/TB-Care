import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../../../obat/data/obat_repository.dart';
import '../../../obat/domain/entities/jadwal_obat.dart';
import '../../../obat/presentation/pages/detail_obat_page.dart';
import '../../../obat/presentation/pages/obat_page.dart';
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
import '../../../profil/data/repositories/family_repository.dart';
import '../../../profil/data/models/family_member_model.dart';

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
  bool _hasJadwal = false;

  // ── Data live dari RiwayatPemeriksaanRepository ──
  int _cekBulanIni = 0;
  int _konsultasiSelesai = 0;

  FamilyMemberModel? _activeMember;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Muat data dari ObatRepository dan RiwayatPemeriksaanRepository secara asinkron.
  Future<void> _loadData() async {
    await _repo.init();
    await RiwayatPemeriksaanRepository.instance.init();
    await FamilyRepository.instance.init();

    _activeMember = await FamilyRepository.instance.getActiveMember();
    _recalculate();
    if (mounted) setState(() => _loading = false);
  }

  /// Dipanggil oleh [MainShell] saat user kembali ke tab Beranda.
  /// Memastikan seluruh data kepatuhan, pengingat, dan riwayat selalu sinkron.
  void refreshData() async {
    _activeMember = await FamilyRepository.instance.getActiveMember();
    _recalculate();
    if (mounted) setState(() {});
  }

  /// Navigasi ke halaman detail obat (PengingatObatCard ditekan).
  void _onPengingatTap() {
    final sesiHariIni = _repo.getSesiHariIni();
    if (sesiHariIni.isEmpty) return;

    // Ambil sesi yang belum diminum pertama, atau sesi terakhir
    final sesi = sesiHariIni.firstWhere(
      (s) => s['sudahMinum'] == false,
      orElse: () => sesiHariIni.last,
    );
    final waktu = sesi['waktu'] as String;

    // Cari jadwal obat di waktu tersebut
    final obatSesi = _repo
        .getJadwalList()
        .where((j) => j.waktuMinum.contains(waktu))
        .toList();

    if (obatSesi.isEmpty) return;

    if (obatSesi.length == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailObatPage(jadwal: obatSesi.first),
        ),
      );
    } else if (obatSesi.length > 1) {
      _showPilihObatSheet(obatSesi);
    }
  }

  /// Tampilkan bottom sheet daftar obat untuk dipilih.
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailObatPage(jadwal: obat),
                          ),
                        );
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

  /// Navigasi ke halaman pengingat obat (tab Obat).
  void _onKepatuhanTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ObatPage()),
    );
  }

  /// Hitung ulang data kepatuhan, pengingat, dan riwayat kesehatan.
  void _recalculate() {
    _hasJadwal = _repo.getJadwalList().isNotEmpty;
    _kepatuhanPersen = _repo.getKepatuhanPersen();
    _streak = _repo.getStreak();

    // Hitung riwayat pemeriksaan dinamis dari database Hive
    final riwayatList = RiwayatPemeriksaanRepository.instance.riwayatList;
    final now = DateTime.now();
    _cekBulanIni = riwayatList
        .where(
          (item) =>
              item.type == 'AI Check' &&
              item.date.month == now.month &&
              item.date.year == now.year,
        )
        .length;
    _konsultasiSelesai = riwayatList
        .where((item) => item.type == 'Konsultasi')
        .length;

    // Cari sesi berikutnya yang belum diminum hari ini.
    final sesiHariIni = _repo.getSesiHariIni();
    final sesiBelum = sesiHariIni.where((s) => s['sudahMinum'] == false);

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
            BerandaHeader(
              userName: _activeMember?.name ?? 'Pengguna',
              userInitials: _activeMember?.initials ?? 'US',
              status: _activeMember?.status ?? 'Terdaftar',
            ),
            const SizedBox(height: 20),

            /// Kartu promosi fitur Cek AI.
            CekAiCard(
              onStartTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CekAiPage()),
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
            if (!_loading && _hasJadwal) ...[
              PengingatObatCard(
                title: _pengingatTitle,
                time: _pengingatTime,
                isTaken: _pengingatIsTaken,
                onTap: _onPengingatTap,
              ),
              const SizedBox(height: 16),
            ],

            /// Kartu kepatuhan obat — data live dari ObatRepository.
            _loading
                ? const SizedBox.shrink()
                : KepatuhanObatCard(
                    percentage: _kepatuhanPersen.toDouble(),
                    streakDays: _streak,
                    onTap: _onKepatuhanTap,
                  ),
            const SizedBox(height: 24),

            /// Section edukasi & artikel.
            EdukasiSection(
              onSemuaArtikel: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EdukasiListPage()),
                );
              },
            ),
            const SizedBox(height: 20),

            /// Kartu fakta "Tahukah Anda?".
            const TahukahAndaCard(
              fact:
                  'TBC adalah penyakit yang bisa disembuhkan dengan pengobatan tepat',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// [_ObatListItem] - Item daftar obat untuk bottom sheet (digunakan di Beranda & Obat).
class _ObatListItem extends StatelessWidget {
  final JadwalObat jadwal;
  final VoidCallback onTap;

  const _ObatListItem({required this.jadwal, required this.onTap});

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
