import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task3_fitness_tracker/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> launch(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const FitnessTrackerApp());
    await tester.pumpAndSettle();
  }

  test('activity JSON serialization round-trips', () {
    final original = Activity(
      id: 'sample-1',
      date: DateTime(2026, 10, 20),
      type: 'Walking',
      steps: 2000,
      minutes: 30,
      calories: 120,
    );
    final restored = Activity.fromJson(
      jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>,
    );
    expect(restored.id, original.id);
    expect(restored.date, original.date);
    expect(restored.type, 'Walking');
    expect(restored.steps, 2000);
    expect(restored.minutes, 30);
    expect(restored.calories, 120);
  });

  testWidgets('logs an activity and persists it locally', (tester) async {
    await launch(tester);
    expect(find.text('No activities yet. Tap Log Activity to start!'), findsOneWidget);

    await tester.tap(find.text('Log Activity'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('steps_input')), '2000');
    await tester.enterText(find.byKey(const Key('minutes_input')), '30');
    await tester.enterText(find.byKey(const Key('calories_input')), '120');
    await tester.tap(find.byKey(const Key('save_activity_button')));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('fitness_activities_v1');
    expect(saved, isNotNull);
    final activities = jsonDecode(saved!) as List<dynamic>;
    expect(activities, hasLength(1));
    expect(activities.first['steps'], 2000);
    expect(activities.first['calories'], 120);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const FitnessTrackerApp());
    await tester.pumpAndSettle();
    expect(find.text('No activities yet. Tap Log Activity to start!'), findsNothing);
    expect(find.textContaining('Last 7 days: 2000 steps'), findsOneWidget);
  });

  testWidgets('rejects an activity with all zero values', (tester) async {
    await launch(tester);
    await tester.tap(find.text('Log Activity'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('steps_input')), '0');
    await tester.enterText(find.byKey(const Key('minutes_input')), '0');
    await tester.enterText(find.byKey(const Key('calories_input')), '0');
    await tester.tap(find.byKey(const Key('save_activity_button')));
    await tester.pump();
    expect(find.text('Enter at least one positive value.'), findsOneWidget);
    expect(find.text('Log an activity'), findsOneWidget);
  });
}
