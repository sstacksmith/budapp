// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Bau-Rechner';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get areaCalculator => 'Flächenrechner';

  @override
  String get workCalculator => 'Arbeitskostenrechner';

  @override
  String get materialCalculator => 'Materialrechner';

  @override
  String get history => 'Berechnungshistorie';

  @override
  String get length => 'Länge:';

  @override
  String get width => 'Breite (m)';

  @override
  String get height => 'Höhe (m)';

  @override
  String get density => 'Dichte (kg/m³)';

  @override
  String get calculateArea => 'Fläche berechnen';

  @override
  String get area => 'Fläche:';

  @override
  String resultArea(Object value) {
    return '$value m²';
  }

  @override
  String get surface => 'Oberfläche';

  @override
  String get price => 'Preis pro m² (PLN)';

  @override
  String get calculateWork => 'Arbeitskosten berechnen';

  @override
  String get workCost => 'Geschätzte Kosten:';

  @override
  String resultWork(Object value) {
    return '$value PLN';
  }

  @override
  String get usage => 'Verbrauch pro m²';

  @override
  String get calculateMaterial => 'Berechnen';

  @override
  String get materialAmount => 'Benötigte Materialmenge:';

  @override
  String resultMaterial(Object value) {
    return '$value';
  }

  @override
  String get historyEmpty => 'Keine Berechnungshistorie';

  @override
  String get useAgain => 'Erneut verwenden';

  @override
  String get delete => 'Löschen';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get themeSystem => 'Automatisch (System)';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get language => 'Sprache';

  @override
  String get polish => 'Polnisch';

  @override
  String get english => 'Englisch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get german => 'Deutsch';

  @override
  String get volumeMassCalculator => 'Volumen- und Massenrechner';

  @override
  String get calculateVolumeMass => 'Volumen und Masse berechnen';

  @override
  String get volume => 'Volumen:';

  @override
  String get mass => 'Masse:';

  @override
  String get exportPDF => 'Export PDF';

  @override
  String get noData => 'No data';

  @override
  String get vatTaxCalculator => 'Mehrwertsteuer- und Steuerrechner';

  @override
  String get netAmount => 'Nettobetrag (PLN)';

  @override
  String get vatRate => 'Mehrwertsteuersatz';

  @override
  String get taxRate => 'Steuersatz';

  @override
  String get taxOnGross => 'Steuer auf Bruttobetrag';

  @override
  String get calculate => 'Berechnen';

  @override
  String get vatAmount => 'Mehrwertsteuerbetrag';

  @override
  String get grossAmount => 'Bruttobetrag';

  @override
  String get taxAmount => 'Steuerbetrag';

  @override
  String get totalAfterTax => 'Gesamtbetrag nach Steuern';

  @override
  String get knowledgeBase => 'Wissensdatenbank';

  @override
  String get tipVatTitle => 'Wie funktioniert die Mehrwertsteuer im Bauwesen';

  @override
  String get tipVatContent => 'Mehrwertsteuersätze im Bauwesen können variieren. Überprüfen Sie immer die aktuellen Sätze für Ihre Dienstleistung oder Ihr Produkt.';

  @override
  String get tipMaterialTitle => 'Die richtigen Materialien wählen';

  @override
  String get tipMaterialContent => 'Vergleichen Sie Haltbarkeit, Preis und Lieferantenreputation, bevor Sie Materialien kaufen.';

  @override
  String get tipSafetyTitle => 'Arbeitssicherheit auf der Baustelle';

  @override
  String get tipSafetyContent => 'Tragen Sie immer Schutzausrüstung und befolgen Sie Sicherheitsvorschriften, um Unfälle zu vermeiden.';

  @override
  String get categoryFinance => 'Finanzen';

  @override
  String get categoryMaterials => 'Materialien';

  @override
  String get categorySafety => 'Sicherheit';

  @override
  String get close => 'Schließen';

  @override
  String get calculators => 'Rechner';

  @override
  String get roomMeasurement => 'Raummessung';

  @override
  String get cameraPermission => 'Kamera-Berechtigung';

  @override
  String get cameraPermissionMessage => 'Die App benötigt Kamera-Zugriff, um Räume zu messen.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get measurementMode => 'Messmodus - Bildschirm berühren';

  @override
  String get startMeasurement => 'Drücken Sie, um die Messung zu starten';

  @override
  String get stop => 'Stopp';

  @override
  String get start => 'Start';

  @override
  String get clear => 'Löschen';

  @override
  String get scaleCalibration => 'Skalierungskalibrierung';

  @override
  String get scaleCalibrationMessage => 'Platzieren Sie ein Objekt bekannter Länge (z.B. Kreditkarte) auf dem Bildschirm und drücken Sie \"Messen\".';

  @override
  String get realLength => 'Echte Länge (cm)';

  @override
  String get measure => 'Messen';

  @override
  String get cm => 'cm';

  @override
  String get smartRenovationPlanner => 'Smart Renovation Planner';

  @override
  String get subscriptionRequired => 'Subscription Required';

  @override
  String get subscriptionRequiredMessage => 'Smart Renovation Planner is available only for users with active Pro subscription.';

  @override
  String get upgradeToPro => 'Upgrade to Pro';

  @override
  String get noPlansYet => 'No renovation plans yet';

  @override
  String get createFirstPlan => 'Create your first renovation plan with AI assistance';

  @override
  String get createNewPlan => 'New plan';

  @override
  String get planName => 'Plan name';

  @override
  String get planDescription => 'Plan description';

  @override
  String get budget => 'Budget';

  @override
  String get pleaseEnterPlanName => 'Please enter plan name';

  @override
  String get pleaseEnterBudget => 'Please enter budget';

  @override
  String get pleaseEnterValidBudget => 'Please enter valid budget';

  @override
  String get addRoom => 'Add room';

  @override
  String get rooms => 'Rooms';

  @override
  String get pleaseAddAtLeastOneRoom => 'Please add at least one room';

  @override
  String get create => 'Create';

  @override
  String get roomName => 'Room name';

  @override
  String get roomArea => 'Room area';

  @override
  String get roomType => 'Room type';

  @override
  String get pleaseEnterRoomName => 'Please enter room name';

  @override
  String get pleaseEnterRoomArea => 'Please enter room area';

  @override
  String get pleaseEnterValidArea => 'Please enter valid area';

  @override
  String get add => 'Add';

  @override
  String get view => 'View';

  @override
  String get edit => 'Edit';

  @override
  String get deletePlan => 'Delete plan';

  @override
  String get deletePlanConfirmation => 'Are you sure you want to delete this plan?';

  @override
  String get planCreatedSuccessfully => 'Plan created successfully';

  @override
  String get planDeletedSuccessfully => 'Plan deleted successfully';

  @override
  String get planOverview => 'Plan overview';

  @override
  String get totalBudget => 'Total budget';

  @override
  String get estimatedCost => 'Estimated cost';

  @override
  String get proFeatures => 'Pro Features';

  @override
  String get smartRenovationPlannerDescription => 'Create smart renovation plans with AI assistance';

  @override
  String get aiRecommendations => 'AI Recommendations';

  @override
  String get aiRecommendationsDescription => 'Get intelligent suggestions for materials and costs';

  @override
  String get priceComparison => 'Price Comparison';

  @override
  String get priceComparisonDescription => 'Find the best material prices across different stores';

  @override
  String get detailedCostEstimate => 'Detailed Cost Estimate';

  @override
  String get detailedCostEstimateDescription => 'Precise cost calculations for every element';

  @override
  String get cloudSync => 'Cloud Sync';

  @override
  String get cloudSyncDescription => 'Your plans are safely stored in the cloud';

  @override
  String get prioritySupport => 'Priority Support';

  @override
  String get prioritySupportDescription => 'Fast technical support for Pro users';

  @override
  String get choosePlan => 'Choose Plan';

  @override
  String get yearlyPlan => 'Yearly Plan';

  @override
  String get monthlyPlan => 'Monthly Plan';

  @override
  String get popular => 'Popular';

  @override
  String get saveWithYearlyPlan => 'Save 20% with yearly plan';

  @override
  String get subscribeNow => 'Subscribe Now';

  @override
  String get subscriptionTerms => 'Subscription Terms';

  @override
  String get subscriptionTermsDescription => 'Subscription renews automatically. You can cancel anytime in settings.';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get purchaseNotAvailable => 'Purchase Not Available';

  @override
  String get purchaseNotAvailableMessage => 'In-app purchases are not currently available on this device.';

  @override
  String get unlockAllFeatures => 'Unlock All Pro Features';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get loginToContinue => 'Login to continue';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get pleaseEnterEmail => 'Please enter email';

  @override
  String get pleaseEnterValidEmail => 'Please enter valid email';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get pleaseEnterPassword => 'Please enter password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get register => 'Register';

  @override
  String get or => 'or';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get createAccount => 'Create Account';

  @override
  String get registerToGetStarted => 'Register to get started with the app';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterFullName => 'Enter full name';

  @override
  String get pleaseEnterFullName => 'Please enter full name';

  @override
  String get nameTooShort => 'Name must be at least 2 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get enterConfirmPassword => 'Enter password again';

  @override
  String get pleaseEnterConfirmPassword => 'Please confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordMustContainLettersAndNumbers => 'Password must contain letters and numbers';

  @override
  String get iAgreeTo => 'I agree to the ';

  @override
  String get and => 'and';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get forgotPasswordDescription => 'Enter your email address and we\'ll send you a link to reset your password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get emailSent => 'Email Sent';

  @override
  String get emailSentDescription => 'Check your email and click the link to reset your password';

  @override
  String get sendAnotherEmail => 'Send Another Email';

  @override
  String get rememberPassword => 'Remember your password?';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get logout => 'Logout';
}
