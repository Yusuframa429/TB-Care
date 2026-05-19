import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [MingguIniCard] - Kartu tracker kepatuhan mingguan.
///
/// Menampilkan 7 hari dalam seminggu (Sen-Min) dengan indikator
/// apakah obat sudah diminum (centang hijau), belum/tidak (silang),
/// atau hari ini (lingkaran outline).
///
/// Saat ini menggunakan data dummy.
class MingguIniCard extends StatelessWidget {
  /// Status minum obat per hari (7 elemen, index 0 = Senin).
  /// Nilai: 'done', 'missed', 'today', 'upcoming'.
  final List<String> statusPerHari;

  const MingguIniCard({
    super.key,
    required this.statusPerHari,
  });

  static const List<String> _namaHari = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header section.
          const Row(
            children: [
              Text('🗓️', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'Minggu Ini',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          /// Grid 7 hari.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              return _DayIndicator(
                namaHari: _namaHari[index],
                status: index < statusPerHari.length
                    ? statusPerHari[index]
                    : 'upcoming',
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// [_DayIndicator] - Indikator satu hari (nama hari + lingkaran status).
class _DayIndicator extends StatelessWidget {
  final String namaHari;

  /// 'done' = sudah minum, 'missed' = tidak minum,
  /// 'today' = hari ini (belum selesai), 'upcoming' = belum tiba
  final String status;

  const _DayIndicator({required this.namaHari, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Widget icon;

    switch (status) {
      case 'done':
        bgColor = AppColors.primary;
        borderColor = AppColors.primary;
        icon = const Icon(Icons.check, color: AppColors.white, size: 16);
        break;
      case 'missed':
        bgColor = AppColors.dangerLight;
        borderColor = AppColors.danger;
        icon = const Icon(Icons.close, color: AppColors.danger, size: 16);
        break;
      case 'today':
        bgColor = AppColors.primaryLight;
        borderColor = AppColors.primary;
        icon = Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        );
        break;
      default: // upcoming
        bgColor = const Color(0xFFF3F4F6);
        borderColor = AppColors.border;
        icon = const Text('—', style: TextStyle(fontSize: 12, color: AppColors.textSecondary));
    }

    return Column(
      children: [
        Text(
          namaHari,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Center(child: icon),
        ),
      ],
    );
  }
}
