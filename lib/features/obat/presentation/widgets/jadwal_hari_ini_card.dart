import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [JadwalHariIniCard] - Kartu jadwal minum obat untuk hari ini.
///
/// Menampilkan satu sesi minum obat (pagi/malam) dengan:
/// - Waktu minum dan ikon jam berwarna
/// - Nama sesi dan daftar obat
/// - Status "Sudah diminum" (jika sudah) atau tombol aksi (jika belum)
///
/// Parameter:
/// - [waktu]: Jam minum obat (misal: "08:00").
/// - [namaSesi]: Nama sesi (misal: "Obat Pagi").
/// - [daftarObat]: Nama-nama obat yang diminum.
/// - [isSudahMinum]: Status apakah sudah minum.
/// - [warnaSesi]: Warna ikon jam sesuai sesi.
/// - [onSudahMinum]: Callback saat tombol "Sudah Minum" ditekan.
/// - [onTunda]: Callback saat tombol "Tunda 30 min" ditekan.
/// - [onTap]: Callback saat kartu ditekan untuk lihat detail.
class JadwalHariIniCard extends StatelessWidget {
  /// Waktu minum dalam format "HH:mm".
  final String waktu;

  /// Nama sesi minum obat.
  final String namaSesi;

  /// Daftar nama obat yang diminum pada sesi ini.
  final String daftarObat;

  /// Status apakah sudah minum.
  final bool isSudahMinum;

  /// Warna ikon jam (hijau untuk pagi, oranye untuk malam).
  final Color warnaSesi;

  /// Callback saat tombol "Sudah Minum" ditekan.
  final VoidCallback? onSudahMinum;

  /// Callback saat tombol "Tunda 30 min" ditekan.
  final VoidCallback? onTunda;

  /// Callback saat kartu ditekan untuk melihat detail obat.
  final VoidCallback? onTap;

  const JadwalHariIniCard({
    super.key,
    required this.waktu,
    required this.namaSesi,
    required this.daftarObat,
    required this.isSudahMinum,
    this.warnaSesi = AppColors.primary,
    this.onSudahMinum,
    this.onTunda,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSudahMinum
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Baris atas: waktu + nama sesi + status/tombol cek.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Kolom waktu dengan ikon jam.
                Column(
                  children: [
                    Icon(
                      Icons.access_time_filled_rounded,
                      color: warnaSesi,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      waktu,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: warnaSesi,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),

                /// Kolom tengah: nama sesi + badge status + daftar obat.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Baris nama sesi + badge jika sudah minum.
                      Row(
                        children: [
                          Text(
                            namaSesi,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (isSudahMinum) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                    size: 12,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Sudah diminum',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),

                      /// Daftar obat.
                      Text(
                        daftarObat,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Tombol centang jika sudah minum.
                if (isSudahMinum)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
              ],
            ),

            /// Baris tombol aksi (jika belum minum).
            if (!isSudahMinum) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  /// Tombol "Sudah Minum".
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onSudahMinum,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Sudah Minum'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  /// Tombol "Tunda 30 min".
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onTunda,
                      icon: const Icon(Icons.access_time, size: 16),
                      label: const Text('Tunda 30 min'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
