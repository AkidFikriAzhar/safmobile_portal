import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';

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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ms')
  ];

  /// Selected language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// Home screen title
  ///
  /// In en, this message translates to:
  /// **'Check Your Invoice, Receipt or Service Order Status'**
  String get homeTitle;

  /// Search button text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Change language text
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Enter ticket ID text
  ///
  /// In en, this message translates to:
  /// **'Enter Ticket ID'**
  String get enterTicketID;

  /// Scan QR Code text
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQr;

  /// Copyright text
  ///
  /// In en, this message translates to:
  /// **'© 2025 Assaff Enterprise 202103058817 (003242985-U) |  All Rights Reserved'**
  String get copyright;

  /// Theme text
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// More text
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// Error message for ticket ID
  ///
  /// In en, this message translates to:
  /// **'Please enter correct ticket ID!'**
  String get errorTicketId;

  /// Search result text
  ///
  /// In en, this message translates to:
  /// **'Search Result'**
  String get searchResult;

  /// No result text
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get noResult;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loading;

  /// Showing results text
  ///
  /// In en, this message translates to:
  /// **'Showing results for Ticket ID'**
  String get showingResult;

  /// Receipt text
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// Invoice text
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// Payment made text
  ///
  /// In en, this message translates to:
  /// **'Payment has been made'**
  String get paymentMade;

  /// Payment not made text
  ///
  /// In en, this message translates to:
  /// **'Payment has not been made'**
  String get paymentNotMade;

  /// Close text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Billing item text
  ///
  /// In en, this message translates to:
  /// **'Billing {length} Item(s)'**
  String billingItem(int length);

  /// Paid text
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// Unpaid text
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// Customer information text
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customerInfo;

  /// Technician information text
  ///
  /// In en, this message translates to:
  /// **'Technician Information'**
  String get technicianInfo;

  /// Issued text
  ///
  /// In en, this message translates to:
  /// **'Issued'**
  String get issued;

  /// Due text
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// Warranty text
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get warranty;

  /// Price text
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Total text
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Discount text
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// Amount text
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Payment method text
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Pay now text
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// Download PDF text
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// General information text
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get generalInformation;

  /// Repair status text
  ///
  /// In en, this message translates to:
  /// **'Repair Status'**
  String get repairStatus;

  /// Received date text
  ///
  /// In en, this message translates to:
  /// **'Received Date'**
  String get receivedDate;

  /// Estimated date text
  ///
  /// In en, this message translates to:
  /// **'Estimated Done'**
  String get estimatedDate;

  /// Teks model peranti
  ///
  /// In en, this message translates to:
  /// **'Device Model'**
  String get deviceModel;

  /// Device colour text
  ///
  /// In en, this message translates to:
  /// **'Device Colour'**
  String get deviceColour;

  /// Device IMEI text
  ///
  /// In en, this message translates to:
  /// **'Device IMEI'**
  String get deviceImei;

  /// Drop off branch text
  ///
  /// In en, this message translates to:
  /// **'Drop Off Branch'**
  String get dropOffBranch;

  /// Return reason text
  ///
  /// In en, this message translates to:
  /// **'Return Reason'**
  String get returnReason;

  /// Pending text
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Pending description text
  ///
  /// In en, this message translates to:
  /// **'Your device has been successfully received and is currently in queue for technical inspection.'**
  String get pendingDescription;

  /// Diagnose text
  ///
  /// In en, this message translates to:
  /// **'Diagnose'**
  String get diagnose;

  /// Diagnose description text
  ///
  /// In en, this message translates to:
  /// **'Our technician is performning a detailed inspection to identify the root cause of the  issue with your device.'**
  String get diagnoseDescription;

  /// Repair text
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get repair;

  /// Repair description text
  ///
  /// In en, this message translates to:
  /// **'The repair process is underway based on the diagnosis. Components will be replaced if necessary to restore your device\'s functionality.'**
  String get repairDescription;

  /// Checking text
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get checking;

  /// Checking description text
  ///
  /// In en, this message translates to:
  /// **'The device has been repaired and is now undergoing a final qualiy check to ensure all functions are working properly.'**
  String get checkingDescription;

  /// Done text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Done description text
  ///
  /// In en, this message translates to:
  /// **'Your device has been successfully repaired and is ready for pickup.'**
  String get doneDescription;

  /// Device cannot be repaired text
  ///
  /// In en, this message translates to:
  /// **'Device cannot be repaired'**
  String get returnDevice;

  /// Reason text
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// Total amount text
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// Secure payment text
  ///
  /// In en, this message translates to:
  /// **'Secure payment from'**
  String get securePayment;

  /// Name text
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Name error text
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameError;

  /// Phone number text
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Phone number error text
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneNumberError;

  /// Email error text
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailError;

  /// Continue text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// Cancel text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Loading creating payment text
  ///
  /// In en, this message translates to:
  /// **'Please wait while we processing your payment...'**
  String get pleaseWaitCreatingBill;

  /// Confirm payment text
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmPayment;

  /// Confirm payment description text
  ///
  /// In en, this message translates to:
  /// **'You will redirect to the payment page. By proceeding, you agree to our'**
  String get confirmPaymentDescription;

  /// Terms and conditions text
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// Agree and continue text
  ///
  /// In en, this message translates to:
  /// **'I agree and continue'**
  String get agreeContinue;

  /// Payment success text
  ///
  /// In en, this message translates to:
  /// **'Payment Success'**
  String get paymentSuccess;

  /// Payment success dialog description text
  ///
  /// In en, this message translates to:
  /// **'This invoice has been paid successfully.'**
  String get paymentSuccessDialogDescription;

  /// Payment processing text
  ///
  /// In en, this message translates to:
  /// **'Your Payment Has Been Processed'**
  String get paymentProcessing;

  /// Payment processing description text
  ///
  /// In en, this message translates to:
  /// **'If your payment is successful, it will be automatically reflected in our system. You can return to main portal to check your payment status'**
  String get paymentProcessingDescription;

  /// Reopen payment page text
  ///
  /// In en, this message translates to:
  /// **'Reopen Payment Page'**
  String get reopenPaymentPage;

  /// Return to main portal text
  ///
  /// In en, this message translates to:
  /// **'Return to Main Portal'**
  String get returnToMainPortal;

  /// Payment completed text
  ///
  /// In en, this message translates to:
  /// **'Payment Completed'**
  String get paymentCompleted;

  /// Payment completed description text
  ///
  /// In en, this message translates to:
  /// **'We have successfully received your payment. You may have safely return to our portal to check your payment status.'**
  String get paymentCompletedDescription;

  /// About text
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Terms of services text
  ///
  /// In en, this message translates to:
  /// **'Terms of Services'**
  String get terms;

  /// Privacy policy text
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy;

  /// Return and refund policy text
  ///
  /// In en, this message translates to:
  /// **'Return & Refund Policy'**
  String get refund;

  /// Contact us text
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact;

  /// Main title for about page
  ///
  /// In en, this message translates to:
  /// **'🛠️ About Saf Mobile Portal'**
  String get aboutTitle;

  /// Brief intro about Saf Mobile Portal
  ///
  /// In en, this message translates to:
  /// **'Saf Mobile Portal is a dedicated customer platform proudly developed by Akid Fikri Azhar — founder of Saf Mobile and TheKampungKod </>. Designed to simplify repair tracking and payments, this portal reflects our commitment to transparency, convenience, and leveraging modern technology in line with current digital trends.'**
  String get aboutDescription;

  /// Title for goals section
  ///
  /// In en, this message translates to:
  /// **'🎯 Our Goals'**
  String get goalTitle;

  /// Pengenalan untuk bahagian matlamat
  ///
  /// In en, this message translates to:
  /// **'We develop this Saf Mobile Portal with 3 main goals in mind:'**
  String get goalIntro;

  /// Bold text for goal 1
  ///
  /// In en, this message translates to:
  /// **'✅ Transparency'**
  String get goal1Bold;

  /// First goal - transparency
  ///
  /// In en, this message translates to:
  /// **'Check your job sheet status anytime.'**
  String get goal1;

  /// Bold text for goal 2
  ///
  /// In en, this message translates to:
  /// **'✅ Convenience'**
  String get goal2Bold;

  /// Second goal - convenience
  ///
  /// In en, this message translates to:
  /// **'Settle your invoice online in advance — so your pickup process at the shop will be smoother and faster.'**
  String get goal2;

  /// Bold text for goal 3
  ///
  /// In en, this message translates to:
  /// **'✅ Security'**
  String get goal3Bold;

  /// Third goal - security
  ///
  /// In en, this message translates to:
  /// **'Your data is protected and processed securely.'**
  String get goal3;

  /// Title for features section
  ///
  /// In en, this message translates to:
  /// **'📱 Features'**
  String get featuresTitle;

  /// Title for feature 1
  ///
  /// In en, this message translates to:
  /// **'🔍 Check Repair Status'**
  String get feature1Title;

  /// Description for checking repair status
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code on your receipt to access your job sheet status instantly.'**
  String get feature1Desc;

  /// Title for feature 2
  ///
  /// In en, this message translates to:
  /// **'💸 Pay Pending Invoices'**
  String get feature2Title;

  /// Description for paying invoices
  ///
  /// In en, this message translates to:
  /// **'View invoice details and pay via FPX, e-wallet, debit / credit card or Buy Now Pay Later.'**
  String get feature2Desc;

  /// Title for feature 3
  ///
  /// In en, this message translates to:
  /// **'📜 Digital Records'**
  String get feature3Title;

  /// Description for digital records
  ///
  /// In en, this message translates to:
  /// **'Keep service and payment history for future reference.'**
  String get feature3Desc;

  /// Title for who should use the portal
  ///
  /// In en, this message translates to:
  /// **'🤝 Who Should Use This?'**
  String get whoShouldUseTitle;

  /// Description of target users of the portal
  ///
  /// In en, this message translates to:
  /// **'This portal is designed for Saf Mobile customers who want to:\n• Check repair status easily\n• Pay outstanding balance anytime\n• Stay updated with service progress'**
  String get whoShouldUseDesc;

  /// Title for technology section
  ///
  /// In en, this message translates to:
  /// **'🧠 Technology Behind the Portal'**
  String get techTitle;

  /// Description about technologies used
  ///
  /// In en, this message translates to:
  /// **'Saf Mobile Portal is built with Flutter and Firebase — delivering a fast, secure, and smooth experience.'**
  String get techDesc;

  /// Title for get started section
  ///
  /// In en, this message translates to:
  /// **'📌 Get Started'**
  String get getStartedTitle;

  /// Instruction to start using the portal
  ///
  /// In en, this message translates to:
  /// **'If you received a receipt with a QR code, scan it to access your portal.\nNeed help? Contact us via WhatsApp.'**
  String get getStartedDesc;

  /// Button text to use Saf Mobile Portal
  ///
  /// In en, this message translates to:
  /// **'Use Saf Mobile Portal Now'**
  String get useSafMobileNow;

  /// Version text
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Teks untuk pertanyaan apa itu Ticket ID
  ///
  /// In en, this message translates to:
  /// **'What is Ticket ID ?'**
  String get whatIsTicketId;

  /// Teks untuk penerangan apa itu Ticket ID
  ///
  /// In en, this message translates to:
  /// **'The Ticket ID is a unique service reference number for your device. It is located next to the QR code on documents such as the Service Order or Invoice. You can also scan the QR code on the document for quicker access.'**
  String get whatIsTicketIdDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ms'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ms':
      return AppLocalizationsMs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
