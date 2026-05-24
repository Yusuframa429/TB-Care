import 'package:flutter_test/flutter_test.dart';
import 'package:tb_care/main.dart';

void main() {
  testWidgets('TB Care app renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const TbCareApp());

    // Verify that the app shell is rendered.
    expect(find.byType(TbCareApp), findsOneWidget);
  });
}
