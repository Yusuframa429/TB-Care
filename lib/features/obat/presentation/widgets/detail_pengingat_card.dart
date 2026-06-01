import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'toggle_row.dart';

/// [DetailPengingatCard] - Kartu pengaturan pengingat obat.
///
/// Menampilkan status notifikasi, getar, dan suara.
/// Detail getar/suara hanya muncul jika notifikasi aktif.
class DetailPengingatCard extends StatelessWidget {
  final bool isNotifikasiAktif;
  final bool isGetar;
  final bool isSuara;

  const DetailPengingatCard({
    super.key,
    required this.isNotifikasiAktif,
    required this.isGetar,
    required this.isSuara,
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
      ),
      child: Column(
        children: [
          ToggleRow(
            icon: Icons.notifications_rounded,
            iconColor: AppColors.primary,
            label: 'Notifikasi',
            value: isNotifikasiAktif,
          ),
          if (isNotifikasiAktif) ...[
            const Divider(height: 20, color: AppColors.border),
            ToggleRow(
              icon: Icons.vibration_rounded,
              iconColor: AppColors.warning,
              label: 'Getar (Vibration)',
              value: isGetar,
            ),
            const Divider(height: 20, color: AppColors.border),
            ToggleRow(
              icon: Icons.volume_up_rounded,
              iconColor: AppColors.info,
              label: 'Suara (Sound)',
              value: isSuara,
            ),
          ],
        ],
      ),
    );
  }
}
