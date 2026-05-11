import 'package:flutter_test/flutter_test.dart';

import 'package:jasper_atelier_site/src/app.dart';

void main() {
  testWidgets('renders the real Flutter homepage', (tester) async {
    await tester.pumpWidget(const JasperAtelierApp());

    expect(find.text('Jasper Atelier'), findsWidgets);
    expect(find.text('Websites that feel like a category shift.'), findsOneWidget);
    expect(find.text('Book a Build Sprint'), findsOneWidget);
  });
}
