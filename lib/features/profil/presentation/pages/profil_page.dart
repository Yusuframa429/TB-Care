import 'package:flutter/material.dart';

import 'riwayat_pemeriksaan_page.dart';
import 'settings/notifikasi_settings_page.dart';
import 'package:core_ui/core_ui.dart';

import '../widgets/profil_header.dart';
import '../widgets/emergency_sos_card.dart';
import '../widgets/profil_menu_item.dart';
import '../widgets/profil_footer.dart';

/// [ProfilPage] - Halaman profil pengguna.
///
/// Halaman ini menampilkan informasi akun pengguna, statistik
/// pengobatan, kartu darurat SOS, menu kesehatan (riwayat
/// pemeriksaan, manajemen keluarga), menu pengaturan (notifikasi,
/// aksesibilitas, bahasa, privasi), serta opsi keluar akun.
///
/// Saat ini menggunakan data dummy. Akan diganti dengan data
/// dari API/backend saat sudah tersedia.
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header hijau dengan avatar, info user, dan stats.
            const ProfilHeader(
              userName: 'Budi Santoso',
              userInitials: 'BS',
              usia: '45 tahun',
              lokasi: 'Jakarta Selatan',
              status: 'Pasien Aktif',
              hariPengobatan: 14,
              kepatuhanPersen: 96,
              konsultasi: 3,
            ),
            const SizedBox(height: 20),

            /// Kartu darurat / Emergency SOS.
            const EmergencySosCard(),
            const SizedBox(height: 24),

            /// Section header: KESEHATAN.
            _buildSectionLabel('KESEHATAN'),
            const SizedBox(height: 8),

            /// Menu group: Kesehatan.
            _buildMenuGroup(
              children: [
                ProfilMenuItem(
                  icon: Icons.assignment_outlined,
                  iconColor: AppColors.primary,
                  iconBgColor: AppColors.primaryLight,
                  title: 'Riwayat Pemeriksaan',
                  subtitle: 'Download laporan PDF',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RiwayatPemeriksaanPage(),
                      ),
                    );
                  },
                ),
                ProfilMenuItem(
                  icon: Icons.people_outline_rounded,
                  iconColor: AppColors.primary,
                  iconBgColor: AppColors.primaryLight,
                  title: 'Manajemen Keluarga',
                  subtitle: '2 anggota terdaftar',
                  showDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// Section header: PENGATURAN.
            _buildSectionLabel('PENGATURAN'),
            const SizedBox(height: 8),

            /// Menu group: Pengaturan.
            _buildMenuGroup(
              children: [
                ProfilMenuItem(
                  icon: Icons.notifications_outlined,
                  iconColor: const Color(0xFFF97316),
                  iconBgColor: const Color(0xFFFFF3E0),
                  title: 'Notifikasi',
                  subtitle: 'Aktif — Pengingat obat',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotifikasiSettingsPage(),
                      ),
                    );
                  },
                ),
                ProfilMenuItem(
                  icon: Icons.accessibility_new_rounded,
                  iconColor: AppColors.textSecondary,
                  iconBgColor: const Color(0xFFF3F4F6),
                  title: 'Aksesibilitas',
                  subtitle: 'Ukuran teks normal',
                ),
                ProfilMenuItem(
                  icon: Icons.language_rounded,
                  iconColor: AppColors.primary,
                  iconBgColor: AppColors.primaryLight,
                  title: 'Bahasa',
                  subtitle: 'Bahasa Indonesia',
                ),
                ProfilMenuItem(
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0xFFEF4444),
                  iconBgColor: const Color(0xFFFEE2E2),
                  title: 'Privasi & Keamanan',
                  subtitle: 'Data terenkripsi',
                  showDivider: false,
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// Footer: banner enkripsi, logout, versi app.
            const ProfilFooter(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Membangun label section (misal: "KESEHATAN", "PENGATURAN").
  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary.withValues(alpha: 0.7),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  /// Membangun container group menu dengan background putih
  /// dan rounded corners.
  Widget _buildMenuGroup({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(children: children),
        ),
      ),
    );
  }
}
