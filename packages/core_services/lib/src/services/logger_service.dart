import 'package:flutter/foundation.dart';
import 'dart:developer' as dev;

/// [LoggerService] - Utilitas untuk logging yang aman dan rapi.
class LoggerService {
  static void d(String message) {
    if (kDebugMode) {
      dev.log('DEBUG: $message', name: 'TBCare');
    }
  }

  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    dev.log(
      'ERROR: $message',
      name: 'TBCare',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void i(String message) {
    dev.log('INFO: $message', name: 'TBCare');
  }
}
