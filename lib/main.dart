import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:core_services/core_services.dart';

import 'app/main_shell.dart';

/// Entry point aplikasi TB Care.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Service Core
  await StorageService.instance.init();
  await EnvService.instance.init();

  // Registrasi Global Services ke ServiceLocator
  final sl = ServiceLocator.instance;
  sl.register<StorageService>(StorageService.instance);
  sl.register<EnvService>(EnvService.instance);
  sl.register<AIClient>(AIClient.instance);
  sl.register<NetworkService>(NetworkService());

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
