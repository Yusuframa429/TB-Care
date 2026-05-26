import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [ChatModeToggle] - Widget toggle pill untuk berpindah antara
/// Mode AI dan Chat Dokter.
///
/// Tab aktif ditampilkan dengan background hijau solid dan teks putih.
/// Tab tidak aktif ditampilkan dengan background putih dan border abu-abu.
///
/// Parameter:
/// - [isAiMode]: `true` jika Mode AI sedang aktif.
/// - [onModeChanged]: Callback saat user menekan salah satu tab.
class ChatModeToggle extends StatelessWidget {
  /// `true` = Mode AI aktif, `false` = Chat Dokter aktif.
  final bool isAiMode;

  /// Callback yang mengembalikan `true` untuk Mode AI, `false` untuk Chat Dokter.
  final ValueChanged<bool> onModeChanged;

  const ChatModeToggle({
    super.key,
    required this.isAiMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        children: [
          /// Tombol "Mode AI".
          Expanded(
            child: _buildTab(
              icon: Icons.smart_toy_outlined,
              label: 'Mode AI',
              isActive: isAiMode,
              onTap: () => onModeChanged(true),
            ),
          ),
          const SizedBox(width: 10),

          /// Tombol "Chat Dokter".
          Expanded(
            child: _buildTab(
              icon: Icons.medical_services_outlined,
              label: 'Chat Dokter',
              isActive: !isAiMode,
              onTap: () => onModeChanged(false),
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun satu tombol tab pill.
  Widget _buildTab({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: isActive ? AppColors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
