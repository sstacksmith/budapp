// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Calculadora de Construcción';

  @override
  String get dashboard => 'Panel principal';

  @override
  String get areaCalculator => 'Calculadora de área';

  @override
  String get workCalculator => 'Calculadora de trabajo';

  @override
  String get materialCalculator => 'Calculadora de materiales';

  @override
  String get history => 'Historial de cálculos';

  @override
  String get length => 'Longitud:';

  @override
  String get width => 'Ancho (m)';

  @override
  String get height => 'Altura (m)';

  @override
  String get density => 'Densidad (kg/m³)';

  @override
  String get calculateArea => 'Calcular área';

  @override
  String get area => 'Área:';

  @override
  String resultArea(Object value) {
    return '$value m²';
  }

  @override
  String get surface => 'Superficie';

  @override
  String get price => 'Precio por m² (PLN)';

  @override
  String get calculateWork => 'Calcular costo de trabajo';

  @override
  String get workCost => 'Costo estimado:';

  @override
  String resultWork(Object value) {
    return '$value PLN';
  }

  @override
  String get usage => 'Uso por m²';

  @override
  String get calculateMaterial => 'Calcular';

  @override
  String get materialAmount => 'Cantidad de material requerida:';

  @override
  String resultMaterial(Object value) {
    return '$value';
  }

  @override
  String get historyEmpty => 'Sin historial de cálculos';

  @override
  String get useAgain => 'Usar de nuevo';

  @override
  String get delete => 'Eliminar';

  @override
  String get appearance => 'Apariencia';

  @override
  String get themeSystem => 'Automático (sistema)';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get polish => 'Polaco';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get german => 'Alemán';

  @override
  String get volumeMassCalculator => 'Calculadora de volumen y masa';

  @override
  String get calculateVolumeMass => 'Calcular volumen y masa';

  @override
  String get volume => 'Volumen:';

  @override
  String get mass => 'Masa:';

  @override
  String get exportPDF => 'Export PDF';

  @override
  String get noData => 'No data';

  @override
  String get vatTaxCalculator => 'Calculadora de IVA e impuestos';

  @override
  String get netAmount => 'Importe neto (PLN)';

  @override
  String get vatRate => 'Tasa de IVA';

  @override
  String get taxRate => 'Tasa de impuesto';

  @override
  String get taxOnGross => 'Impuesto sobre importe bruto';

  @override
  String get calculate => 'Calcular';

  @override
  String get vatAmount => 'Importe de IVA';

  @override
  String get grossAmount => 'Importe bruto';

  @override
  String get taxAmount => 'Importe de impuesto';

  @override
  String get totalAfterTax => 'Total después de impuestos';

  @override
  String get knowledgeBase => 'Base de conocimientos';

  @override
  String get tipVatTitle => 'Cómo funciona el IVA en construcción';

  @override
  String get tipVatContent => 'Las tasas de IVA en construcción pueden variar. Siempre verifique las tasas actuales para su servicio o producto.';

  @override
  String get tipMaterialTitle => 'Elegir los materiales correctos';

  @override
  String get tipMaterialContent => 'Compare durabilidad, precio y reputación del proveedor antes de comprar materiales.';

  @override
  String get tipSafetyTitle => 'Seguridad laboral en obra';

  @override
  String get tipSafetyContent => 'Siempre use equipo de protección y siga las regulaciones de seguridad para prevenir accidentes.';

  @override
  String get categoryFinance => 'Finanzas';

  @override
  String get categoryMaterials => 'Materiales';

  @override
  String get categorySafety => 'Seguridad';

  @override
  String get close => 'Cerrar';

  @override
  String get calculators => 'Calculadoras';

  @override
  String get roomMeasurement => 'Medición de habitación';

  @override
  String get cameraPermission => 'Permiso de cámara';

  @override
  String get cameraPermissionMessage => 'La aplicación necesita acceso a la cámara para medir habitaciones.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get settings => 'Configuración';

  @override
  String get measurementMode => 'Modo de medición - tocar pantalla';

  @override
  String get startMeasurement => 'Presione para comenzar la medición';

  @override
  String get stop => 'Detener';

  @override
  String get start => 'Iniciar';

  @override
  String get clear => 'Limpiar';

  @override
  String get scaleCalibration => 'Calibración de escala';

  @override
  String get scaleCalibrationMessage => 'Coloque un objeto de longitud conocida (ej. tarjeta de crédito) en la pantalla y presione \"Medir\".';

  @override
  String get realLength => 'Longitud real (cm)';

  @override
  String get measure => 'Medir';

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
