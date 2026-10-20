# CodeAlpha App Development — Submission Checklist

**Developer:** Saviour Fafali Ankugah · [LinkedIn](https://www.linkedin.com/in/saviour-ankugah-001b04361/) · [Portfolio](https://saviour-dev.netlify.app/)  
**Internship domain:** App Development (Flutter / Dart)  
**Chosen assignments:** Task 1, Task 2 and Task 3 (3 of 4)  
**GitHub account:** [Fafali1234557](https://github.com/Fafali1234557)  
**Current public repository:** [codealpha_tasks](https://github.com/Fafali1234557/codealpha_tasks)

## Important: CodeAlpha submission tutorial

[Official CodeAlpha YouTube tutorial](https://www.youtube.com/watch?v=H5kMz6VOdno) — published 2025-11-23.

According to the video description, each internship batch receives **its own task submission form in the batch WhatsApp group**. It discusses using correct project links and personal details, avoiding incomplete submissions, and attaching screenshots or other supporting materials where the form requests them. Do **not** use a random form from another batch.

This file reflects the tutorial description and your App Development assignment document, **not a full verified transcript of every video frame**.

## Task links to paste

| Task | App | Direct GitHub project URL |
| --- | --- | --- |
| 1 | Flashcard Quiz App | https://github.com/Fafali1234557/codealpha_tasks/tree/main/CodeAlpha_FlashcardQuizApp |
| 2 | Random Quote Generator | https://github.com/Fafali1234557/codealpha_tasks/tree/main/CodeAlpha_RandomQuoteGenerator |
| 3 | Fitness Tracker | https://github.com/Fafali1234557/codealpha_tasks/tree/main/CodeAlpha_FitnessTracker |

**One link for all three apps (if the form gives one GitHub link field):**  
https://github.com/Fafali1234557/codealpha_tasks

If GitHub repository naming is strictly checked against the task sheet's `CodeAlpha_ProjectName` pattern, rename the repo to `CodeAlpha_AppDevelopment` in GitHub **Settings → General → Repository name**, then update these links. Existing GitHub repository links commonly redirect after rename, but use the new URL in the final form.

## Before opening the form

- [x] Complete 3 App Development tasks
- [x] Upload source code to a public GitHub repo
- [x] Include app project structure, Flutter config and READMEs
- [x] Add tests; GitHub Actions for all three projects passed on 2026-10-20
- [ ] Confirm final required GitHub naming against this batch's form
- [ ] Verify each Flutter app opens and functions on a phone or emulator
- [ ] Share the internship announcement on LinkedIn mentioning/tagging @CodeAlpha (if not already done)
- [ ] Record/show each app working and explain its functions in a LinkedIn video
- [ ] Add your GitHub project link to the LinkedIn video post
- [ ] If requested in your actual form, prepare screenshots and an accessible Google Drive folder
- [ ] Complete and submit the **batch-specific** WhatsApp-group form
- [ ] Save the form submission confirmation

## App demonstrations (suggested)

**Task 1:** Open Flashcard Quiz → Show Answer → Next/Previous → Add → Edit → Delete.  
**Task 2:** Open Quote Generator → New Quote → show the author → Copy → Favourites → toggle theme.  
**Task 3:** Open Fitness Tracker → Log steps/minutes/calories → view daily totals and seven-day chart → edit entry → restart and show local persistence.

Capture screenshots directly from the running app. **No screenshots or LinkedIn demonstration video are included in this repository at this time.** Do not label a project screenshot or a social post as submitted unless it really is.

## Verify Flutter apps in your own environment

From inside each of the three task folders:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

[GitHub Actions: Flutter CI](https://github.com/Fafali1234557/codealpha_tasks/actions) runs analyzer and widget tests for all three tasks, but it does not prove Android APK installation or manual device flows.

## Last-mile details

Use [CODEALPHA_APP_DEVELOPMENT_FORM.md](CODEALPHA_APP_DEVELOPMENT_FORM.md) for copy-ready field values. Enter **your name, registered email, batch, unique intern ID, and LinkedIn post URL from your actual records**. These are not recoverable from a public GitHub repository and must not be guessed.

Never pay an individual or upload passwords, OTPs, bank-card details or MoMo PINs as "submission evidence." Verify any payment requirements through the official form or official CodeAlpha channel.

**Important:** Assignment completion, GitHub test success and form submission are different stages. CodeAlpha decides certificate eligibility, and a performance-based recommendation or placement is not guaranteed.
