/// Package [core_services] - Layanan dan utilitas bersama untuk TB Care.
library;

// Service Locator
export 'src/di/service_locator.dart';

// Architecture
export 'src/architecture/failure.dart';
export 'src/architecture/exceptions.dart';
export 'src/architecture/result.dart';
export 'src/architecture/base_usecase.dart';

// Services
export 'src/services/env_service.dart';
export 'src/services/logger_service.dart';
export 'src/services/storage_service.dart';
export 'src/services/network_service.dart';

// AI
export 'src/ai/ai_client.dart';
