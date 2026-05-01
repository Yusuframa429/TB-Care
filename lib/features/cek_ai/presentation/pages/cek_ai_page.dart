import 'package:flutter/material.dart';

/// [CekAiPage] - Halaman fitur pengecekan kesehatan berbasis AI.
///
/// Halaman ini memungkinkan pengguna melakukan skrining awal
/// gejala Tuberkulosis menggunakan teknologi kecerdasan buatan (AI).
/// Pengguna dapat memasukkan gejala dan mendapatkan analisis awal.
///
/// TODO: Implementasi fitur Cek AI oleh tim.
class CekAiPage extends StatelessWidget {
  const CekAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Halaman Cek AI',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
