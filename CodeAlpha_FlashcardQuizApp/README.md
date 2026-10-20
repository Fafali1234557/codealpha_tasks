# Flashcard Quiz App

**An interactive study companion built with Flutter and Dart.** Create your own question-and-answer cards, test your recall, and navigate a study deck without distractions.

[![Flutter CI](https://github.com/Fafali1234557/codealpha_tasks/actions/workflows/flutter-tests.yml/badge.svg)](https://github.com/Fafali1234557/codealpha_tasks/actions/workflows/flutter-tests.yml)
![Flutter](https://img.shields.io/badge/Flutter-Dart-02569B?logo=flutter&logoColor=white)
![CodeAlpha](https://img.shields.io/badge/CodeAlpha-App%20Development-555555)

> **Internship project:** CodeAlpha App Development · Flashcard Quiz App  
> **Developer:** [@Fafali1234557](https://github.com/Fafali1234557)  
> [← Back to the project collection](../README.md)

## The problem

Students need a lightweight way to practice active recall using questions they can edit themselves. This app provides a focused deck with controls for reviewing and managing study material.

## Features

- **Question and answer sides:** The card shows a question first; **Show Answer** reveals the answer and **Hide Answer** flips back.
- **Deck navigation:** **Next** and **Previous** move between cards, including wrap-around at either end.
- **Create, edit and delete:** Dialogs allow users to maintain a personalized collection.
- **Input validation:** Blank questions or answers cannot be saved; deleting the last card is prevented.
- **Study progress:** A card-position counter and progress bar indicate where the learner is within the deck.
- **Responsive Material interface:** Card-based layout, dialogs and distinct action buttons.

## Built with

| Technology | Purpose |
| --- | --- |
| Flutter and Dart | Cross-platform interface and application logic |
| Material 3 | Consistent, accessible UI components |
| StatefulWidget and setState | Manage the currently visible card and deck changes |
| flutter_test | Automated interaction tests |
| GitHub Actions | Continuous code analysis and test execution |

## Run locally

Install the [Flutter SDK](https://docs.flutter.dev/get-started/install), then run:

```bash
git clone https://github.com/Fafali1234557/codealpha_tasks.git
cd codealpha_tasks/CodeAlpha_FlashcardQuizApp
flutter pub get
flutter run
```

Use `flutter devices` to see available Android devices or emulators.

## Tests and quality checks

```bash
flutter analyze
flutter test
```

The widget tests exercise card navigation, revealing answers, adding/editing/deleting cards and blank-field validation. The [repository CI](https://github.com/Fafali1234557/codealpha_tasks/actions) also runs analysis and tests on every push to `main`.

## Code layout

```text
CodeAlpha_FlashcardQuizApp/
├── lib/main.dart          # Flutter UI, deck state and user actions
├── test/widget_test.dart   # Widget interaction tests
├── pubspec.yaml            # Dependencies and SDK constraints
├── android/ ios/ web/     # Native and web project files
└── README.md
```

## Design decisions and limitations

- Flashcards are currently **stored in memory**. User changes do **not** persist after the app is closed.
- The progress bar represents position in the deck, **not** a mastery score.
- A logical next improvement is local database persistence and optional spaced-repetition scheduling.

## What this project demonstrates

Interactive mobile UI development, form validation, state management, defensive handling of destructive actions, navigation logic and automated Flutter widget testing.

---

Part of my [CodeAlpha App Development portfolio](https://github.com/Fafali1234557/codealpha_tasks).  
<!-- Optional: insert approved demo-video and screenshot links after media is provided. -->
