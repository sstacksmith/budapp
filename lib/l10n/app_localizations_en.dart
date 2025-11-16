// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Construction Calculator';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get areaCalculator => 'Area Calculator';

  @override
  String get workCalculator => 'Work Calculator';

  @override
  String get materialCalculator => 'Material Calculator';

  @override
  String get history => 'Calculation History';

  @override
  String get length => 'Length:';

  @override
  String get width => 'Width (m)';

  @override
  String get height => 'Height (m)';

  @override
  String get density => 'Density (kg/m³)';

  @override
  String get calculateArea => 'Calculate Area';

  @override
  String get area => 'Area:';

  @override
  String resultArea(Object value) {
    return '$value m²';
  }

  @override
  String get surface => 'Surface';

  @override
  String get price => 'Price per m² (PLN)';

  @override
  String get calculateWork => 'Calculate Work Cost';

  @override
  String get workCost => 'Estimated Cost:';

  @override
  String resultWork(Object value) {
    return '$value PLN';
  }

  @override
  String get usage => 'Usage per m²';

  @override
  String get calculateMaterial => 'Calculate';

  @override
  String get materialAmount => 'Required Material Amount:';

  @override
  String resultMaterial(Object value) {
    return '$value';
  }

  @override
  String get historyEmpty => 'No calculation history';

  @override
  String get useAgain => 'Use again';

  @override
  String get delete => 'Delete';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'Automatic (system)';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get polish => 'Polish';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get german => 'German';

  @override
  String get volumeMassCalculator => 'Volume & Mass Calculator';

  @override
  String get calculateVolumeMass => 'Calculate Volume & Mass';

  @override
  String get volume => 'Volume:';

  @override
  String get mass => 'Mass:';

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
  String get roomMeasurement => 'Room Measurement';

  @override
  String get cameraPermission => 'Camera Permission';

  @override
  String get cameraPermissionMessage => 'The app needs camera access to measure rooms.';

  @override
  String get cancel => 'Cancel';

  @override
  String get settings => 'Settings';

  @override
  String get measurementMode => 'Measurement mode - touch screen';

  @override
  String get startMeasurement => 'Press to start measurement';

  @override
  String get stop => 'Stop';

  @override
  String get start => 'Start';

  @override
  String get clear => 'Clear';

  @override
  String get scaleCalibration => 'Scale Calibration';

  @override
  String get scaleCalibrationMessage => 'Place an object of known length (e.g., credit card) on screen and press \"Measure\".';

  @override
  String get realLength => 'Real length (cm)';

  @override
  String get measure => 'Measure';

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
