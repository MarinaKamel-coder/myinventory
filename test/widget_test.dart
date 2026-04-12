import 'package:flutter_test/flutter_test.dart';
import 'package:supermoms/main.dart';

void main() {
  testWidgets('MyInventory basic smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyInventoryApp());
    expect(find.text('MyInventory'), findsOneWidget);
  });
}
