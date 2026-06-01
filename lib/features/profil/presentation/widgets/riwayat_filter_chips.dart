import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [RiwayatFilterChips] - Widget filter chip untuk memfilter
/// daftar riwayat pemeriksaan berdasarkan jenis.
///
/// Menampilkan tiga pilihan filter: Semua, AI Check, Konsultasi.
/// Chip yang aktif berwarna hijau (primary), sisanya putih dengan border.
///
/// Parameter:
/// - [activeFilter]: Nilai filter yang sedang aktif.
/// - [onFilterChanged]: Callback saat filter berubah.
class RiwayatFilterChips extends StatelessWidget {
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  const RiwayatFilterChips({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  static const List<String> _filters = ['Semua', 'AI Check', 'Konsultasi'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _filters.map((filter) {
        final isActive = filter == activeFilter;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onFilterChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.border,
                  width: 1.2,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
