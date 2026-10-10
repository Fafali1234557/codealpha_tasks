# 💜 Random Quote Generator — CodeAlpha Task 2

A responsive Flutter application for discovering inspiration, saving favourite quotes, and sharing quotes with friends. Built for the **CodeAlpha App Development Internship**.

## ✨ Features
- Random inspirational quote on launch
- Generate a new quote without immediately repeating the previous one
- Browse quotes by category: Motivation, Learning, Life, and Wisdom
- **Copy** quote and author to your clipboard
- **Share** quotes using the device's available sharing options
- Save and remove favourite quotes, and view all saved favourites
- Local persistence for favourites and light/dark theme choice
- Responsive UI for mobile, tablet, and desktop/web screens
- Animated transitions and Material 3 styling

> Data is stored on your current device/browser only; it is not synced between devices.

## 🚀 Running locally

Install Flutter and then, inside the existing Flutter project:

```bash
flutter pub get
flutter run -d chrome
```

For Android, use `flutter devices` followed by `flutter run -d <device-id>`.

If you are adding this to an existing project instead of using the included `pubspec.yaml`, run:

```bash
flutter pub add shared_preferences share_plus
flutter pub get
```

## 📱 Test checklist
- [ ] New Quote changes the quote and author
- [ ] Copy places the current text and author onto the clipboard
- [ ] Share opens the system share sheet or supported browser sharing flow
- [ ] Heart icon adds/removes a favourite
- [ ] Saved quotes drawer opens saved quotes; tapping one displays it
- [ ] Favourites persist after closing and reopening
- [ ] Theme persists after closing and reopening
- [ ] Category chips filter available quotes
- [ ] No overflow when resizing the browser or using a small phone

## 🗂 Project structure

```text
task2_random_quote_generator/
├── lib/
│   └── main.dart
├── pubspec.yaml
└── README.md
```

A complete Flutter project also contains platform scaffolding (`android/`, `web/`, etc.) created by `flutter create`.

## 🌐 Publish to the web

```bash
flutter build web --release
```

Deploy the generated `build/web` directory to a static web host that supports Flutter web. This README does **not** imply a live site is already deployed.

## 🧑‍💻 Author
GitHub: [@Fafali1234557](https://github.com/Fafali1234557)  
Internship: CodeAlpha — App Development  
Project: Task 2 — Random Quote Generator