import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_portal_app/main.dart';

void main() {
  testWidgets('Doctor Portal App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DoctorPortalApp());

    // Verify that the login screen is displayed
    expect(find.text('Doctor Portal'), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
