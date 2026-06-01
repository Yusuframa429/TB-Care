import 'package:flutter/material.dart';

import 'riwayat_pemeriksaan_page.dart';
import 'manajemen_keluarga_page.dart';
import 'settings/notifikasi_settings_page.dart';
import 'settings/aksesibilitas_settings_page.dart';
import 'package:core_ui/core_ui.dart';

import '../widgets/profil_header.dart';
import '../widgets/emergency_sos_card.dart';
import '../widgets/profil_menu_item.dart';
import '../widgets/profil_footer.dart';
import '../../data/models/family_member_model.dart';
import '../../data/repositories/family_repository.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../auth/presentation/pages/login_page.dart';

/// [ProfilPage] - Halaman profil pengguna.
///
/// Halaman ini menampilkan informasi akun pengguna, statistik
/// pengobatan, kartu darurat SOS, menu kesehatan (riwayat
/// pemeriksaan, manajemen keluarga), menu pengaturan (notifikasi,
/// aksesibilitas, bahasa, privasi), serta opsi keluar akun.
class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  FamilyMemberModel? _activeMember;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActiveMember();
  }

  /// Memuat profil pengguna/anggota keluarga yang sedang aktif.
  Future<void> _loadActiveMember() async {
    setState(() {
      _isLoading = true;
    });

    final member = await FamilyRepository.instance.getActiveMember();

    setState(() {
      _activeMember = member;
      _isLoading = false;
    });
  }

  Future<void> _handleLogout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar Akun'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthRepository.instance.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    final member = _activeMember!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header hijau dengan avatar, info user, dan stats secara dinamis.
            ProfilHeader(
              userName: member.name,
              userInitials: member.initials,
              usia: '${member.age} tahun',
              lokasi: 'Jakarta Selatan',
              status: member.status,
              hariPengobatan: member.hariPengobatan,
              kepatuhanPersen: member.kepatuhanPersen,
              konsultasi: member.konsultasi,
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
                  subtitle: 'Kelola anggota keluarga',
                  showDivider: false,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ManajemenKeluargaPage(),
                      ),
                    );
                    _loadActiveMember(); // Segarkan header profil saat kembali dari halaman manajemen
                  },
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AksesibilitasSettingsPage(),
                      ),
                    );
                  },
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
            ProfilFooter(onLogout: _handleLogout),
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
