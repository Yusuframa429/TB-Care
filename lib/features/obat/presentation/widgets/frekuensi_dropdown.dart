import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [FrekuensiDropdown] - Widget dropdown untuk memilih frekuensi minum obat.
///
/// Menampilkan dropdown dengan pilihan frekuensi (Setiap hari, dll.)
/// yang sudah distilkan sesuai design system TB Care.
///
/// Parameter:
/// - [value]: Nilai frekuensi yang sedang dipilih.
/// - [onChanged]: Callback saat user memilih frekuensi berbeda.
class FrekuensiDropdown extends StatelessWidget {
  /// Nilai frekuensi yang aktif saat ini.
  final String value;

  /// Callback saat nilai berubah.
  final ValueChanged<String?> onChanged;

  const FrekuensiDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// Daftar pilihan frekuensi.
  static const List<String> _options = [
    'Setiap hari',
    'Setiap 2 hari',
    'Setiap 3 hari',
    'Seminggu sekali',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textSecondary,
      ),
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      items: _options
          .map(
            (option) =>
                DropdownMenuItem<String>(value: option, child: Text(option)),
          )
          .toList(),
    );
  }
}
