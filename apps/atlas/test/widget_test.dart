// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:atlas/app.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage/storage.dart';

void main() {
  testWidgets('AtlasApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      AtlasApp(
        storageService: HiveStorageService.instance,
        secureKeyStore: const SecureKeyStore(),
      ),
    );

    expect(find.byType(AtlasApp), findsOneWidget);
  });
}
