import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokemon/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyApp', () {
    testWidgets('should have 2 safe areas', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.byType(SafeArea), findsNWidgets(2));
    });

    testWidgets('should show a Progress indicator and then a List View',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.byType(ListView), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ListView), findsOneWidget);

//      await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
//
//      expect(find.byType(Image), findsOneWidget);
    });
  });
}
