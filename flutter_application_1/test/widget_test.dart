import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('To do list starts empty and can add a task',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());

    expect(find.text('All'), findsOneWidget);
    expect(find.text('Work'), findsOneWidget);
    expect(find.text('Completed Today (0)'), findsOneWidget);
    expect(find.text('Check all completed tasks'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Materi 1');
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    expect(find.text('Today (1)'), findsOneWidget);
    expect(find.text('Materi 1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.radio_button_unchecked));
    await tester.pumpAndSettle();

    expect(find.text('Completed Today (1)'), findsOneWidget);
    expect(find.text('Materi 1'), findsOneWidget);
  });
}
