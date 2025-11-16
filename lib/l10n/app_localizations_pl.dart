// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Kalkulator Budowlany';

  @override
  String get dashboard => 'Panel główny';

  @override
  String get areaCalculator => 'Kalkulator powierzchni';

  @override
  String get workCalculator => 'Kalkulator robót';

  @override
  String get materialCalculator => 'Kalkulator materiałów';

  @override
  String get history => 'Historia obliczeń';

  @override
  String get length => 'Długość:';

  @override
  String get width => 'Szerokość (m)';

  @override
  String get height => 'Wysokość (m)';

  @override
  String get density => 'Gęstość (kg/m³)';

  @override
  String get calculateArea => 'Oblicz powierzchnię';

  @override
  String get area => 'Powierzchnia:';

  @override
  String resultArea(Object value) {
    return '$value m²';
  }

  @override
  String get surface => 'Powierzchnia';

  @override
  String get price => 'Cena za m² (PLN)';

  @override
  String get calculateWork => 'Oblicz koszt robót';

  @override
  String get workCost => 'Szacowany koszt:';

  @override
  String resultWork(Object value) {
    return '$value PLN';
  }

  @override
  String get usage => 'Zużycie na m²';

  @override
  String get calculateMaterial => 'Oblicz';

  @override
  String get materialAmount => 'Wymagana ilość materiału:';

  @override
  String resultMaterial(Object value) {
    return '$value';
  }

  @override
  String get historyEmpty => 'Brak historii obliczeń';

  @override
  String get useAgain => 'Użyj ponownie';

  @override
  String get delete => 'Usuń';

  @override
  String get appearance => 'Wygląd';

  @override
  String get themeSystem => 'Automatyczny (system)';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get language => 'Język';

  @override
  String get polish => 'Polski';

  @override
  String get english => 'Angielski';

  @override
  String get spanish => 'Hiszpański';

  @override
  String get german => 'Niemiecki';

  @override
  String get volumeMassCalculator => 'Kalkulator objętości i masy';

  @override
  String get calculateVolumeMass => 'Oblicz objętość i masę';

  @override
  String get volume => 'Objętość:';

  @override
  String get mass => 'Masa:';

  @override
  String get exportPDF => 'Export PDF';

  @override
  String get noData => 'No data';

  @override
  String get vatTaxCalculator => 'VAT & Tax Calculator';

  @override
  String get netAmount => 'Net amount (PLN)';

  @override
  String get vatRate => 'VAT rate';

  @override
  String get taxRate => 'Tax rate';

  @override
  String get taxOnGross => 'Tax on gross amount';

  @override
  String get calculate => 'Calculate';

  @override
  String get vatAmount => 'VAT amount';

  @override
  String get grossAmount => 'Gross amount';

  @override
  String get taxAmount => 'Tax amount';

  @override
  String get totalAfterTax => 'Total after tax';

  @override
  String get knowledgeBase => 'Knowledge Base';

  @override
  String get tipVatTitle => 'How VAT works in construction';

  @override
  String get tipVatContent => 'VAT rates in construction can vary. Always check the current rates for your service or product.';

  @override
  String get tipMaterialTitle => 'Choosing the right materials';

  @override
  String get tipMaterialContent => 'Compare durability, price, and supplier reputation before buying materials.';

  @override
  String get tipSafetyTitle => 'Work safety on site';

  @override
  String get tipSafetyContent => 'Always wear protective gear and follow safety regulations to prevent accidents.';

  @override
  String get categoryFinance => 'Finance';

  @override
  String get categoryMaterials => 'Materials';

  @override
  String get categorySafety => 'Safety';

  @override
  String get close => 'Close';

  @override
  String get calculators => 'Calculators';

  @override
  String get roomMeasurement => 'Pomiar pokoju';

  @override
  String get cameraPermission => 'Uprawnienia aparatu';

  @override
  String get cameraPermissionMessage => 'Aplikacja potrzebuje dostępu do aparatu, aby móc mierzyć pokoje.';

  @override
  String get cancel => 'Anuluj';

  @override
  String get settings => 'Ustawienia';

  @override
  String get measurementMode => 'Tryb pomiaru - dotknij ekranu';

  @override
  String get startMeasurement => 'Naciśnij aby rozpocząć pomiar';

  @override
  String get stop => 'Zatrzymaj';

  @override
  String get start => 'Rozpocznij';

  @override
  String get clear => 'Wyczyść';

  @override
  String get scaleCalibration => 'Kalibracja skali';

  @override
  String get scaleCalibrationMessage => 'Umieść obiekt o znanej długości (np. kartę kredytową) na ekranie i naciśnij \"Zmierzyć\".';

  @override
  String get realLength => 'Rzeczywista długość (cm)';

  @override
  String get measure => 'Zmierzyć';

  @override
  String get cm => 'cm';

  @override
  String get smartRenovationPlanner => 'Inteligentny Planer Remontu';

  @override
  String get subscriptionRequired => 'Wymagana subskrypcja';

  @override
  String get subscriptionRequiredMessage => 'Inteligentny Planer Remontu jest dostępny tylko dla użytkowników z aktywną subskrypcją Pro.';

  @override
  String get upgradeToPro => 'Przejdź na Pro';

  @override
  String get noPlansYet => 'Brak planów remontu';

  @override
  String get createFirstPlan => 'Stwórz swój pierwszy plan remontu z pomocą AI';

  @override
  String get createNewPlan => 'Nowy plan';

  @override
  String get planName => 'Nazwa planu';

  @override
  String get planDescription => 'Opis planu';

  @override
  String get budget => 'Budżet';

  @override
  String get pleaseEnterPlanName => 'Proszę wprowadzić nazwę planu';

  @override
  String get pleaseEnterBudget => 'Proszę wprowadzić budżet';

  @override
  String get pleaseEnterValidBudget => 'Proszę wprowadzić prawidłowy budżet';

  @override
  String get addRoom => 'Dodaj pokój';

  @override
  String get rooms => 'Pokoje';

  @override
  String get pleaseAddAtLeastOneRoom => 'Proszę dodać przynajmniej jeden pokój';

  @override
  String get create => 'Utwórz';

  @override
  String get roomName => 'Nazwa pokoju';

  @override
  String get roomArea => 'Powierzchnia pokoju';

  @override
  String get roomType => 'Typ pokoju';

  @override
  String get pleaseEnterRoomName => 'Proszę wprowadzić nazwę pokoju';

  @override
  String get pleaseEnterRoomArea => 'Proszę wprowadzić powierzchnię pokoju';

  @override
  String get pleaseEnterValidArea => 'Proszę wprowadzić prawidłową powierzchnię';

  @override
  String get add => 'Dodaj';

  @override
  String get view => 'Zobacz';

  @override
  String get edit => 'Edytuj';

  @override
  String get deletePlan => 'Usuń plan';

  @override
  String get deletePlanConfirmation => 'Czy na pewno chcesz usunąć ten plan?';

  @override
  String get planCreatedSuccessfully => 'Plan został utworzony pomyślnie';

  @override
  String get planDeletedSuccessfully => 'Plan został usunięty pomyślnie';

  @override
  String get planOverview => 'Przegląd planu';

  @override
  String get totalBudget => 'Całkowity budżet';

  @override
  String get estimatedCost => 'Szacowany koszt';

  @override
  String get proFeatures => 'Funkcje Pro';

  @override
  String get smartRenovationPlannerDescription => 'Twórz inteligentne plany remontu z pomocą AI';

  @override
  String get aiRecommendations => 'Rekomendacje AI';

  @override
  String get aiRecommendationsDescription => 'Otrzymuj inteligentne sugestie dotyczące materiałów i kosztów';

  @override
  String get priceComparison => 'Porównanie cen';

  @override
  String get priceComparisonDescription => 'Znajdź najlepsze ceny materiałów w różnych sklepach';

  @override
  String get detailedCostEstimate => 'Szczegółowy kosztorys';

  @override
  String get detailedCostEstimateDescription => 'Dokładne wyliczenia kosztów dla każdego elementu';

  @override
  String get cloudSync => 'Synchronizacja w chmurze';

  @override
  String get cloudSyncDescription => 'Twoje plany są bezpiecznie przechowywane w chmurze';

  @override
  String get prioritySupport => 'Priorytetowe wsparcie';

  @override
  String get prioritySupportDescription => 'Szybka pomoc techniczna dla użytkowników Pro';

  @override
  String get choosePlan => 'Wybierz plan';

  @override
  String get yearlyPlan => 'Plan roczny';

  @override
  String get monthlyPlan => 'Plan miesięczny';

  @override
  String get popular => 'Popularne';

  @override
  String get saveWithYearlyPlan => 'Oszczędź 20% z planem rocznym';

  @override
  String get subscribeNow => 'Subskrybuj teraz';

  @override
  String get subscriptionTerms => 'Warunki subskrypcji';

  @override
  String get subscriptionTermsDescription => 'Subskrypcja odnawia się automatycznie. Możesz anulować w dowolnym momencie w ustawieniach.';

  @override
  String get termsOfService => 'Regulamin';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get purchaseNotAvailable => 'Zakupy niedostępne';

  @override
  String get purchaseNotAvailableMessage => 'Zakupy w aplikacji nie są obecnie dostępne na tym urządzeniu.';

  @override
  String get unlockAllFeatures => 'Odblokuj wszystkie funkcje Pro';

  @override
  String get welcomeBack => 'Witaj z powrotem';

  @override
  String get loginToContinue => 'Zaloguj się, aby kontynuować';

  @override
  String get login => 'Zaloguj';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Wprowadź email';

  @override
  String get pleaseEnterEmail => 'Proszę wprowadzić email';

  @override
  String get pleaseEnterValidEmail => 'Proszę wprowadzić prawidłowy email';

  @override
  String get password => 'Hasło';

  @override
  String get enterPassword => 'Wprowadź hasło';

  @override
  String get pleaseEnterPassword => 'Proszę wprowadzić hasło';

  @override
  String get passwordTooShort => 'Hasło musi mieć co najmniej 6 znaków';

  @override
  String get forgotPassword => 'Zapomniałeś hasła?';

  @override
  String get dontHaveAccount => 'Nie masz konta?';

  @override
  String get register => 'Zarejestruj się';

  @override
  String get or => 'lub';

  @override
  String get continueAsGuest => 'Kontynuuj jako gość';

  @override
  String get createAccount => 'Utwórz konto';

  @override
  String get registerToGetStarted => 'Zarejestruj się, aby rozpocząć korzystanie z aplikacji';

  @override
  String get fullName => 'Imię i nazwisko';

  @override
  String get enterFullName => 'Wprowadź imię i nazwisko';

  @override
  String get pleaseEnterFullName => 'Proszę wprowadzić imię i nazwisko';

  @override
  String get nameTooShort => 'Imię musi mieć co najmniej 2 znaki';

  @override
  String get confirmPassword => 'Potwierdź hasło';

  @override
  String get enterConfirmPassword => 'Wprowadź hasło ponownie';

  @override
  String get pleaseEnterConfirmPassword => 'Proszę potwierdzić hasło';

  @override
  String get passwordsDoNotMatch => 'Hasła nie są identyczne';

  @override
  String get passwordMustContainLettersAndNumbers => 'Hasło musi zawierać litery i cyfry';

  @override
  String get iAgreeTo => 'Zgadzam się z ';

  @override
  String get and => 'i';

  @override
  String get alreadyHaveAccount => 'Masz już konto?';

  @override
  String get forgotPasswordDescription => 'Wprowadź swój adres email, a wyślemy Ci link do resetowania hasła';

  @override
  String get resetPassword => 'Resetuj hasło';

  @override
  String get sendResetLink => 'Wyślij link resetujący';

  @override
  String get emailSent => 'Email wysłany';

  @override
  String get emailSentDescription => 'Sprawdź swoją skrzynkę pocztową i kliknij link, aby zresetować hasło';

  @override
  String get sendAnotherEmail => 'Wyślij kolejny email';

  @override
  String get rememberPassword => 'Pamiętasz hasło?';

  @override
  String get backToLogin => 'Powrót do logowania';

  @override
  String get logout => 'Wyloguj';
}
