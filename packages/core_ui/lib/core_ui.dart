/// Package [core_ui] - Kumpulan komponen UI yang dapat digunakan ulang
/// di seluruh fitur aplikasi TB Care.
///
/// Package ini berisi:
/// - **Theme**: Warna ([AppColors]) dan tema ([AppTheme]) global.
/// - **Widgets**: Komponen UI siap pakai seperti [TbCareBottomNavbar].
///
/// Cara import di fitur/app utama:
/// ```dart
/// import 'package:core_ui/core_ui.dart';
/// ```
library;

// -- Theme --
export 'src/theme/app_colors.dart';
export 'src/theme/app_theme.dart';

// -- Widgets --
export 'src/widgets/tb_care_bottom_navbar.dart';
export 'src/widgets/section_header.dart';
