import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [ProfilMenuItem] - Widget menu item reusable di halaman Profil.
///
/// Menampilkan satu baris menu dengan ikon, judul, subtitle,
/// dan chevron ke kanan.
///
/// Parameter:
/// - [icon]: Ikon yang ditampilkan di sisi kiri.
/// - [iconColor]: Warna ikon.
/// - [iconBgColor]: Warna background lingkaran ikon.
/// - [title]: Judul menu item.
/// - [subtitle]: Deskripsi singkat di bawah judul.
/// - [onTap]: Callback saat item ditekan.
/// - [showDivider]: Apakah menampilkan divider di bawah item.
class ProfilMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showDivider;

  const ProfilMenuItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                /// Ikon dalam container dengan background warna.
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),

                /// Judul dan subtitle.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Chevron ke kanan.
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary.withValues(alpha: 0.4),
                  size: 22,
                ),
              ],
            ),
          ),

          /// Divider di bawah item (opsional).
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 70),
              child: Divider(
                height: 1,
                color: AppColors.border.withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }
}
