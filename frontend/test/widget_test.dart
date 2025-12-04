import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('Landing page renders hero and categories', (tester) async {
    await tester.pumpWidget(const GovbuddyApp());

    // App bar text
    expect(find.text('Govbuddy Bremen'), findsOneWidget);

    // Hero headline and search hint
    expect(
      find.text('Your friendly guide to Bremen bureaucracy'),
      findsOneWidget,
    );
    expect(find.text('Ask anything about living in Bremen...'), findsOneWidget);

    // At least one category card is visible
    expect(find.text('Wohnen & Mietvertrag'), findsWidgets);

    // Leichte Sprache badge in detail card
    expect(find.text('Leichte Sprache'), findsOneWidget);
  });
}
