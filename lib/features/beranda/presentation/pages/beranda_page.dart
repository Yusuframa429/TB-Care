import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../widgets/beranda_header.dart';
import '../widgets/cek_ai_card.dart';
import '../widgets/riwayat_kesehatan_section.dart';
import '../widgets/pengingat_obat_card.dart';
import '../widgets/kepatuhan_obat_card.dart';
import '../widgets/edukasi_section.dart';
import '../widgets/tahukah_anda_card.dart';

/// [BerandaPage] - Halaman utama (Home) aplikasi TB Care.
///
/// Halaman ini merupakan halaman pertama yang dilihat pengguna
/// setelah membuka aplikasi. Menampilkan:
/// - Header dengan sapaan dinamis dan info pengguna
/// - Kartu fitur Cek AI
/// - Riwayat kesehatan (statistik)
/// - Pengingat obat
/// - Kepatuhan obat (progress bar)
/// - Edukasi & artikel
/// - Fakta menarik "Tahukah Anda?"
///
/// Saat ini menggunakan data dummy. Akan diganti dengan data
/// dari API/backend saat sudah tersedia.
class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

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

            /// Kartu pengingat obat malam.
            const PengingatObatCard(
              title: 'Pengingat Obat Malam',
              time: '20:00',
              isTaken: false,
            ),
            const SizedBox(height: 16),

            /// Kartu kepatuhan obat dengan progress bar.
            const KepatuhanObatCard(
              percentage: 96,
              streakDays: 14,
            ),
            const SizedBox(height: 24),

            /// Section edukasi & artikel.
            const EdukasiSection(),
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
