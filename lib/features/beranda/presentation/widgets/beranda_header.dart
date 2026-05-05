import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [BerandaHeader] - Widget header hijau dengan gradient di halaman Beranda.
///
/// Menampilkan sapaan dinamis berdasarkan waktu, nama pengguna,
/// status akun, ikon notifikasi, dan avatar inisial pengguna.
///
/// Parameter:
/// - [userName]: Nama lengkap pengguna yang ditampilkan.
/// - [userInitials]: Inisial nama pengguna untuk avatar (misal: "BS").
/// - [status]: Status akun pengguna (misal: "Terdaftar").
/// - [onNotificationTap]: Callback saat ikon notifikasi ditekan.
class BerandaHeader extends StatelessWidget {
  /// Nama lengkap pengguna.
  final String userName;

  /// Inisial nama untuk ditampilkan di avatar bulat.
  final String userInitials;

  /// Status akun pengguna, ditampilkan dalam badge hijau.
  final String status;

  /// Callback ketika tombol notifikasi (lonceng) ditekan.
  final VoidCallback? onNotificationTap;

  const BerandaHeader({
    super.key,
    required this.userName,
    required this.userInitials,
    required this.status,
    this.onNotificationTap,
  });

  /// Mengembalikan teks sapaan berdasarkan jam saat ini.
  ///
  /// - 04:00 - 10:59 → "Selamat pagi 👋"
  /// - 11:00 - 14:59 → "Selamat siang 👋"
  /// - 15:00 - 17:59 → "Selamat sore 👋"
  /// - 18:00 - 03:59 → "Selamat malam 👋"
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) return 'Selamat pagi 👋';
    if (hour >= 11 && hour < 15) return 'Selamat siang 👋';
    if (hour >= 15 && hour < 18) return 'Selamat sore 👋';
    return 'Selamat malam 👋';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /// Gradient hijau gelap ke hijau utama, memberikan kesan premium.
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Baris atas: Sapaan + Notifikasi & Avatar.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Kolom kiri: Sapaan dan nama pengguna.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Kolom kanan: Ikon notifikasi dan avatar.
                  Row(
                    children: [
                      /// Tombol notifikasi (lonceng).
                      GestureDetector(
                        onTap: onNotificationTap,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      /// Avatar lingkaran dengan inisial pengguna.
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.white,
                        child: Text(
                          userInitials,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Badge status akun pengguna.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Status: $status',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white.withValues(alpha: 0.95),
                      ),
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
}
