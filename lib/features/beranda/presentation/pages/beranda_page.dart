import 'package:flutter/material.dart';

/// [BerandaPage] - Halaman utama (Home) aplikasi TB Care.
///
/// Halaman ini merupakan halaman pertama yang dilihat pengguna
/// setelah membuka aplikasi. Berisi ringkasan informasi kesehatan,
/// shortcut fitur, dan konten edukatif terkait TB.
///
/// TODO: Implementasi konten halaman beranda oleh tim.
class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Halaman Beranda',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
