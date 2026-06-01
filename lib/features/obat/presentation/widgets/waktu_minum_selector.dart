import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [WaktuMinumSelector] - Widget untuk memilih waktu dan kondisi minum obat.
///
/// Menampilkan:
/// - Baris waktu yang sudah dipilih (jam) dengan tombol hapus.
/// - Chip pilihan kondisi makan: Sebelum, Saat, atau Setelah makan.
/// - Tombol "+ Tambah Waktu Lain" untuk menambah jadwal waktu.
///
/// Parameter:
/// - [waktuList]: List jam yang sudah dipilih (format TimeOfDay).
/// - [kondisiMakan]: Kondisi makan yang dipilih ('Sebelum makan', dll.).
/// - [onWaktuAdded]: Callback saat user memilih jam baru dari time picker.
/// - [onWaktuRemoved]: Callback saat user menghapus satu jam.
/// - [onKondisiChanged]: Callback saat user memilih kondisi makan berbeda.
class WaktuMinumSelector extends StatelessWidget {
  /// List jam minum yang sudah dipilih.
  final List<TimeOfDay> waktuList;

  /// Kondisi makan yang aktif.
  final String kondisiMakan;

  /// Callback saat jam baru ditambahkan dari time picker.
  final ValueChanged<TimeOfDay> onWaktuAdded;

  /// Callback saat satu jam dihapus (berdasarkan index).
  final ValueChanged<int> onWaktuRemoved;

  /// Callback saat kondisi makan diubah.
  final ValueChanged<String> onKondisiChanged;

  const WaktuMinumSelector({
    super.key,
    required this.waktuList,
    required this.kondisiMakan,
    required this.onWaktuAdded,
    required this.onWaktuRemoved,
    required this.onKondisiChanged,
  });

  /// Pilihan kondisi makan yang tersedia.
  static const List<String> _kondisiOptions = [
    'Sebelum makan',
    'Saat makan',
    'Setelah makan',
  ];

  /// Format [TimeOfDay] ke string "HH:mm".
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Baris ikon jam + daftar waktu yang dipilih.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: waktuList.isEmpty
                    ? Text(
                        'Belum ada waktu dipilih',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary.withValues(alpha: 0.6),
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: List.generate(waktuList.length, (index) {
                          return _WaktuChip(
                            label: _formatTime(waktuList[index]),
                            onRemove: () => onWaktuRemoved(index),
                          );
                        }),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          /// Chips kondisi makan.
          Wrap(
            spacing: 8,
            children: _kondisiOptions.map((option) {
              final isSelected = kondisiMakan == option;
              return GestureDetector(
                onTap: () => onKondisiChanged(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          /// Tombol "+ Tambah Waktu Lain".
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  onWaktuAdded(picked);
                }
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tambah Waktu Lain'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// [_WaktuChip] - Chip kecil menampilkan jam dengan tombol hapus (X).
class _WaktuChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _WaktuChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
