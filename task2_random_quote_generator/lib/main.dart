import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const QuoteGeneratorApp());

/// A quote's position in [quoteLibrary] is its stable local favourite ID.
/// Do not reorder the library without migrating saved favourites.
class Quote {
  final String text;
  final String author;
  final String category;

  const Quote({
    required this.text,
    required this.author,
    required this.category,
  });
}

const quoteLibrary = <Quote>[
  Quote(text: 'The only way to do great work is to love what you do.', author: 'Steve Jobs', category: 'Motivation'),
  Quote(text: 'Well done is better than well said.', author: 'Benjamin Franklin', category: 'Motivation'),
  Quote(text: 'Imagination is more important than knowledge.', author: 'Albert Einstein', category: 'Learning'),
  Quote(text: 'The unexamined life is not worth living.', author: 'Socrates', category: 'Life'),
  Quote(text: 'I think, therefore I am.', author: 'René Descartes', category: 'Wisdom'),
  Quote(text: 'Knowledge is power.', author: 'Francis Bacon', category: 'Learning'),
  // Additional original app quotes. These are not attributed to historical figures.
  Quote(text: 'Small steps, repeated daily, can carry you further than a perfect plan.', author: 'Quote Generator', category: 'Motivation'),
  Quote(text: 'Your future is shaped by what you practise, not just what you promise.', author: 'Quote Generator', category: 'Motivation'),
  Quote(text: 'Curiosity is the first step toward understanding.', author: 'Quote Generator', category: 'Learning'),
  Quote(text: 'A mistake becomes valuable when you learn something from it.', author: 'Quote Generator', category: 'Learning'),
  Quote(text: 'Consistency can turn a difficult beginning into a remarkable journey.', author: 'Quote Generator', category: 'Motivation'),
  Quote(text: 'Choose progress over perfection, then keep improving.', author: 'Quote Generator', category: 'Wisdom'),
  Quote(text: 'Make room for rest; a clear mind is part of good work.', author: 'Quote Generator', category: 'Life'),
  Quote(text: 'Kindness is a strength you can practise every day.', author: 'Quote Generator', category: 'Life'),
  Quote(text: 'Questions open doors that assumptions leave closed.', author: 'Quote Generator', category: 'Wisdom'),
  Quote(text: 'The best way to understand a skill is to use it.', author: 'Quote Generator', category: 'Learning'),
];

class QuoteGeneratorApp extends StatefulWidget {
  const QuoteGeneratorApp({super.key});

  @override
  State<QuoteGeneratorApp> createState() => _QuoteGeneratorAppState();
}

class _QuoteGeneratorAppState extends State<QuoteGeneratorApp> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _darkMode = prefs.getBool('quote_dark_mode') ?? false);
  }

  Future<void> _toggleTheme() async {
    setState(() => _darkMode = !_darkMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('quote_dark_mode', _darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Quote Generator',
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: QuoteHomePage(isDarkMode: _darkMode, onToggleTheme: _toggleTheme),
    );
  }
}

class QuoteHomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const QuoteHomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<QuoteHomePage> createState() => _QuoteHomePageState();
}

class _QuoteHomePageState extends State<QuoteHomePage> {
  final Random _random = Random();
  final Set<int> _favourites = <int>{};
  String _category = 'All';
  late int _currentIndex;

  static const _categories = ['All', 'Motivation', 'Learning', 'Life', 'Wisdom'];

  @override
  void initState() {
    super.initState();
    _currentIndex = _random.nextInt(quoteLibrary.length);
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('quote_favourites') ?? <String>[];
    if (!mounted) return;
    setState(() {
      _favourites.addAll(
        ids.map(int.tryParse).whereType<int>().where(
          (index) => index >= 0 && index < quoteLibrary.length,
        ),
      );
    });
  }

  Future<void> _saveFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = _favourites.toList()..sort();
    await prefs.setStringList(
      'quote_favourites',
      ids.map((index) => index.toString()).toList(),
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  String _formattedQuote(int index) {
    final quote = quoteLibrary[index];
    return '"${quote.text}" — ${quote.author}';
  }

  Future<void> _copyQuote() async {
    await Clipboard.setData(ClipboardData(text: _formattedQuote(_currentIndex)));
    if (mounted) _message('Quote copied to clipboard!');
  }

  Future<void> _shareQuote() async {
    try {
      await SharePlus.instance.share(
        ShareParams(text: _formattedQuote(_currentIndex)),
      );
    } catch (_) {
      if (mounted) _message('Sharing unavailable. Use Copy instead.');
    }
  }

  void _toggleFavourite(int index) {
    setState(() {
      if (!_favourites.add(index)) _favourites.remove(index);
    });
    _saveFavourites();
    _message(_favourites.contains(index) ? 'Saved to favourites' : 'Removed from favourites');
  }

  List<int> get _categoryIndices => [
        for (int i = 0; i < quoteLibrary.length; i++)
          if (_category == 'All' || quoteLibrary[i].category == _category) i,
      ];

  void _newQuote() {
    final indices = _categoryIndices;
    if (indices.isEmpty) return;
    if (indices.length == 1) {
      setState(() => _currentIndex = indices.first);
      return;
    }

    final options = indices.where((index) => index != _currentIndex).toList();
    setState(() => _currentIndex = options[_random.nextInt(options.length)]);
  }

  void _chooseCategory(String category) {
    setState(() {
      _category = category;
      if (!_categoryIndices.contains(_currentIndex)) {
        final indices = _categoryIndices;
        _currentIndex = indices[_random.nextInt(indices.length)];
      }
    });
  }

  void _showFavourites() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, updateSheet) {
          final saved = _favourites.toList()..sort();
          return SafeArea(
            child: FractionallySizedBox(
              heightFactor: 0.7,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                    child: Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.pink),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text('Favourite Quotes (${saved.length})',
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: saved.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                'No favourites yet. Tap the heart on a quote to save it!',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: saved.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, item) {
                              final index = saved[item];
                              final quote = quoteLibrary[index];
                              return ListTile(
                                title: Text(quote.text, maxLines: 3,
                                    overflow: TextOverflow.ellipsis),
                                subtitle: Text(quote.author),
                                trailing: IconButton(
                                  tooltip: 'Remove favourite',
                                  onPressed: () {
                                    _toggleFavourite(index);
                                    updateSheet(() {});
                                  },
                                  icon: const Icon(Icons.favorite, color: Colors.pink),
                                ),
                                onTap: () {
                                  setState(() {
                                    _category = 'All';
                                    _currentIndex = index;
                                  });
                                  Navigator.pop(sheetContext);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quote = quoteLibrary[_currentIndex];
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Quote Generator',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Saved quotes',
            onPressed: _showFavourites,
            icon: Badge(
              isLabelVisible: _favourites.isNotEmpty,
              label: Text('${_favourites.length}'),
              child: const Icon(Icons.bookmarks_outlined),
            ),
          ),
          IconButton(
            tooltip: widget.isDarkMode ? 'Use light mode' : 'Use dark mode',
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final small = width < 430;
          final verySmall = width < 360;
          final pad = verySmall ? 14.0 : 24.0;
          final fontSize = verySmall ? 19.0 : (width < 650 ? 22.0 : 26.0);

          Widget button({
            required IconData icon,
            required String label,
            required VoidCallback onPressed,
            bool primary = false,
          }) {
            final child = primary
                ? FilledButton.icon(
                    onPressed: onPressed,
                    icon: Icon(icon),
                    label: Text(label),
                  )
                : OutlinedButton.icon(
                    onPressed: onPressed,
                    icon: Icon(icon),
                    label: Text(label),
                  );
            return SizedBox(height: 52, child: child);
          }

          final buttons = [
            button(icon: Icons.copy, label: 'Copy', onPressed: _copyQuote),
            button(icon: Icons.share_outlined, label: 'Share', onPressed: _shareQuote),
            button(icon: Icons.refresh, label: 'New Quote', onPressed: _newQuote,
                primary: true),
          ];

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colors.primaryContainer, colors.surface],
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 22),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 620),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('DAILY INSPIRATION',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colors.primary,
                                  fontSize: small ? 12 : 14,
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text('Words that inspire greatness',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 22),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (final category in _categories) ...[
                                      ChoiceChip(
                                        label: Text(category),
                                        selected: _category == category,
                                        onSelected: (_) => _chooseCategory(category),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 22),
                              Card(
                                elevation: 6,
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(verySmall ? 18 : (small ? 24 : 32)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Chip(
                                            avatar: const Icon(Icons.local_offer_outlined, size: 17),
                                            label: Text(quote.category),
                                          ),
                                          const Spacer(),
                                          IconButton.filledTonal(
                                            tooltip: _favourites.contains(_currentIndex)
                                                ? 'Remove from favourites'
                                                : 'Save to favourites',
                                            onPressed: () => _toggleFavourite(_currentIndex),
                                            icon: Icon(
                                              _favourites.contains(_currentIndex)
                                                  ? Icons.favorite : Icons.favorite_border,
                                              color: _favourites.contains(_currentIndex)
                                                  ? Colors.pink : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(Icons.format_quote,
                                          size: verySmall ? 46 : 60,
                                          color: colors.primary),
                                      const SizedBox(height: 12),
                                      AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 350),
                                        transitionBuilder: (child, animation) =>
                                            FadeTransition(opacity: animation, child: child),
                                        child: Column(
                                          key: ValueKey(_currentIndex),
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('"${quote.text}"',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: fontSize,
                                                fontWeight: FontWeight.w600,
                                                height: 1.5,
                                              ),
                                            ),
                                            const SizedBox(height: 22),
                                            Text('— ${quote.author}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: colors.primary,
                                                fontSize: small ? 15 : 17,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              if (small) ...[
                                for (final action in buttons) ...[
                                  SizedBox(width: double.infinity, child: action),
                                  const SizedBox(height: 10),
                                ],
                              ] else
                                Row(
                                  children: [
                                    Expanded(child: buttons[0]),
                                    const SizedBox(width: 10),
                                    Expanded(child: buttons[1]),
                                    const SizedBox(width: 10),
                                    Expanded(flex: 2, child: buttons[2]),
                                  ],
                                ),
                              const SizedBox(height: 18),
                              Text(
                                '${quoteLibrary.length} quotes  •  ${_favourites.length} saved',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: colors.onSurfaceVariant),
                              ),
                              const SizedBox(height: 9),
                              const Text('Stay inspired. Keep growing.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}