#  BudApp - Aplikacja Budowlana

**BudApp Logo**

Kompleksowa aplikacja mobilna dla branży budowlanej - narzędzie dla inwestorów, kierowników budowy i wykonawców do zarządzania projektami remontowymi i budowlanymi.

## 📱 O Projekcie

BudApp to zaawansowana aplikacja Flutter zaprojektowana dla profesjonalistów i entuzjastów branży budowlanej. Łączy w sobie kalkulatory budowlane, system zarządzania projektami, inteligentne rekomendacje AI oraz pełne wsparcie dla pracy offline.

## 🎯 Główne Funkcjonalności

### ✅ Kalkulatory Budowlane

- **Kalkulator Powierzchni** - precyzyjne obliczenia metrażu
- **Kalkulator Materiałów** - automatyczne wyliczanie potrzebnych materiałów
- **Kalkulator Robocizny** - szacowanie kosztów pracy
- **Kalkulator Objętości i Masy** - obliczenia dla betonu, cementu, itp.
- **Kalkulator VAT i Podatków** - rozliczenia finansowe

### 🤖 Inteligentny Planer Remontu (AI)

- Automatyczne generowanie planów remontowych
- Sugerowanie materiałów na podstawie opisu prac
- Kolejność zadań z uwzględnieniem zależności
- Rekomendacje oszczędności (materiały, sezonowość)
- Integracja z cenami materiałów z różnych dostawców

### 📊 Generator Raportów PDF

- Pełne plany remontu z podsumowaniem kosztów
- Szczegółowe kosztorysy z podziałem na materiały i robociznę
- Faktury VAT z automatycznymi obliczeniami
- Możliwość udostępniania i eksportu

### 📴 Tryb Offline

- Pełna funkcjonalność bez połączenia z internetem
- Automatyczna synchronizacja po przywróceniu połączenia
- Kolejka zmian offline
- Cache lokalny dla planów remontu

### 🔔 Powiadomienia Push

- Przypomnienia o nadchodzących zadaniach
- Ostrzeżenia budżetowe (przekroczenie 80%, 90%)
- Powiadomienia o zmianach w projekcie
- Alerty pogodowe wpływające na prace

### 🌦️ Integracja z Pogodą

- Bieżąca pogoda i prognoza 5-dniowa
- Rekomendacje dotyczące prac budowlanych
- Ostrzeżenia o niekorzystnych warunkach
- Sugerowanie najlepszych dni na prace zewnętrzne

### 👥 System Ról i Uprawnień

**Investor (Inwestor)**
- Pełne uprawnienia do projektu
- Zarządzanie budżetem i finansami
- Dodawanie/usuwanie członków zespołu
- Zmiana ról użytkowników

**Manager (Kierownik budowy)**
- Zarządzanie projektem i zadaniami
- Przypisywanie zadań wykonawcom
- Generowanie raportów
- Brak dostępu do szczegółowych kosztów

**Contractor (Wykonawca)**
- Widok przypisanych zadań
- Aktualizacja statusu zadań
- Dodawanie zdjęć z realizacji
- Podstawowy dostęp do materiałów

**Viewer (Gość)**
- Tylko odczyt projektu
- Brak możliwości edycji

### 🗺️ Specjaliści w Okolicy

- Mapa z lokalizacją specjalistów budowlanych
- Oceny i recenzje
- Bezpośredni kontakt (telefon/email)
- Filtrowanie po specjalizacji

### 🛒 Sklepy Budowlane w Okolicy

- Google Maps z bieżącą lokalizacją użytkownika
- Automatyczne wyszukiwanie najbliższych hurtowni i marketów budowlanych
- Lista sklepów z adresem, statusem „otwarte/zamknięte” i oceną ⭐
- Odświeżanie danych „pull to refresh”

### 🌍 Wielojęzyczność

- 🇵🇱 Polski
- 🇬🇧 Angielski
- 🇪🇸 Hiszpański
- 🇩🇪 Niemiecki

### 🎨 Tryby Wyświetlania

- Tryb jasny (Light Mode)
- Tryb ciemny (Dark Mode)
- Tryb systemowy (automatyczny)

## 🏗️ Architektura Techniczna

### Stack Technologiczny

**Frontend**
- Flutter 3.x - framework multiplatformowy
- Material Design 3 - nowoczesny UI/UX
- Provider - zarządzanie stanem aplikacji

**Backend**
- Firebase Authentication - bezpieczna autoryzacja
- Cloud Firestore - baza danych NoSQL
- Firebase Cloud Messaging - powiadomienia push
- Firebase Analytics - analityka użytkowania

**Usługi Zewnętrzne**
- OpenWeatherMap API - dane pogodowe
- Google Maps API - mapy i geolokalizacja
- Google Gemini AI - rekomendacje AI

### Biblioteki Kluczowe

```yaml
dependencies:
  - firebase_core: ^3.6.0
  - firebase_auth: ^5.3.1
  - cloud_firestore: ^5.4.3
  - firebase_messaging: ^15.1.3
  - google_generative_ai: ^0.2.2
  - pdf: ^3.10.7
  - connectivity_plus: ^5.0.2
  - flutter_local_notifications: ^17.2.3
  - geolocator: ^10.1.0
  - google_maps_flutter: ^2.5.0
```

## 📁 Struktura Projektu

```
budapp/
├── lib/
│   ├── models/           # Modele danych
│   │   ├── renovation_plan.dart
│   │   ├── user_role.dart
│   │   └── specialist.dart
│   ├── services/         # Logika biznesowa
│   │   ├── ai_service.dart
│   │   ├── auth_service.dart
│   │   ├── pdf_service.dart
│   │   ├── offline_sync_service.dart
│   │   ├── notification_service.dart
│   │   ├── weather_service.dart
│   │   ├── role_service.dart
│   │   └── cache_service.dart
│   ├── screens/          # Ekrany aplikacji
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── l10n/             # Tłumaczenia
│   │   ├── app_pl.arb
│   │   ├── app_en.arb
│   │   ├── app_es.arb
│   │   └── app_de.arb
│   └── main.dart         # Punkt wejścia
├── android/              # Konfiguracja Android
├── ios/                  # Konfiguracja iOS
├── pubspec.yaml          # Zależności projektu
└── README.md
```

## 🚀 Instalacja i Uruchomienie

### Wymagania

- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.19.0)
- Android Studio / Xcode
- Konto Firebase(Zakladane przez rejestracje w aplikacji)

### Kroki Instalacji

1. **Sklonuj repozytorium**
```bash
git clone https://github.com/sstacksmith/budapp.git
cd budapp
```

2. **Zainstaluj zależności**
```bash
flutter pub get
```

3. **Konfiguracja Firebase**

   - Utwórz projekt w Firebase Console
   - Dodaj aplikacje Android/iOS
   - Pobierz `google-services.json` (Android) i `GoogleService-Info.plist` (iOS)
   - Umieść pliki w odpowiednich folderach

4. **Konfiguracja API**

   - Uzyskaj klucz API OpenWeatherMap: https://openweathermap.org/api
   - Dodaj do `.env`:
     ```
     OPENWEATHER_API_KEY=twoj_klucz_z_openweather
     ```
   - Włącz Google Maps + Places API w Google Cloud i dodaj do pliku `.env`:
     ```
     GOOGLE_MAPS_API_KEY=twoj_klucz_z_google_cloud
     GEMINI_API_KEY=twoj_klucz_z_google_cloud
     ```
   - (Android) dodaj meta-data z kluczem Maps w `android/app/src/main/AndroidManifest.xml`
   - (iOS) ustaw GMSApiKey w AppDelegate lub Info.plist

5. **Uruchom aplikację**
```bash
flutter run
```
6. ** AWARYJNIE**
Jeżeli projekt ma problem z budowaniem(Problem z gradle na android), to trzeba wyczyścić build/cale gradle i zbudowac na nowo projekt.

## 🔧 Konfiguracja Firebase

### Authentication

```bash
# Włącz w Firebase Console:
- Email/Password
- Google Sign-In (opcjonalnie)
```

### Firestore

```javascript
// Struktura kolekcji:
renovation_plans/          # Plany remontu
  {planId}/
    - userId
    - name
    - rooms[]
    - totalBudget
    - recommendations[]

user_profiles/             # Profile użytkowników
  {userId}/
    - email
    - displayName
    - role (investor/manager/contractor/viewer)
    - assignedProjects[]

project_members/           # Członkowie projektów
  {projectId_userId}/
    - projectId
    - userId
    - role
    - addedAt

reminders/                 # Przypomnienia
  {reminderId}/
    - userId
    - planId
    - scheduledTime
    - sent
```

### Cloud Messaging

```xml
<!-- Android: dodaj do AndroidManifest.xml -->
<service
    android:name="com.google.firebase.messaging.FirebaseMessagingService"
    android:exported="false">
    <intent-filter>
        <action android:name="com.google.firebase.MESSAGING_EVENT" />
    </intent-filter>
</service>
```

## 📊 Przykłady Użycia

### Generowanie Planu Remontu

```dart
final aiService = AIService();

final plan = await aiService.generateRenovationPlan(
  userId: 'user123',
  name: 'Remont mieszkania',
  description: 'Kompleksowy remont 3-pokojowego mieszkania',
  rooms: [
    Room(
      name: 'Salon',
      area: 25.0,
      type: 'living_room',
      workDescription: 'Malowanie ścian, wymiana podłogi, nowa elektryka',
    ),
  ],
  budget: 50000.0,
);
```

### Eksport do PDF

```dart
final pdfService = PdfService();

// Wygeneruj raport
final file = await pdfService.generateRenovationPdf(plan);

// Udostępnij
await pdfService.sharePdf(file, 'Plan remontu - ${plan.name}');
```

### Sprawdzanie Pogody

```dart
final weatherService = WeatherService();

final weather = await weatherService.getCurrentWeather();
final recommendations = weatherService.getWorkRecommendations(weather);

if (recommendations.isSafeToWork) {
  print('✅ Dobre warunki do pracy!');
} else {
  print('⚠️ Ostrzeżenia: ${recommendations.warnings}');
}
```

### Zarządzanie Rolami

```dart
final roleService = RoleService();

// Dodaj członka do projektu
await roleService.addProjectMember(
  projectId: 'project123',
  userEmail: 'kierownik@example.com',
  role: UserRole.manager,
);

// Sprawdź uprawnienia
final profile = await roleService.getCurrentUserProfile();
if (profile?.hasPermission(Permission.editBudget) ?? false) {
  // Edytuj budżet
}
```

## 🎨 Screenshots

### Ekran Główny
**Dashboard**

### Planer Remontu AI
**AI Planner**

### Raport PDF
**PDF Report**

### Pogoda dla Budowy
**Weather**

## 🧪 Testowanie

```bash
# Testy jednostkowe
flutter test

# Testy integracyjne
flutter test integration_test/

# Analiza kodu
flutter analyze
```

## 📈 Roadmap

### Wersja 1.1 (Q1 2025)
- ✅ Integracja z systemami płatności
- ✅ Zaawansowane wykresy i statystyki
- ✅ Eksport do Excel/CSV
- ✅ Chatbot AI dla porad budowlanych

### Wersja 1.2 (Q2 2025)
- ✅ Rozpoznawanie materiałów ze zdjęć (AI)
- ✅ Wirtualna wizualizacja 3D
- ✅ Integracja z hurtowniami (zamówienia online)
- ✅ System aukcji dla wykonawców

### Wersja 2.0 (Q3 2025)
- [ ] Aplikacja webowa
- [ ] API dla integratorów
- [ ] Marketplace specjalistów
- [ ] System certyfikacji wykonawców

## 🤝 Wkład w Projekt

Chcesz pomóc w rozwoju BudApp? Świetnie!

1. Fork projektu
2. Stwórz branch (`git checkout -b feature/AmazingFeature`)
3. Commit zmian (`git commit -m 'Add some AmazingFeature'`)
4. Push do brancha (`git push origin feature/AmazingFeature`)
5. Otwórz Pull Request

### Wytyczne

- Kod musi przejść `flutter analyze` bez błędów
- Dodaj testy dla nowych funkcji
- Dokumentuj publiczne API
- Używaj konwencji nazewnictwa Dart

## 📄 Licencja

Ten projekt jest licencjonowany na zasadach MIT License - zobacz plik LICENSE dla szczegółów.

## 👨‍💻 Autor

**BudApp Team**
- Email: stefanskistrony@gmail.com
- Website: https://devpatryk.pl-not active
- GitHub: [@budapp](https://github.com/budapp)

## 🙏 Podziękowania

- Flutter Team za wspaniały framework
- Firebase za backend infrastructure
- OpenWeatherMap za API pogodowe
- Społeczność Flutter za wsparcie i inspirację

## 📞 Wsparcie

Masz pytania lub problemy?

- 📧 Email: support@budapp.com
- 💬 Discord: BudApp Community
- 📖 Dokumentacja: https://docs.budapp.com
- 🐛 Issues: https://github.com/sstacksmith/budapp/issues

## ⚡ Quick Start Guide

### Dla Inwestorów

1. Zarejestruj się w aplikacji
2. Utwórz nowy projekt remontu
3. Dodaj pomieszczenia i opisz planowane prace
4. Otrzymaj kosztorys i rekomendacje AI
5. Zaproś kierownika budowy i wykonawców

### Dla Kierowników Budowy

1. Zaakceptuj zaproszenie do projektu
2. Przeglądaj zadania i materiały
3. Przypisuj zadania wykonawcom
4. Monitoruj postępy
5. Generuj raporty dla inwestora

### Dla Wykonawców

1. Dołącz do projektu
2. Zobacz przypisane zadania
3. Aktualizuj status prac
4. Dodawaj zdjęcia z realizacji
5. Oznaczaj zadania jako ukończone

## 🔐 Bezpieczeństwo

- Szyfrowanie danych end-to-end
- Dwuskładnikowa autoryzacja (2FA)
- Regularne backupy Firebase
- GDPR compliant
- Bezpieczne przechowywanie danych osobowych
- Wszystkie wrażliwe dane (klucze API) są przechowywane w pliku `.env`, który nie jest commitowany do repozytorium
- Firebase Authentication zapewnia bezpieczną autoryzację
- Wszystkie połączenia używają HTTPS
- Dane użytkowników są szyfrowane w Firestore

## 📱 Wymagania Systemowe

### Android
- Android 5.0 (API 21) lub nowszy
- 100 MB wolnego miejsca
- Połączenie internetowe (tryb offline po pierwszym uruchomieniu)

### iOS
- iOS 11.0 lub nowszy
- 100 MB wolnego miejsca
- Połączenie internetowe (tryb offline po pierwszym uruchomieniu)

## 🌟 Funkcje Premium (Opcjonalnie)

### Plan Basic (Darmowy)
- ✅ 3 aktywne projekty
- ✅ Podstawowe kalkulatory
- ✅ AI recommendations (5/miesiąc)
- ✅ Export PDF

### Plan Pro (29 PLN/miesiąc)
- ✅ Nielimitowane projekty
- ✅ Wszystkie kalkulatory
- ✅ Nielimitowane AI recommendations
- ✅ Priority support
- ✅ Zaawansowane statystyki

### Plan Business (99 PLN/miesiąc)
- ✅ Wszystko z Pro
- ✅ Zespół do 10 osób
- ✅ API access
- ✅ Custom branding
- ✅ Dedicated support

BUDAPP :)
