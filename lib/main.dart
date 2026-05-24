import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/main_shell.dart';

/// Entry point aplikasi TB Care.
///
/// Fungsi [main] adalah titik masuk pertama yang dijalankan oleh
/// Flutter engine. Dari sini, seluruh widget tree aplikasi dibangun.
Future<void> main() async {
  // Memastikan binding Flutter terinisialisasi sebelum memuat .env
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi database Hive lokal untuk Flutter
  await Hive.initFlutter();

  try {
    // Memuat file konfigurasi .env
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Tetap jalankan aplikasi walaupun .env tidak ada/gagal dimuat,
    // error akan ditangani secara anggun oleh GeminiService.
    debugPrint("Warning: Gagal memuat file .env: $e");
  }

  runApp(const TbCareApp());
}

/// [TbCareApp] - Widget root aplikasi TB Care.
///
/// Mengkonfigurasi [MaterialApp] dengan:
/// - Tema global dari [AppTheme.lightTheme] (didefinisikan di package core_ui).
/// - Halaman awal [MainShell] yang berisi navbar dan halaman-halaman fitur.
///
/// Widget ini bersifat [StatelessWidget] karena tidak memiliki
/// state internal yang berubah.
class TbCareApp extends StatelessWidget {
  const TbCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TB Care',
      debugShowCheckedModeBanner: false,

      /// Menggunakan tema yang sudah dikonfigurasi di core_ui
      /// agar desain konsisten di seluruh aplikasi.
      theme: AppTheme.lightTheme,

      /// [MainShell] berfungsi sebagai kerangka utama yang menampilkan
      /// navbar dan halaman fitur di dalamnya.
      home: const MainShell(),
    );
  }
}
