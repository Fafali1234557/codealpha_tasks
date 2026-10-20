import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codealpha_flashcardquizapp/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> launch(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const FlashcardApp());
    await tester.pumpAndSettle();
  }

  testWidgets('shows questions, reveals answers, and navigates cards', (tester) async {
    await launch(tester);
    expect(find.text('What is Flutter?'), findsOneWidget);
    expect(find.text('Card 1 of 3'), findsOneWidget);

    await tester.tap(find.text('Show Answer'));
    await tester.pumpAndSettle();
    expect(find.text('Flutter is a UI toolkit for building applications.'), findsOneWidget);
    expect(find.text('Hide Answer'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('What programming language does Flutter use?'), findsOneWidget);
    expect(find.text('Show Answer'), findsOneWidget);

    await tester.tap(find.text('Previous'));
    await tester.pumpAndSettle();
    expect(find.text('What is Flutter?'), findsOneWidget);
  });

  testWidgets('creates, edits, and deletes a flashcard', (tester) async {
    await launch(tester);
    await tester.tap(find.text('Add Card'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'What is Dart?');
    await tester.enterText(find.byType(TextField).at(1), 'A programming language.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('What is Dart?'), findsOneWidget);
    expect(find.text('Card 4 of 4'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'What is Flutter built with?');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('What is Flutter built with?'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete Flashcard?'), findsOneWidget);
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(find.text('Card 3 of 3'), findsOneWidget);
    expect(find.text('What is Flutter built with?'), findsNothing);
  });

  testWidgets('rejects empty flashcard submissions', (tester) async {
    await launch(tester);
    await tester.tap(find.text('Add Card'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Please enter both a question and an answer.'), findsOneWidget);
    expect(find.text('Add Flashcard'), findsOneWidget);
  });
}
