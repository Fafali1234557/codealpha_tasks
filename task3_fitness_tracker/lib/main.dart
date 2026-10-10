import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const FitnessTrackerApp());

/// Entries are entered manually; this app does not access phone sensors.
class Activity {
  final String id;
  final DateTime date;
  final String type;
  final int steps;
  final int minutes;
  final int calories;

  const Activity({
    required this.id,
    required this.date,
    required this.type,
    required this.steps,
    required this.minutes,
    required this.calories,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'type': type,
    'steps': steps,
    'minutes': minutes,
    'calories': calories,
  };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json['id'] as String,
    date: DateTime.parse(json['date'] as String),
    type: json['type'] as String,
    steps: (json['steps'] as num).toInt(),
    minutes: (json['minutes'] as num).toInt(),
    calories: (json['calories'] as num).toInt(),
  );
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Fitness Tracker',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    ),
    home: const FitnessHomePage(),
  );
}

class FitnessHomePage extends StatefulWidget {
  const FitnessHomePage({super.key});

  @override
  State<FitnessHomePage> createState() => _FitnessHomePageState();
}

class _FitnessHomePageState extends State<FitnessHomePage> {
  static const int dailyStepGoal = 8000;
  static const int dailyMinuteGoal = 30;
  static const int dailyCalorieGoal = 400;
  final List<Activity> _activities = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('fitness_activities_v1');
    try {
      if (stored != null) {
        final raw = jsonDecode(stored) as List<dynamic>;
        _activities
          ..clear()
          ..addAll(raw.map((entry) => Activity.fromJson(
            Map<String, dynamic>.from(entry as Map),
          )));
      }
    } catch (_) {
      // Invalid local data should not prevent the UI from opening.
      // Do not overwrite it until the user intentionally saves new data.
    }
    if (mounted) setState(() => _loaded = true);
  }

  Future<void> _saveActivities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'fitness_activities_v1',
      jsonEncode(_activities.map((a) => a.toJson()).toList()),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<Activity> _entriesForDay(DateTime day) =>
      _activities.where((a) => _sameDay(a.date, day)).toList();

  int _total(List<Activity> entries, int Function(Activity) value) =>
      entries.fold(0, (sum, a) => sum + value(a));

  // Dialog owns its controllers, so cancelling cannot dispose them
  // while Flutter is still animating the closing route.
  Future<void> _addActivity() async {
    final newActivity = await showDialog<Activity>(
      context: context,
      builder: (_) => const ActivityEditorDialog(),
    );
    if (newActivity == null || !mounted) return;
    setState(() => _activities.insert(0, newActivity));
    await _saveActivities();
  }

  Future<void> _editActivity(Activity existing) async {
    final updated = await showDialog<Activity>(
      context: context,
      builder: (_) => ActivityEditorDialog(existing: existing),
    );
    if (updated == null || !mounted) return;
    final index = _activities.indexWhere((a) => a.id == existing.id);
    if (index == -1) return;
    setState(() => _activities[index] = updated);
    await _saveActivities();
  }

  Future<void> _removeActivity(Activity entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete activity?'),
        content: Text('Remove your ${entry.type.toLowerCase()} entry?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _activities.removeWhere((a) => a.id == entry.id));
    await _saveActivities();
  }

  Widget _metricCard({required String title, required int value,
    required int goal, required String unit, required IconData icon}) {
    final scheme = Theme.of(context).colorScheme;
    final ratio = (value / goal).clamp(0.0, 1.0);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, color: scheme.primary),
              const SizedBox(width: 8), Expanded(child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600)))]),
            const SizedBox(height: 13),
            Text('$value $unit', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text('Goal: $goal $unit',
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: ratio, minHeight: 9,
              borderRadius: BorderRadius.circular(9)),
          ],
        ),
      ),
    );
  }

  Widget _weeklyChart(DateTime now) {
    final scheme = Theme.of(context).colorScheme;
    final days = List.generate(7, (i) {
      final date = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i));
      return (date: date, steps: _total(_entriesForDay(date), (a) => a.steps));
    });
    final largest = days.fold<int>(dailyStepGoal, (maxValue, day) =>
        day.steps > maxValue ? day.steps : maxValue);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last 7 days · Steps',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 165,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final day in days)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Tooltip(message: '${day.steps} steps',
                              child: Text('${day.steps}',
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10))),
                            const SizedBox(height: 5),
                            Container(
                              height: 105 * day.steps / largest + 4,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(7)),
                                color: scheme.primary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('${day.date.day}/${day.date.month}',
                              style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('Bars show manually entered daily steps.',
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  String _dateLabel(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final daily = _entriesForDay(today);
    final totalSteps = _total(daily, (a) => a.steps);
    final totalMinutes = _total(daily, (a) => a.minutes);
    final totalCalories = _total(daily, (a) => a.calories);
    final weekStart = DateTime(today.year, today.month, today.day)
        .subtract(const Duration(days: 6));
    final weekly = _activities.where((a) => !a.date.isBefore(weekStart)).toList();
    final history = [..._activities]..sort((a, b) => b.date.compareTo(a.date));
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Tracker',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addActivity,
        icon: const Icon(Icons.add),
        label: const Text('Log Activity'),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 700;
                return ListView(
                  padding: EdgeInsets.fromLTRB(wide ? 36 : 16, 16,
                      wide ? 36 : 16, 104),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1020),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Your activity dashboard',
                              style: Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 6),
                            Text('Today · ${_dateLabel(today)}',
                              style: TextStyle(color: scheme.onSurfaceVariant)),
                            const SizedBox(height: 24),
                            if (wide)
                              Row(children: [
                                Expanded(child: _metricCard(title: 'Steps',
                                  value: totalSteps, goal: dailyStepGoal,
                                  unit: 'steps', icon: Icons.directions_walk)),
                                const SizedBox(width: 12),
                                Expanded(child: _metricCard(title: 'Workout Time',
                                  value: totalMinutes, goal: dailyMinuteGoal,
                                  unit: 'min', icon: Icons.timer_outlined)),
                                const SizedBox(width: 12),
                                Expanded(child: _metricCard(title: 'Calories',
                                  value: totalCalories, goal: dailyCalorieGoal,
                                  unit: 'kcal', icon: Icons.local_fire_department_outlined)),
                              ])
                            else ...[
                              _metricCard(title: 'Steps', value: totalSteps,
                                goal: dailyStepGoal, unit: 'steps',
                                icon: Icons.directions_walk),
                              const SizedBox(height: 12),
                              _metricCard(title: 'Workout Time', value: totalMinutes,
                                goal: dailyMinuteGoal, unit: 'min',
                                icon: Icons.timer_outlined),
                              const SizedBox(height: 12),
                              _metricCard(title: 'Calories', value: totalCalories,
                                goal: dailyCalorieGoal, unit: 'kcal',
                                icon: Icons.local_fire_department_outlined),
                            ],
                            const SizedBox(height: 26),
                            Text('Weekly progress',
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 12),
                            _weeklyChart(today),
                            const SizedBox(height: 12),
                            Text('Last 7 days: ${_total(weekly, (a) => a.steps)} steps • '
                                '${_total(weekly, (a) => a.minutes)} minutes • '
                                '${_total(weekly, (a) => a.calories)} kcal',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: scheme.onSurfaceVariant)),
                            const SizedBox(height: 26),
                            Text('Activity history',
                              style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 12),
                            if (history.isEmpty)
                              const Card(
                                child: Padding(
                                  padding: EdgeInsets.all(30),
                                  child: Text('No activities yet. Tap Log Activity to start!',
                                    textAlign: TextAlign.center),
                                ),
                              )
                            else
                              Card(
                                clipBehavior: Clip.antiAlias,
                                margin: EdgeInsets.zero,
                                child: Column(
                                  children: [
                                    for (int i = 0; i < history.length; i++) ...[
                                      if (i > 0) const Divider(height: 1),
                                      ListTile(
                                        leading: const CircleAvatar(
                                          child: Icon(Icons.fitness_center)),
                                        title: Text(history[i].type),
                                        subtitle: Text('${_dateLabel(history[i].date)} • '
                                          '${history[i].steps} steps • '
                                          '${history[i].minutes} min • '
                                          '${history[i].calories} kcal'),
                                        isThreeLine: true,
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              tooltip: 'Edit activity',
                                              icon: const Icon(Icons.edit_outlined),
                                              onPressed: () => _editActivity(history[i]),
                                            ),
                                            IconButton(
                                              tooltip: 'Delete activity',
                                              icon: const Icon(Icons.delete_outline),
                                              onPressed: () => _removeActivity(history[i]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            const SizedBox(height: 18),
                            Text('Goals: 8,000 steps · 30 minutes · 400 kcal/day. '
                              'Values are manual entries, not automatically detected.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12,
                                color: scheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

// A separate StatefulWidget keeps form fields alive until the dialog route
// has completely finished closing. This fixes the Cancel/freeze issue.
class ActivityEditorDialog extends StatefulWidget {
  final Activity? existing;

  const ActivityEditorDialog({super.key, this.existing});

  @override
  State<ActivityEditorDialog> createState() => _ActivityEditorDialogState();
}

class _ActivityEditorDialogState extends State<ActivityEditorDialog> {
  static const _types = ['Walking', 'Running', 'Cycling', 'Gym', 'Yoga', 'Other'];
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _stepsController;
  late final TextEditingController _minutesController;
  late final TextEditingController _caloriesController;
  late DateTime _selectedDate;
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _stepsController = TextEditingController(text: '${existing?.steps ?? 0}');
    _minutesController = TextEditingController(text: '${existing?.minutes ?? 30}');
    _caloriesController = TextEditingController(text: '${existing?.calories ?? 0}');
    _selectedDate = existing?.date ?? DateTime.now();
    _selectedType = existing?.type ?? 'Walking';
  }

  @override
  void dispose() {
    _stepsController.dispose();
    _minutesController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    // Only allow today or past dates: future workouts aren't logged yet.
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: today,
      helpText: 'Choose activity date',
    );
    if (!mounted || picked == null) return;
    setState(() => _selectedDate = picked);
  }

  String? _validateNumber(String? value) {
    final number = int.tryParse(value?.trim() ?? '');
    if (number == null || number < 0 || number > 1000000) {
      return 'Enter a number from 0 to 1,000,000';
    }
    return null;
  }

  Widget _numberInput(
    TextEditingController controller,
    String label,
    String keyName,
  ) {
    return TextFormField(
      key: Key(keyName),
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: _validateNumber,
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final steps = int.parse(_stepsController.text.trim());
    final minutes = int.parse(_minutesController.text.trim());
    final calories = int.parse(_caloriesController.text.trim());
    if (steps == 0 && minutes == 0 && calories == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter at least one positive value.')),
      );
      return;
    }

    // Keep an existing ID so edits update the original record.
    final original = widget.existing;
    final now = DateTime.now();
    final newDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      original?.date.hour ?? now.hour,
      original?.date.minute ?? now.minute,
    );
    Navigator.of(context).pop(Activity(
      id: original?.id ?? now.microsecondsSinceEpoch.toString(),
      date: newDate,
      type: _selectedType,
      steps: steps,
      minutes: minutes,
      calories: calories,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return AlertDialog(
      title: Text(editing ? 'Edit activity' : 'Log an activity'),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Activity type'),
                  items: [
                    for (final type in _types)
                      DropdownMenuItem(value: type, child: Text(type)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedType = value);
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  key: const Key('activity_date_button'),
                  onPressed: _chooseDate,
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: Text(
                    'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
                const SizedBox(height: 12),
                _numberInput(_stepsController, 'Steps', 'steps_input'),
                const SizedBox(height: 12),
                _numberInput(_minutesController, 'Minutes', 'minutes_input'),
                const SizedBox(height: 12),
                _numberInput(_caloriesController, 'Calories burned', 'calories_input'),
                const SizedBox(height: 8),
                const Text(
                  'Enter steps, time or calories manually. At least one must be greater than zero.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          key: const Key('cancel_activity_button'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('save_activity_button'),
          onPressed: _save,
          child: Text(editing ? 'Save changes' : 'Save activity'),
        ),
      ],
    );
  }
}