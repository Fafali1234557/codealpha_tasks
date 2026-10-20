import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task2_random_quote_generator/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> launch(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const QuoteGeneratorApp());
    await tester.pumpAndSettle();
  }

  int currentQuoteIndex(WidgetTester tester) {
    return quoteLibrary.indexWhere(
      (q) => find.text('"${q.text}"').evaluate().isNotEmpty,
    );
  }

  testWidgets('displays a quote and generates a different quote', (tester) async {
    await launch(tester);
    expect(find.text('Quote Generator'), findsOneWidget);
    final first = currentQuoteIndex(tester);
    expect(first, greaterThanOrEqualTo(0));
    expect(find.text('— ${quoteLibrary[first].author}'), findsOneWidget);

    await tester.tap(find.text('New Quote'));
    await tester.pumpAndSettle();
    final second = currentQuoteIndex(tester);
    expect(second, greaterThanOrEqualTo(0));
    expect(second, isNot(first));
    expect(find.text('— ${quoteLibrary[second].author}'), findsOneWidget);
  });

  testWidgets('saves favourite quotes to device preferences', (tester) async {
    await launch(tester);
    await tester.tap(find.byTooltip('Save to favourites'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Remove from favourites'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('quote_favourites'), isNotEmpty);

    await tester.tap(find.byTooltip('Remove from favourites'));
    await tester.pumpAndSettle();
    expect(prefs.getStringList('quote_favourites'), isEmpty);
  });

  testWidgets('persists theme preference', (tester) async {
    await launch(tester);
    await tester.tap(find.byTooltip('Use dark mode'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('quote_dark_mode'), isTrue);
    expect(find.byTooltip('Use light mode'), findsOneWidget);
  });
}
