import 'package:flutter/material.dart';

/// [QuickReplyChip] - Chip saran pertanyaan cepat untuk user.
///
/// Menampilkan teks berbentuk pill dengan border hijau dan background
/// hijau muda. User dapat menekan chip ini untuk mengirim pertanyaan
/// tersebut ke AI.
class QuickReplyChip extends StatelessWidget {
  /// Teks yang ditampilkan pada chip.
  final String label;

  /// Callback saat chip ditekan.
  final VoidCallback? onTap;

  const QuickReplyChip({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.8, vertical: 6.8),
        decoration: ShapeDecoration(
          color: const Color(0xFFECFDF5),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.80, color: Color(0xFFA7F3D0)),
            borderRadius: const BorderRadius.all(Radius.circular(999)),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF059669),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.33,
          ),
        ),
      ),
    );
  }
}
