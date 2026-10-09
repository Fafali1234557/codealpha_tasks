# CodeAlpha App Development Internship 🚀

A collection of mobile applications built with **Flutter** and **Dart** during my **CodeAlpha App Development Internship**. This repository documents my hands-on practice with mobile interfaces, application state, user interaction, and problem-solving.

**Developer:** [Fafali1234557](https://github.com/Fafali1234557)  
**Internship domain:** App Development  
**Technologies:** Flutter · Dart · Material Design 3

---

## 📱 Projects

| Task | Project | Description | Status |
| --- | --- | --- | --- |
| 1 | [Flashcard Quiz App](task1_flashcardquizapp/) | Create, review, and manage question-and-answer flashcards. | ✅ Completed |

Additional internship tasks will be added to this repository as they are completed.

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

## 👨‍💻 Developer

**GitHub:** [@Fafali1234557](https://github.com/Fafali1234557)

Built as part of the **CodeAlpha App Development Internship**. Thanks to CodeAlpha for the opportunity to practice and grow through hands-on projects.
