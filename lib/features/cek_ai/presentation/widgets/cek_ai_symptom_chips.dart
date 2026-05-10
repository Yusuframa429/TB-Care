import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [CekAiSymptomChips] - Widget kumpulan chip gejala TBC.
///
/// Menampilkan beberapa chip/pill yang menunjukkan gejala umum
/// TBC yang bisa dipilih oleh pengguna. Saat ini hanya tampilan
/// statis, logika seleksi akan ditambahkan nanti.
///
/// Parameter:
/// - [symptoms]: Daftar teks gejala yang ditampilkan.
class CekAiSymptomChips extends StatelessWidget {
  final List<String> symptoms;

  const CekAiSymptomChips({
    super.key,
    required this.symptoms,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: symptoms.map((symptom) => _buildChip(symptom)).toList(),
      ),
    );
  }

  /// Membangun satu chip gejala dengan border hijau.
  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
