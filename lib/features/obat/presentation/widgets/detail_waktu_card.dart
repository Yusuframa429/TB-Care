import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [DetailWaktuCard] - Kartu daftar waktu minum obat.
///
/// Menampilkan semua jadwal waktu minum dengan ikon jam berwarna
/// sesuai sesi (pagi/hijau, siang/biru, malam/oranye).
class DetailWaktuCard extends StatelessWidget {
  final List<String> waktuMinum;

  const DetailWaktuCard({super.key, required this.waktuMinum});

  Color _warnaSesi(String waktu) {
    final hour = int.tryParse(waktu.split(':')[0]) ?? 0;
    if (hour < 12) return AppColors.primary;
    if (hour < 17) return AppColors.info;
    return AppColors.warning;
  }

  String _namaSesi(String waktu) {
    final hour = int.tryParse(waktu.split(':')[0]) ?? 0;
    if (hour < 12) return 'Pagi';
    if (hour < 17) return 'Siang';
    return 'Malam';
  }

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
      ),
      child: Column(
        children: [
          ...waktuMinum.asMap().entries.map((entry) {
            final i = entry.key;
            final waktu = entry.value;
            final isLast = i == waktuMinum.length - 1;
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _warnaSesi(waktu).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.access_time_filled_rounded,
                        color: _warnaSesi(waktu),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            waktu,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _namaSesi(waktu),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isLast) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 12),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }
}
