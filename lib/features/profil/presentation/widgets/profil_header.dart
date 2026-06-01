import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [ProfilHeader] - Widget header hijau dengan gradient di halaman Profil.
///
/// Menampilkan avatar inisial, nama pengguna, usia, lokasi,
/// status pasien, dan statistik ringkasan (hari pengobatan,
/// kepatuhan, konsultasi).
///
/// Parameter:
/// - [userName]: Nama lengkap pengguna.
/// - [userInitials]: Inisial nama untuk avatar (misal: "BS").
/// - [usia]: Usia pengguna dalam tahun.
/// - [lokasi]: Lokasi tempat tinggal pengguna.
/// - [status]: Status pasien (misal: "Pasien Aktif").
/// - [hariPengobatan]: Jumlah hari pengobatan.
/// - [kepatuhanPersen]: Persentase kepatuhan minum obat.
/// - [konsultasi]: Jumlah konsultasi yang telah dilakukan.
class ProfilHeader extends StatelessWidget {
  /// Nama lengkap pengguna.
  final String userName;

  /// Inisial nama untuk ditampilkan di avatar bulat.
  final String userInitials;

  /// Usia pengguna (misal: "45 tahun").
  final String usia;

  /// Lokasi pengguna (misal: "Jakarta Selatan").
  final String lokasi;

  /// Status pasien, ditampilkan dalam badge hijau.
  final String status;

  /// Jumlah hari pengobatan.
  final int hariPengobatan;

  /// Persentase kepatuhan minum obat (0-100).
  final int kepatuhanPersen;

  /// Jumlah konsultasi yang sudah dilakukan.
  final int konsultasi;

  const ProfilHeader({
    super.key,
    required this.userName,
    required this.userInitials,
    required this.usia,
    required this.lokasi,
    required this.status,
    required this.hariPengobatan,
    required this.kepatuhanPersen,
    required this.konsultasi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      /// Gradient hijau gelap ke hijau utama.
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: [
              /// Baris profil: Avatar + Info pengguna.
              Row(
                children: [
                  /// Avatar lingkaran besar dengan inisial pengguna.
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.white.withValues(alpha: 0.2),
                    child: Text(
                      userInitials,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  /// Kolom info: Nama, usia & lokasi, badge status.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Usia $usia • $lokasi',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 8),

                        /// Badge status pasien.
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4ADE80),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                status,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white.withValues(
                                    alpha: 0.95,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              /// Stats bar: Hari Pengobatan, Kepatuhan, Konsultasi.
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    /// Stat: Hari Pengobatan.
                    _buildStatItem(
                      value: '$hariPengobatan',
                      label: 'Hari Pengobatan',
                    ),

                    /// Divider vertikal.
                    _buildVerticalDivider(),

                    /// Stat: Kepatuhan (%).
                    _buildStatItem(
                      value: '$kepatuhanPersen%',
                      label: 'Kepatuhan',
                    ),

                    /// Divider vertikal.
                    _buildVerticalDivider(),

                    /// Stat: Konsultasi (kali).
                    _buildStatItem(
                      value: '${konsultasi}x',
                      label: 'Konsultasi',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Membangun satu item statistik (angka besar + label kecil).
  Widget _buildStatItem({required String value, required String label}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun divider vertikal di antara stat items.
  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.white.withValues(alpha: 0.2),
    );
  }
}
