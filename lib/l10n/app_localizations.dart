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
