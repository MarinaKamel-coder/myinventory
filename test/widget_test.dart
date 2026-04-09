import 'package:flutter_test/flutter_test.dart';
<<<<<<< Updated upstream
import 'package:supermoms/app/app.dart';

void main() {
  testWidgets('MyInventory basic smoke test', (WidgetTester tester) async {
    // On lance l'app avec notre nouveau MyApp
    await tester.pumpWidget(const MyApp());
=======


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp() as Widget);
>>>>>>> Stashed changes

    // Vérifie qu'on est bien sur l'écran d'accueil (ou n'importe quel test basique)
    expect(find.byType(MyApp), findsOneWidget);
  });
}

class MyApp {
  const MyApp();
}
