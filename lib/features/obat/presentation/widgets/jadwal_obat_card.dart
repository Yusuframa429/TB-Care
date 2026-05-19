import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [JadwalObatCard] - Kartu yang menampilkan ringkasan satu jadwal obat.
///
/// Menampilkan nama obat, dosis, waktu minum, frekuensi, dan
/// tombol edit serta hapus untuk setiap jadwal.
///
/// Parameter:
/// - [namaObat]: Nama obat yang dijadwalkan.
/// - [dosis]: Dosis dan satuan (misal: "1 tablet").
/// - [waktuMinum]: Daftar jam minum dalam format string (misal: "08:00", "20:00").
/// - [frekuensi]: Frekuensi minum (misal: "Setiap hari").
/// - [kondisiMakan]: Kondisi makan (misal: "Sebelum makan").
/// - [isAktif]: Apakah pengingat aktif.
/// - [onEdit]: Callback saat tombol edit ditekan.
/// - [onDelete]: Callback saat tombol hapus ditekan.
class JadwalObatCard extends StatelessWidget {
  /// Nama obat.
  final String namaObat;

  /// Dosis dan satuan.
  final String dosis;

  /// List waktu minum dalam format "HH:mm".
  final List<String> waktuMinum;

  /// Frekuensi minum obat.
  final String frekuensi;

  /// Kondisi makan.
  final String kondisiMakan;

  /// Status pengingat aktif.
  final bool isAktif;

  /// Callback untuk edit.
  final VoidCallback? onEdit;

  /// Callback untuk hapus.
  final VoidCallback? onDelete;

  const JadwalObatCard({
    super.key,
    required this.namaObat,
    required this.dosis,
    required this.waktuMinum,
    required this.frekuensi,
    required this.kondisiMakan,
    this.isAktif = true,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
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
        border: Border.all(
          color: isAktif
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Baris atas: Ikon + nama obat + badge aktif + menu.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Ikon obat.
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
              const SizedBox(width: 12),

              /// Nama obat dan dosis.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaObat,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dosis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              /// Badge status aktif/nonaktif.
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isAktif ? AppColors.primaryLight : AppColors.border,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isAktif ? 'Aktif' : 'Nonaktif',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isAktif
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),

          /// Info jadwal: waktu, frekuensi, kondisi makan.
          _InfoRow(
            icon: Icons.access_time_rounded,
            label: waktuMinum.join(', '),
          ),
          const SizedBox(height: 6),
          _InfoRow(
            icon: Icons.repeat_rounded,
            label: '$frekuensi • $kondisiMakan',
          ),
          const SizedBox(height: 14),

          /// Tombol Edit dan Hapus.
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, size: 16),
                  label: const Text('Hapus'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// [_InfoRow] - Baris kecil ikon + teks untuk info jadwal.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
