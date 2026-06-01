import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [CekAiInputBar] - Bar input di bagian bawah halaman Cek AI.
///
/// Menampilkan text field untuk mengetik gejala dan tombol kirim.
/// Text field fungsional (bisa diketik), tombol kirim saat ini
/// hanya placeholder.
///
/// Parameter:
/// - [controller]: Controller untuk text field.
/// - [onSend]: Callback saat tombol kirim ditekan.
class CekAiInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSend;

  const CekAiInputBar({super.key, required this.controller, this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Text field untuk mengetik gejala.
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.6),
                ),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Ketik gejala Anda...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 8),
                    child: Text('🔍', style: const TextStyle(fontSize: 16)),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          /// Tombol kirim.
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
