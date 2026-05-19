import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [PengingatToggleGroup] - Widget grup toggle switch untuk pengaturan pengingat.
///
/// Menampilkan tiga baris toggle switch:
/// 1. Notifikasi aktif (ikon bel)
/// 2. Getar (ikon getar)
/// 3. Suara (ikon musik)
///
/// Setiap toggle bisa diatur secara independen.
///
/// Parameter:
/// - [isNotifikasiAktif]: Status toggle notifikasi.
/// - [isGetar]: Status toggle getar.
/// - [isSuara]: Status toggle suara.
/// - [onNotifikasiChanged]: Callback saat toggle notifikasi berubah.
/// - [onGetarChanged]: Callback saat toggle getar berubah.
/// - [onSuaraChanged]: Callback saat toggle suara berubah.
class PengingatToggleGroup extends StatelessWidget {
  /// Status toggle notifikasi aktif.
  final bool isNotifikasiAktif;

  /// Status toggle getar.
  final bool isGetar;

  /// Status toggle suara.
  final bool isSuara;

  /// Callback saat toggle notifikasi diubah.
  final ValueChanged<bool> onNotifikasiChanged;

  /// Callback saat toggle getar diubah.
  final ValueChanged<bool> onGetarChanged;

  /// Callback saat toggle suara diubah.
  final ValueChanged<bool> onSuaraChanged;

  const PengingatToggleGroup({
    super.key,
    required this.isNotifikasiAktif,
    required this.isGetar,
    required this.isSuara,
    required this.onNotifikasiChanged,
    required this.onGetarChanged,
    required this.onSuaraChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Column(
          children: [
            /// Baris 1: Notifikasi aktif.
            _ToggleRow(
              icon: Icons.notifications_rounded,
              iconColor: const Color(0xFFF59E0B),
              iconBgColor: const Color(0xFFFFF8E1),
              label: 'Notifikasi aktif',
              value: isNotifikasiAktif,
              onChanged: onNotifikasiChanged,
              showDivider: true,
            ),

            /// Baris 2: Getar.
            _ToggleRow(
              icon: Icons.vibration_rounded,
              iconColor: const Color(0xFF8B5CF6),
              iconBgColor: const Color(0xFFF3E8FF),
              label: 'Getar',
              value: isGetar,
              onChanged: onGetarChanged,
              showDivider: true,
            ),

            /// Baris 3: Suara.
            _ToggleRow(
              icon: Icons.music_note_rounded,
              iconColor: AppColors.textSecondary,
              iconBgColor: const Color(0xFFF3F4F6),
              label: 'Suara',
              value: isSuara,
              onChanged: onSuaraChanged,
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}

/// [_ToggleRow] - Satu baris toggle dengan ikon, label, dan switch.
class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              /// Ikon dalam kotak berwarna.
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 14),

              /// Label.
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              /// Toggle switch.
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.white,
                activeTrackColor: AppColors.primary,
                inactiveThumbColor: AppColors.white,
                inactiveTrackColor: AppColors.border,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),

        /// Divider antar baris (kecuali baris terakhir).
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.border,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
