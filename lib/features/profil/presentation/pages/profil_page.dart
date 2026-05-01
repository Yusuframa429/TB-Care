import 'package:flutter/material.dart';

/// [ProfilPage] - Halaman profil pengguna.
///
/// Halaman ini menampilkan informasi akun pengguna, pengaturan
/// aplikasi, riwayat pemeriksaan, dan opsi untuk mengelola
/// data pribadi terkait kesehatan.
///
/// TODO: Implementasi fitur Profil oleh tim.
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Halaman Profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
