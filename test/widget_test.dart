// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:safenotes/widgets/login_button.dart';

void main() {
  group('ButtonWidget', () {
    testWidgets('renders correctly with text', (WidgetTester tester) async {
      const String buttonText = 'Test Button';
      bool buttonClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonWidget(
              text: buttonText,
              onClicked: () {
                buttonClicked = true;
              },
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      final textFinder = find.text(buttonText);
      expect(textFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pump();

      expect(buttonClicked, true);
    });
  });
}
