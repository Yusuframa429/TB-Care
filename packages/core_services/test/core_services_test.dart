import 'package:flutter_test/flutter_test.dart';

import 'package:core_services/core_services.dart';

void main() {
  group('ServiceLocator', () {
    test('register and get a service', () {
      final locator = ServiceLocator.instance;
      locator.register<String>('Hello');
      expect(locator.get<String>(), 'Hello');
    });

    test('throws StateError when service not found', () {
      final locator = ServiceLocator.instance;
      locator.clear();
      expect(
        () => locator.get<String>(),
        throwsA(isA<StateError>()),
      );
    });

    test('clear removes all registered services', () {
      final locator = ServiceLocator.instance;
      locator.register<int>(42);
      locator.clear();
      expect(
        () => locator.get<int>(),
        throwsA(isA<StateError>()),
      );
    });
  });
}
