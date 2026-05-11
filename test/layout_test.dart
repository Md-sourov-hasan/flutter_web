import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jasper_atelier_site/src/pages/home_page.dart';

void main() {
  testWidgets('HomePage layout wide', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();
  });
}
