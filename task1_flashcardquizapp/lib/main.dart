
import 'package:flutter/material.dart';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcard Quiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const FlashcardHomePage(),
    );
  }
}

class FlashcardHomePage extends StatefulWidget {
  const FlashcardHomePage({super.key});

  @override
  State<FlashcardHomePage> createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  final TextEditingController questionController =
      TextEditingController();

  final TextEditingController answerController =
      TextEditingController();

  final List<Map<String, String>> flashcards = [
    {
      'question': 'What is Flutter?',
      'answer':
          'Flutter is a UI toolkit for building applications.',
    },
    {
      'question': 'What programming language does Flutter use?',
      'answer': 'Flutter uses the Dart programming language.',
    },
    {
      'question': 'What is a variable?',
      'answer':
          'A variable stores a value that can be used by a program.',
    },
  ];

  int currentIndex = 0;
  bool showAnswer = false;

  // ADD FLASHCARD
  void addFlashcard() {
    final question = questionController.text.trim();
    final answer = answerController.text.trim();

    if (question.isEmpty || answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter both a question and an answer.',
          ),
        ),
      );
      return;
    }

    setState(() {
      flashcards.add({
        'question': question,
        'answer': answer,
      });

      currentIndex = flashcards.length - 1;
      showAnswer = false;
    });

    questionController.clear();
    answerController.clear();

    Navigator.of(context).pop();
  }

  // EDIT FLASHCARD
  void editFlashcard() {
    final question = questionController.text.trim();
    final answer = answerController.text.trim();

    if (question.isEmpty || answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter both a question and an answer.',
          ),
        ),
      );
      return;
    }

    setState(() {
      flashcards[currentIndex]['question'] = question;
      flashcards[currentIndex]['answer'] = answer;
    });

    questionController.clear();
    answerController.clear();

    Navigator.of(context).pop();
  }

  // DELETE FLASHCARD
  void deleteFlashcard() {
    if (flashcards.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You must keep at least one flashcard.',
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Flashcard?'),
          content: const Text(
            'Are you sure you want to delete this flashcard?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  flashcards.removeAt(currentIndex);

                  if (currentIndex >= flashcards.length) {
                    currentIndex = flashcards.length - 1;
                  }

                  showAnswer = false;
                });

                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // EDIT DIALOG
  void showEditFlashcardDialog() {
    questionController.text =
        flashcards[currentIndex]['question'] ?? '';

    answerController.text =
        flashcards[currentIndex]['answer'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 8),
              Text('Edit Flashcard'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(
                    labelText: 'Question',
                    prefixIcon: const Icon(Icons.help_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: answerController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    prefixIcon: const Icon(Icons.lightbulb_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                questionController.clear();
                answerController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: editFlashcard,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ADD DIALOG
  void showAddFlashcardDialog() {
    questionController.clear();
    answerController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.add_circle_outline),
              SizedBox(width: 8),
              Text('Add Flashcard'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(
                    labelText: 'Question',
                    prefixIcon: const Icon(Icons.help_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: answerController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    prefixIcon: const Icon(Icons.lightbulb_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                questionController.clear();
                answerController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: addFlashcard,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // NEXT CARD
  void nextCard() {
    if (flashcards.isEmpty) {
      return;
    }

    setState(() {
      currentIndex = (currentIndex + 1) % flashcards.length;
      showAnswer = false;
    });
  }

  // PREVIOUS CARD
  void previousCard() {
    if (flashcards.isEmpty) {
      return;
    }

    setState(() {
      currentIndex = (currentIndex - 1 + flashcards.length) % flashcards.length;
      showAnswer = false;
    });
  }

  // SHOW / HIDE ANSWER
  void toggleAnswer() {
    if (flashcards.isEmpty) {
      return;
    }

    setState(() {
      showAnswer = !showAnswer;
    });
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Flashcard Quiz'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: showAddFlashcardDialog,
          icon: const Icon(Icons.add),
          label: const Text('Add Card'),
        ),
        body: const Center(
          child: Text(
            'No flashcards yet. Add one to get started.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    currentIndex = currentIndex.clamp(0, flashcards.length - 1);
    final card = flashcards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book),
            SizedBox(width: 8),
            Text(
              'Flashcard Quiz',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddFlashcardDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Card'),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Card ${currentIndex + 1} of ${flashcards.length}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: flashcards.isEmpty
                          ? 0
                          : (currentIndex + 1) / flashcards.length,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          showAnswer ? 'ANSWER' : 'QUESTION',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        showAnswer
                            ? (card['answer'] ?? '')
                            : (card['question'] ?? ''),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: toggleAnswer,
                icon: Icon(
                  showAnswer ? Icons.visibility_off : Icons.visibility,
                ),
                label: Text(
                  showAnswer ? 'Hide Answer' : 'Show Answer',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: showEditFlashcardDialog,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: deleteFlashcard,
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: previousCard,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: nextCard,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
