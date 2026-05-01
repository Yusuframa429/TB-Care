import 'package:flutter/material.dart';

/// [ObatPage] - Halaman informasi dan manajemen obat.
///
/// Halaman ini menampilkan daftar obat-obatan terkait pengobatan TB,
/// jadwal minum obat, serta informasi dosis dan efek samping
/// untuk membantu pasien menjalani pengobatan dengan disiplin.
///
/// TODO: Implementasi fitur Obat oleh tim.
class ObatPage extends StatelessWidget {
  const ObatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Halaman Obat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
