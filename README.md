# CodeAlpha App Development Internship 🚀

A collection of mobile applications built with **Flutter** and **Dart** during my **CodeAlpha App Development Internship**. This repository documents my hands-on practice with mobile interfaces, application state, user interaction, and problem-solving.

**Developer:** [Fafali1234557](https://github.com/Fafali1234557)  
**Internship domain:** App Development  
**Technologies:** Flutter · Dart · Material Design 3

---

## 📱 Projects

| Task | Project | Description | Status |
| --- | --- | --- | --- |
| 1 | [Flashcard Quiz App](task1_flashcardquizapp/) | Create, review, and manage question-and-answer flashcards. | ✅ Built |
| 2 | [Random Quote Generator](task2_random_quote_generator/) | Generate, copy, share, and favourite quotes, with categories and theme switching. | ✅ Source uploaded |
| 3 | [Fitness Tracker](task3_fitness_tracker/) | Log activity, view daily and weekly progress, edit records, and save data locally. | ✅ Source uploaded |

**Status:** All three folders now include Flutter Android, iOS, web, Windows, macOS and Linux platform scaffolding, as well as their own widget tests. CodeAlpha internship reviewers can open each Flutter project independently. The `.github/workflows/flutter-tests.yml` workflow runs `flutter pub get`, `flutter analyze`, and `flutter test` for each project.

## 🧠 Task 1 — Flashcard Quiz App

The **Flashcard Quiz App** is a simple study companion that helps users review questions and reveal their answers one card at a time. It was developed to meet CodeAlpha's flashcard application requirements.

### Features

- **Question and answer cards:** View a question, then reveal its corresponding answer.
- **Show Answer / Hide Answer:** Toggle the displayed side using a dedicated button.
- **Next / Previous navigation:** Move through cards, with wrap-around navigation.
- **Add flashcards:** Enter a new question and answer.
- **Edit flashcards:** Update the current card.
- **Delete flashcards:** Remove a card after confirmation; the app prevents deleting the last remaining card.
- **Input validation:** Prevent saving cards with empty questions or answers.
- **Card counter and progress indicator:** Show the current position in the deck.
- **Clean interface:** Material 3 styling, simple controls, and a blue-themed layout.

### CodeAlpha requirements

| Requirement | Implementation |
| --- | --- |
| Question on the front, answer on the back | Question/answer display with toggle |
| Dedicated **Show Answer** button | ✅ |
| **Next** and **Previous** buttons | ✅ |
| Add, edit, and delete flashcards | ✅ |
| Simple and clean user interface | ✅ |

### Run the app locally

**Prerequisites:** [Flutter SDK](https://docs.flutter.dev/get-started/install), a configured Flutter development environment, and an Android device or emulator.

```bash
git clone https://github.com/Fafali1234557/codealpha_tasks.git
cd codealpha_tasks/task1_flashcardquizapp
flutter pub get
flutter run
```

To verify your environment before running the project:

```bash
flutter doctor
```

### Project structure

```text
codealpha_tasks/
├── README.md
├── .gitignore
└── task1_flashcardquizapp/
    ├── lib/
    │   └── main.dart
    ├── android/
    ├── pubspec.yaml
    └── ...
```

### Current limitation

Flashcards are held **in memory** in the current version. Cards added or edited during a session are not permanently saved after the app restarts. The progress indicator shows the user's **position in the deck**, not a learned-card score.

### Skills practiced

- Building Flutter interfaces with Material widgets
- Managing interactive UI state with `StatefulWidget` and `setState()`
- Handling text input and validating form data
- Working with dialogs, buttons, and navigation
- Organizing and publishing a project with Git and GitHub

---

## 💜 Task 2 — Random Quote Generator

A responsive Flutter app featuring random inspirational quotes, clipboard copying, sharing, category selection, favourites, and persistent theme preferences.

- [Task 2 source and setup](task2_random_quote_generator/)
- Includes platform files for Android, iOS, web and desktop Flutter targets
- Favourites and theme preferences are stored locally

---

## 💚 Task 3 — Fitness Tracker

A Flutter fitness dashboard built for manual workout logging and visual progress tracking.

- [Task 3 source and setup](task3_fitness_tracker/)
- Record steps, duration, estimated calories, activity type, and dates
- View daily goal progress and seven-day trends; edit and delete saved entries
- Activity data is kept locally with `shared_preferences`
- This project does **not** automatically read the phone's motion sensors

---

## 👨‍💻 Developer

**GitHub:** [@Fafali1234557](https://github.com/Fafali1234557)

Built as part of the **CodeAlpha App Development Internship**. Thanks to CodeAlpha for the opportunity to practice and grow through hands-on projects.

---

## ✅ Automated verification

Every project contains `test/widget_test.dart`. From inside a task folder, run:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

The GitHub [Flutter CI workflow](.github/workflows/flutter-tests.yml) runs analysis and tests on every push to `main`. A successful CI run is separate from CodeAlpha's final submission and evaluation.

## 📤 CodeAlpha App Development submission

- [Submission instructions and final checks](SUBMISSION.md)
- [App Development submission form answers (ready to copy)](CODEALPHA_APP_DEVELOPMENT_FORM.md)
- [Automated test results](../../actions) — all three projects passed the GitHub Actions analysis and widget tests on October 20, 2026.

**Submission note:** CodeAlpha's November 23, 2025 task-submission tutorial says each internship batch has its own submission-form link. Use only the link provided in your batch's WhatsApp group. The current repository is named `codealpha_tasks`, while your written assignment requests `CodeAlpha_ProjectName`. Rename through GitHub Settings if your batch requires that pattern; the connected tools cannot rename a repository. A GitHub push alone is not a completed submission.

