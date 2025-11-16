import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('pl')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Construction Calculator'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @areaCalculator.
  ///
  /// In en, this message translates to:
  /// **'Area Calculator'**
  String get areaCalculator;

  /// No description provided for @workCalculator.
  ///
  /// In en, this message translates to:
  /// **'Work Calculator'**
  String get workCalculator;

  /// No description provided for @materialCalculator.
  ///
  /// In en, this message translates to:
  /// **'Material Calculator'**
  String get materialCalculator;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'Calculation History'**
  String get history;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length:'**
  String get length;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width (m)'**
  String get width;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height (m)'**
  String get height;

  /// No description provided for @density.
  ///
  /// In en, this message translates to:
  /// **'Density (kg/m³)'**
  String get density;

  /// No description provided for @calculateArea.
  ///
  /// In en, this message translates to:
  /// **'Calculate Area'**
  String get calculateArea;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area:'**
  String get area;

  /// No description provided for @resultArea.
  ///
  /// In en, this message translates to:
  /// **'{value} m²'**
  String resultArea(Object value);

  /// No description provided for @surface.
  ///
  /// In en, this message translates to:
  /// **'Surface'**
  String get surface;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price per m² (PLN)'**
  String get price;

  /// No description provided for @calculateWork.
  ///
  /// In en, this message translates to:
  /// **'Calculate Work Cost'**
  String get calculateWork;

  /// No description provided for @workCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated Cost:'**
  String get workCost;

  /// No description provided for @resultWork.
  ///
  /// In en, this message translates to:
  /// **'{value} PLN'**
  String resultWork(Object value);

  /// No description provided for @usage.
  ///
  /// In en, this message translates to:
  /// **'Usage per m²'**
  String get usage;

  /// No description provided for @calculateMaterial.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculateMaterial;

  /// No description provided for @materialAmount.
  ///
  /// In en, this message translates to:
  /// **'Required Material Amount:'**
  String get materialAmount;

  /// No description provided for @resultMaterial.
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String resultMaterial(Object value);

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No calculation history'**
  String get historyEmpty;

  /// No description provided for @useAgain.
  ///
  /// In en, this message translates to:
  /// **'Use again'**
  String get useAgain;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Automatic (system)'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @polish.
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get polish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @volumeMassCalculator.
  ///
  /// In en, this message translates to:
  /// **'Volume & Mass Calculator'**
  String get volumeMassCalculator;

  /// No description provided for @calculateVolumeMass.
  ///
  /// In en, this message translates to:
  /// **'Calculate Volume & Mass'**
  String get calculateVolumeMass;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume:'**
  String get volume;

  /// No description provided for @mass.
  ///
  /// In en, this message translates to:
  /// **'Mass:'**
  String get mass;

  /// No description provided for @exportPDF.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPDF;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @vatTaxCalculator.
  ///
  /// In en, this message translates to:
  /// **'VAT & Tax Calculator'**
  String get vatTaxCalculator;

  /// No description provided for @netAmount.
  ///
  /// In en, this message translates to:
  /// **'Net amount (PLN)'**
  String get netAmount;

  /// No description provided for @vatRate.
  ///
  /// In en, this message translates to:
  /// **'VAT rate'**
  String get vatRate;

  /// No description provided for @taxRate.
  ///
  /// In en, this message translates to:
  /// **'Tax rate'**
  String get taxRate;

  /// No description provided for @taxOnGross.
  ///
  /// In en, this message translates to:
  /// **'Tax on gross amount'**
  String get taxOnGross;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @vatAmount.
  ///
  /// In en, this message translates to:
  /// **'VAT amount'**
  String get vatAmount;

  /// No description provided for @grossAmount.
  ///
  /// In en, this message translates to:
  /// **'Gross amount'**
  String get grossAmount;

  /// No description provided for @taxAmount.
  ///
  /// In en, this message translates to:
  /// **'Tax amount'**
  String get taxAmount;

  /// No description provided for @totalAfterTax.
  ///
  /// In en, this message translates to:
  /// **'Total after tax'**
  String get totalAfterTax;

  /// No description provided for @knowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base'**
  String get knowledgeBase;

  /// No description provided for @tipVatTitle.
  ///
  /// In en, this message translates to:
  /// **'How VAT works in construction'**
  String get tipVatTitle;

  /// No description provided for @tipVatContent.
  ///
  /// In en, this message translates to:
  /// **'VAT rates in construction can vary. Always check the current rates for your service or product.'**
  String get tipVatContent;

  /// No description provided for @tipMaterialTitle.
  ///
  /// In en, this message translates to:
  /// **'Choosing the right materials'**
  String get tipMaterialTitle;

  /// No description provided for @tipMaterialContent.
  ///
  /// In en, this message translates to:
  /// **'Compare durability, price, and supplier reputation before buying materials.'**
  String get tipMaterialContent;

  /// No description provided for @tipSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Work safety on site'**
  String get tipSafetyTitle;

  /// No description provided for @tipSafetyContent.
  ///
  /// In en, this message translates to:
  /// **'Always wear protective gear and follow safety regulations to prevent accidents.'**
  String get tipSafetyContent;

  /// No description provided for @categoryFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get categoryFinance;

  /// No description provided for @categoryMaterials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get categoryMaterials;

  /// No description provided for @categorySafety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get categorySafety;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @calculators.
  ///
  /// In en, this message translates to:
  /// **'Calculators'**
  String get calculators;

  /// No description provided for @roomMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Room Measurement'**
  String get roomMeasurement;

  /// No description provided for @cameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera Permission'**
  String get cameraPermission;

  /// No description provided for @cameraPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'The app needs camera access to measure rooms.'**
  String get cameraPermissionMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @measurementMode.
  ///
  /// In en, this message translates to:
  /// **'Measurement mode - touch screen'**
  String get measurementMode;

  /// No description provided for @startMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Press to start measurement'**
  String get startMeasurement;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @scaleCalibration.
  ///
  /// In en, this message translates to:
  /// **'Scale Calibration'**
  String get scaleCalibration;

  /// No description provided for @scaleCalibrationMessage.
  ///
  /// In en, this message translates to:
  /// **'Place an object of known length (e.g., credit card) on screen and press \"Measure\".'**
  String get scaleCalibrationMessage;

  /// No description provided for @realLength.
  ///
  /// In en, this message translates to:
  /// **'Real length (cm)'**
  String get realLength;

  /// No description provided for @measure.
  ///
  /// In en, this message translates to:
  /// **'Measure'**
  String get measure;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @smartRenovationPlanner.
  ///
  /// In en, this message translates to:
  /// **'Smart Renovation Planner'**
  String get smartRenovationPlanner;

  /// No description provided for @subscriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Subscription Required'**
  String get subscriptionRequired;

  /// No description provided for @subscriptionRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Smart Renovation Planner is available only for users with active Pro subscription.'**
  String get subscriptionRequiredMessage;

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradeToPro;

  /// No description provided for @noPlansYet.
  ///
  /// In en, this message translates to:
  /// **'No renovation plans yet'**
  String get noPlansYet;

  /// No description provided for @createFirstPlan.
  ///
  /// In en, this message translates to:
  /// **'Create your first renovation plan with AI assistance'**
  String get createFirstPlan;

  /// No description provided for @createNewPlan.
  ///
  /// In en, this message translates to:
  /// **'New plan'**
  String get createNewPlan;

  /// No description provided for @planName.
  ///
  /// In en, this message translates to:
  /// **'Plan name'**
  String get planName;

  /// No description provided for @planDescription.
  ///
  /// In en, this message translates to:
  /// **'Plan description'**
  String get planDescription;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @pleaseEnterPlanName.
  ///
  /// In en, this message translates to:
  /// **'Please enter plan name'**
  String get pleaseEnterPlanName;

  /// No description provided for @pleaseEnterBudget.
  ///
  /// In en, this message translates to:
  /// **'Please enter budget'**
  String get pleaseEnterBudget;

  /// No description provided for @pleaseEnterValidBudget.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid budget'**
  String get pleaseEnterValidBudget;

  /// No description provided for @addRoom.
  ///
  /// In en, this message translates to:
  /// **'Add room'**
  String get addRoom;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @pleaseAddAtLeastOneRoom.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one room'**
  String get pleaseAddAtLeastOneRoom;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @roomName.
  ///
  /// In en, this message translates to:
  /// **'Room name'**
  String get roomName;

  /// No description provided for @roomArea.
  ///
  /// In en, this message translates to:
  /// **'Room area'**
  String get roomArea;

  /// No description provided for @roomType.
  ///
  /// In en, this message translates to:
  /// **'Room type'**
  String get roomType;

  /// No description provided for @pleaseEnterRoomName.
  ///
  /// In en, this message translates to:
  /// **'Please enter room name'**
  String get pleaseEnterRoomName;

  /// No description provided for @pleaseEnterRoomArea.
  ///
  /// In en, this message translates to:
  /// **'Please enter room area'**
  String get pleaseEnterRoomArea;

  /// No description provided for @pleaseEnterValidArea.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid area'**
  String get pleaseEnterValidArea;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @deletePlan.
  ///
  /// In en, this message translates to:
  /// **'Delete plan'**
  String get deletePlan;

  /// No description provided for @deletePlanConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this plan?'**
  String get deletePlanConfirmation;

  /// No description provided for @planCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Plan created successfully'**
  String get planCreatedSuccessfully;

  /// No description provided for @planDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Plan deleted successfully'**
  String get planDeletedSuccessfully;

  /// No description provided for @planOverview.
  ///
  /// In en, this message translates to:
  /// **'Plan overview'**
  String get planOverview;

  /// No description provided for @totalBudget.
  ///
  /// In en, this message translates to:
  /// **'Total budget'**
  String get totalBudget;

  /// No description provided for @estimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated cost'**
  String get estimatedCost;

  /// No description provided for @proFeatures.
  ///
  /// In en, this message translates to:
  /// **'Pro Features'**
  String get proFeatures;

  /// No description provided for @smartRenovationPlannerDescription.
  ///
  /// In en, this message translates to:
  /// **'Create smart renovation plans with AI assistance'**
  String get smartRenovationPlannerDescription;

  /// No description provided for @aiRecommendations.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendations'**
  String get aiRecommendations;

  /// No description provided for @aiRecommendationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get intelligent suggestions for materials and costs'**
  String get aiRecommendationsDescription;

  /// No description provided for @priceComparison.
  ///
  /// In en, this message translates to:
  /// **'Price Comparison'**
  String get priceComparison;

  /// No description provided for @priceComparisonDescription.
  ///
  /// In en, this message translates to:
  /// **'Find the best material prices across different stores'**
  String get priceComparisonDescription;

  /// No description provided for @detailedCostEstimate.
  ///
  /// In en, this message translates to:
  /// **'Detailed Cost Estimate'**
  String get detailedCostEstimate;

  /// No description provided for @detailedCostEstimateDescription.
  ///
  /// In en, this message translates to:
  /// **'Precise cost calculations for every element'**
  String get detailedCostEstimateDescription;

  /// No description provided for @cloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get cloudSync;

  /// No description provided for @cloudSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Your plans are safely stored in the cloud'**
  String get cloudSyncDescription;

  /// No description provided for @prioritySupport.
  ///
  /// In en, this message translates to:
  /// **'Priority Support'**
  String get prioritySupport;

  /// No description provided for @prioritySupportDescription.
  ///
  /// In en, this message translates to:
  /// **'Fast technical support for Pro users'**
  String get prioritySupportDescription;

  /// No description provided for @choosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose Plan'**
  String get choosePlan;

  /// No description provided for @yearlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Yearly Plan'**
  String get yearlyPlan;

  /// No description provided for @monthlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Monthly Plan'**
  String get monthlyPlan;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @saveWithYearlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Save 20% with yearly plan'**
  String get saveWithYearlyPlan;

  /// No description provided for @subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNow;

  /// No description provided for @subscriptionTerms.
  ///
  /// In en, this message translates to:
  /// **'Subscription Terms'**
  String get subscriptionTerms;

  /// No description provided for @subscriptionTermsDescription.
  ///
  /// In en, this message translates to:
  /// **'Subscription renews automatically. You can cancel anytime in settings.'**
  String get subscriptionTermsDescription;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @purchaseNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Purchase Not Available'**
  String get purchaseNotAvailable;

  /// No description provided for @purchaseNotAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'In-app purchases are not currently available on this device.'**
  String get purchaseNotAvailableMessage;

  /// No description provided for @unlockAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'Unlock All Pro Features'**
  String get unlockAllFeatures;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginToContinue;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @registerToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Register to get started with the app'**
  String get registerToGetStarted;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter full name'**
  String get pleaseEnterFullName;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password again'**
  String get enterConfirmPassword;

  /// No description provided for @pleaseEnterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm password'**
  String get pleaseEnterConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordMustContainLettersAndNumbers.
  ///
  /// In en, this message translates to:
  /// **'Password must contain letters and numbers'**
  String get passwordMustContainLettersAndNumbers;

  /// No description provided for @iAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeTo;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password'**
  String get forgotPasswordDescription;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email Sent'**
  String get emailSent;

  /// No description provided for @emailSentDescription.
  ///
  /// In en, this message translates to:
  /// **'Check your email and click the link to reset your password'**
  String get emailSentDescription;

  /// No description provided for @sendAnotherEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Another Email'**
  String get sendAnotherEmail;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get rememberPassword;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'pl': return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
