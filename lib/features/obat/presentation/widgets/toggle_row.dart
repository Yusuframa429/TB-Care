import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [ToggleRow] - Baris status toggle on/off dengan ikon.
///
/// Menampilkan ikon, label teks, dan indikator centang hijau
/// jika aktif atau kotak abu-abu jika nonaktif.
class ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool value;

  const ToggleRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: value ? AppColors.primary : AppColors.border, borderRadius: BorderRadius.circular(6)),
          child: value ? const Icon(Icons.check, size: 14, color: AppColors.white) : null,
        ),
      ],
    );
  }
}
