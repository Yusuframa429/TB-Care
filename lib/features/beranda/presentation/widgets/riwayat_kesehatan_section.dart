import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [RiwayatKesehatanSection] - Section riwayat kesehatan di Beranda.
///
/// Menampilkan dua kartu statistik: jumlah cek bulan ini
/// dan jumlah konsultasi yang telah selesai.
///
/// Parameter:
/// - [cekBulanIni]: Jumlah pengecekan kesehatan di bulan ini.
/// - [konsultasiSelesai]: Jumlah konsultasi yang telah diselesaikan.
/// - [onLihatSemua]: Callback saat tombol "Lihat Semua" ditekan.
class RiwayatKesehatanSection extends StatelessWidget {
  /// Jumlah pengecekan kesehatan di bulan ini.
  final int cekBulanIni;

  /// Jumlah konsultasi yang telah diselesaikan.
  final int konsultasiSelesai;

  /// Callback saat tombol "Lihat Semua" ditekan.
  final VoidCallback? onLihatSemua;

  const RiwayatKesehatanSection({
    super.key,
    required this.cekBulanIni,
    required this.konsultasiSelesai,
    this.onLihatSemua,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Header section dengan judul dan link "Lihat Semua".
        SectionHeader(
          title: 'Riwayat Kesehatan',
          emoji: '📊',
          actionText: 'Lihat Semua',
          onActionTap: onLihatSemua,
        ),
        const SizedBox(height: 12),

        /// Dua kartu statistik ditampilkan berdampingan secara horizontal.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              /// Kartu statistik: Cek Bulan Ini.
              Expanded(
                child: _StatCard(
                  icon: Icons.calendar_month_outlined,
                  iconColor: AppColors.primary,
                  iconBgColor: AppColors.primaryLight,
                  value: '$cekBulanIni',
                  label: 'Cek Bulan Ini',
                ),
              ),
              const SizedBox(width: 12),

              /// Kartu statistik: Konsultasi Selesai.
              Expanded(
                child: _StatCard(
                  icon: Icons.assignment_outlined,
                  iconColor: AppColors.info,
                  iconBgColor: AppColors.infoLight,
                  value: '$konsultasiSelesai',
                  label: 'Konsultasi Selesai',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// [_StatCard] - Widget internal untuk kartu statistik kecil.
///
/// Menampilkan satu ikon, satu angka besar, dan satu label kecil.
/// Widget ini bersifat private (_) karena hanya digunakan di dalam
/// file [RiwayatKesehatanSection].
class _StatCard extends StatelessWidget {
  /// Ikon yang ditampilkan di pojok kiri atas kartu.
  final IconData icon;

  /// Warna ikon.
  final Color iconColor;

  /// Warna background lingkaran ikon.
  final Color iconBgColor;

  /// Angka besar yang ditampilkan (misal: "3").
  final String value;

  /// Label kecil di bawah angka (misal: "Cek Bulan Ini").
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Ikon dalam lingkaran berwarna.
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 12),

          /// Angka statistik (besar dan tebal).
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),

          /// Label deskripsi.
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
