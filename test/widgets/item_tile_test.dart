import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supermoms/app/theme/app_theme.dart';
import 'package:supermoms/features/items/widgets/item_tile.dart';

void main() {
  group('ItemTile Widget Tests', () {
    testWidgets('should display title and subtitle correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ItemTile(
              title: 'Assiettes blanches',
              subtitle: 'Service de table complet',
            ),
          ),
        ),
      );

      expect(find.text('Assiettes blanches'), findsOneWidget);
      expect(find.text('Service de table complet'), findsOneWidget);
    });

    testWidgets('should display quantity when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ItemTile(
              title: 'Tasses à café',
              quantity: 3,
            ),
          ),
        ),
      );

      expect(find.text('Tasses à café'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });
  });
}
