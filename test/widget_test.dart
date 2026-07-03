// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:child_record/main.dart';
import 'package:child_record/services/database_service.dart';
import 'package:child_record/services/encryption_service.dart';
import 'package:child_record/services/sync_service.dart';

void main() {
  testWidgets('Child Health Record Booklet smoke test', (WidgetTester tester) async {
    // Create services for testing
    final databaseService = DatabaseService();
    final encryptionService = EncryptionService();
    final syncService = SyncService();
    
    // Initialize encryption
    encryptionService.initialize();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      databaseService: databaseService,
      encryptionService: encryptionService,
      syncService: syncService,
    ));

    // Verify that the app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
