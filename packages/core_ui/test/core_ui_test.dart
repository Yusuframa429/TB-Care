import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:core_ui/core_ui.dart';

void main() {
  /// Test sederhana untuk memastikan konstanta warna pada [AppColors]
  /// sudah terdefinisi dengan benar dan tidak berubah secara tidak sengaja.
  test('AppColors primary color is defined correctly', () {
    expect(AppColors.primary, const Color(0xFF2E7D5B));
    expect(AppColors.primaryLight, const Color(0xFFE8F5EE));
    expect(AppColors.white, const Color(0xFFFFFFFF));
  });

  /// Test untuk memastikan [AppTheme.lightTheme] dapat dibuat tanpa error.
  test('AppTheme lightTheme is created successfully', () {
    final theme = AppTheme.lightTheme;
    expect(theme, isNotNull);
    expect(theme.brightness, Brightness.light);
  });
}
