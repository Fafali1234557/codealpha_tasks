# CodeAlpha App Development — Final Submission Guide

## Projects
- [Task 1: Flashcard Quiz App](task1_flashcardquizapp/)
- [Task 2: Random Quote Generator](task2_random_quote_generator/)
- [Task 3: Fitness Tracker](task3_fitness_tracker/)

All three are Flutter applications containing source, dependency manifests, native project files, documentation and widget tests. The `Flutter CI` GitHub Actions workflow runs analysis and tests for each folder.

## Verify the source
From the root of each task, run:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Repository naming
The provided internship instructions use the exact convention `CodeAlpha_ProjectName`. Our current public repository is `Fafali1234557/codealpha_tasks`. If the official form accepts one link for all three tasks, rename it to `CodeAlpha_AppDevelopment` on GitHub under **Settings → General → Repository name**. GitHub redirects links from its previous repository URL, but update any links in LinkedIn/posts and your local Git remote after renaming. If the form requests separate project links, create repos `CodeAlpha_FlashcardQuizApp`, `CodeAlpha_RandomQuoteGenerator`, and `CodeAlpha_FitnessTracker`, and push the respective project folders. Confirm this requirement from the official submission form before changing your repository.

## Non-code requirements (the intern must complete)
- [ ] Announce your internship on LinkedIn and tag CodeAlpha.
- [ ] Post a demonstration video explaining your working app projects, tag CodeAlpha and include the GitHub link(s).
- [ ] Complete the official submission form provided by your CodeAlpha WhatsApp group.
- [ ] Follow the official payment process if applicable; do not pay unverified agents.
- [ ] Save your submission confirmation for your records.

Submitting and passing project tests does **not** automatically guarantee a completion certificate, a recommendation letter, or placement support. CodeAlpha evaluates eligibility.
