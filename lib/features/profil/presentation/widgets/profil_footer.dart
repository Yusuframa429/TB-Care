import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [ProfilFooter] - Widget footer di bagian bawah halaman Profil.
///
/// Menampilkan banner enkripsi data, tombol keluar akun,
/// dan informasi versi aplikasi.
///
/// Parameter:
/// - [onLogout]: Callback saat tombol "Keluar dari Akun" ditekan.
/// - [appVersion]: Versi aplikasi yang ditampilkan.
class ProfilFooter extends StatelessWidget {
  final VoidCallback? onLogout;
  final String appVersion;

  const ProfilFooter({
    super.key,
    this.onLogout,
    this.appVersion = 'v2.4.1',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          /// Banner enkripsi data.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    'Data Anda terenkripsi — Verified by Kemenkes RI',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          /// Tombol keluar dari akun.
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(
                Icons.logout_rounded,
                size: 18,
                color: AppColors.danger,
              ),
              label: const Text(
                'Keluar dari Akun',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.danger,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(
                  color: AppColors.danger.withValues(alpha: 0.3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          /// Info versi aplikasi.
          Text(
            'TBC AI $appVersion • Didukung oleh Kemenkes RI',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
