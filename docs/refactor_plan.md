## Refactor plan for `lib/main.dart`

### Goals
- Reduce `lib/main.dart` from ~1k lines to a lightweight bootstrap file.
- Separate UI concerns (app shell, pages, widgets) for easier maintenance.
- Prepare ground for state management via Provider/Riverpod without circular deps.

### Target structure
```
lib/
├── app/
│   ├── app.dart                 # MyApp widget + theme/locale handling
│   ├── auth_wrapper.dart        # AuthWrapper logic
│   └── app_state.dart           # ChangeNotifier (theme, locale)
├── bootstrap/
│   └── bootstrap.dart           # main() entry, Firebase/init, SplashScreen
├── pages/
│   ├── dashboard/
│   │   ├── dashboard_page.dart
│   │   └── widgets/
│   │       └── quick_action_card.dart
│   ├── calculators/calculators_page.dart
│   └── history/history_page.dart
├── routes/app_router.dart       # Named routes map
└── main.dart                    # Imports bootstrap + runs app
```

### Refactor steps
1. **Bootstrap split**
   - Move current `main()` + SplashScreen init to `bootstrap/bootstrap.dart`.
   - Keep `main.dart` minimal: `import 'bootstrap/bootstrap.dart' as bootstrap; void main() => bootstrap.run();`

2. **App shell extraction**
   - Create `app/app_state.dart` with `ChangeNotifier` storing `ThemeMode` + `Locale`.
   - `app/app.dart` hosts `MultiProvider`, `MaterialApp`, theme/locale wiring.

3. **Auth wrapper**
   - Move `_AuthWrapper` to `app/auth_wrapper.dart`, reuse `AppState` instance.
   - Remove duplicated preference loading—fetch from `AppState`.

4. **Pages & widgets**
   - Move `DashboardPage`, `CalculatorsPage`, `HistoryPage` into `lib/pages/...`.
   - Extract shared widgets (`_buildQuickActionCard`, `_buildModernCard`, history sections) into dedicated files to enable unit tests.

5. **Routing**
   - Add `routes/app_router.dart` that exposes `Map<String, WidgetBuilder>` and typed helpers for navigation.

6. **Follow-ups**
   - After split, wire `AppState` through Provider and remove direct `PreferencesService` calls from widgets.
   - Prepare for future Riverpod migration by isolating state in `AppState`.

### Testing checklist
- `flutter test` (once unit tests are introduced).
- `flutter analyze`.
- Manual smoke test: login flow, theme switch, locale change, navigation to all calculators/history.


