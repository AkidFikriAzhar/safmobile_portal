// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get homeTitle => 'Check Your Invoice, Receipt or Service Order Status';

  @override
  String get search => 'Search';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get enterTicketID => 'Enter Ticket ID';

  @override
  String get scanQr => 'Scan QR Code';

  @override
  String get copyright =>
      '© 2025 Assaff Enterprise 202103058817 (003242985-U) |  All Rights Reserved';

  @override
  String get theme => 'Theme';

  @override
  String get more => 'More';

  @override
  String get errorTicketId => 'Please enter correct ticket ID!';

  @override
  String get searchResult => 'Search Result';

  @override
  String get noResult => 'No records found';

  @override
  String get loading => 'Loading data...';

  @override
  String get showingResult => 'Showing results for Ticket ID';

  @override
  String get receipt => 'Receipt & Warranty';

  @override
  String get invoice => 'Invoice';

  @override
  String get paymentMade => 'Payment has been made';

  @override
  String get paymentNotMade => 'Payment has not been made';

  @override
  String get close => 'Close';

  @override
  String billingItem(int length) {
    return 'Billing $length Item(s)';
  }

  @override
  String get paid => 'Paid';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get customerInfo => 'Customer Information';

  @override
  String get technicianInfo => 'Technician Information';

  @override
  String get issued => 'Issued';

  @override
  String get due => 'Due';

  @override
  String get warranty => 'Warranty';

  @override
  String get price => 'Price';

  @override
  String get total => 'Total';

  @override
  String get discount => 'Discount';

  @override
  String get amount => 'Amount';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get payNow => 'Pay Now';

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get generalInformation => 'General Information';

  @override
  String get repairStatus => 'Repair Status';

  @override
  String get receivedDate => 'Received Date';

  @override
  String get estimatedDate => 'Estimated Done';

  @override
  String get deviceModel => 'Device Model';

  @override
  String get deviceColour => 'Device Colour';

  @override
  String get deviceImei => 'Device IMEI';

  @override
  String get dropOffBranch => 'Drop Off Branch';

  @override
  String get returnReason => 'Return Reason';

  @override
  String get pending => 'Pending';

  @override
  String get pendingDescription =>
      'Your device has been successfully received and is currently in queue for technical inspection.';

  @override
  String get diagnose => 'Diagnose';

  @override
  String get diagnoseDescription =>
      'Our technician is performning a detailed inspection to identify the root cause of the  issue with your device.';

  @override
  String get repair => 'Repair';

  @override
  String get repairDescription =>
      'The repair process is underway based on the diagnosis. Components will be replaced if necessary to restore your device\'s functionality.';

  @override
  String get checking => 'Checking';

  @override
  String get checkingDescription =>
      'The device has been repaired and is now undergoing a final qualiy check to ensure all functions are working properly.';

  @override
  String get done => 'Done';

  @override
  String get doneDescription =>
      'Your device has been successfully repaired and is ready for pickup.';

  @override
  String get returnDevice => 'Device cannot be repaired';

  @override
  String get reason => 'Reason';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get securePayment => 'Secure payment from';

  @override
  String get name => 'Name';

  @override
  String get nameError => 'Please enter your name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberError => 'Please enter your phone number';

  @override
  String get emailError => 'Please enter your email';

  @override
  String get continueText => 'Continue';

  @override
  String get cancel => 'Cancel';

  @override
  String get pleaseWaitCreatingBill =>
      'Please wait while we processing your payment...';

  @override
  String get confirmPayment => 'Confirm Payment';

  @override
  String get confirmPaymentDescription =>
      'You will redirect to the payment page. By proceeding, you agree to our';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get agreeContinue => 'I agree and continue';

  @override
  String get paymentSuccess => 'Payment Success';

  @override
  String get paymentSuccessDialogDescription =>
      'This invoice has been paid successfully.';

  @override
  String get paymentProcessing => 'Your Payment Has Been Processed';

  @override
  String get paymentProcessingDescription =>
      'If your payment is successful, it will be automatically reflected in our system. You can return to main portal to check your payment status';

  @override
  String get reopenPaymentPage => 'Reopen Payment Page';

  @override
  String get returnToMainPortal => 'Return to Main Portal';

  @override
  String get paymentCompleted => 'Payment Completed';

  @override
  String get paymentCompletedDescription =>
      'We have successfully received your payment. You may have safely return to our portal to check your payment status.';

  @override
  String get about => 'About';

  @override
  String get terms => 'Terms of Services';

  @override
  String get privacy => 'Privacy Policy';

  @override
  String get refund => 'Return & Refund Policy';

  @override
  String get contact => 'Contact Us';

  @override
  String get aboutTitle => '🛠️ About Saf Mobile Portal';

  @override
  String get aboutDescription =>
      'Saf Mobile Portal is a dedicated customer platform proudly developed by Akid Fikri Azhar — founder of Saf Mobile and TheKampungKod </>. Designed to simplify repair tracking and payments, this portal reflects our commitment to transparency, convenience, and leveraging modern technology in line with current digital trends.';

  @override
  String get goalTitle => '🎯 Our Goals';

  @override
  String get goalIntro =>
      'We develop this Saf Mobile Portal with 3 main goals in mind:';

  @override
  String get goal1Bold => '✅ Transparency';

  @override
  String get goal1 => 'Check your job sheet status anytime.';

  @override
  String get goal2Bold => '✅ Convenience';

  @override
  String get goal2 =>
      'Settle your invoice online in advance — so your pickup process at the shop will be smoother and faster.';

  @override
  String get goal3Bold => '✅ Security';

  @override
  String get goal3 => 'Your data is protected and processed securely.';

  @override
  String get featuresTitle => '📱 Features';

  @override
  String get feature1Title => '🔍 Check Repair Status';

  @override
  String get feature1Desc =>
      'Scan the QR code on your receipt to access your job sheet status instantly.';

  @override
  String get feature2Title => '💸 Pay Pending Invoices';

  @override
  String get feature2Desc =>
      'View invoice details and pay via FPX, e-wallet, debit / credit card or Buy Now Pay Later.';

  @override
  String get feature3Title => '📜 Digital Records';

  @override
  String get feature3Desc =>
      'Keep service and payment history for future reference.';

  @override
  String get whoShouldUseTitle => '🤝 Who Should Use This?';

  @override
  String get whoShouldUseDesc =>
      'This portal is designed for Saf Mobile customers who want to:\n• Check repair status easily\n• Pay outstanding balance anytime\n• Stay updated with service progress';

  @override
  String get techTitle => '🧠 Technology Behind the Portal';

  @override
  String get techDesc =>
      'Saf Mobile Portal is built with Flutter and Firebase — delivering a fast, secure, and smooth experience.';

  @override
  String get getStartedTitle => '📌 Get Started';

  @override
  String get getStartedDesc =>
      'If you received a receipt with a QR code, scan it to access your portal.\nNeed help? Contact us via WhatsApp.';

  @override
  String get useSafMobileNow => 'Use Saf Mobile Portal Now';

  @override
  String get version => 'Version';

  @override
  String get whatIsTicketId => 'What is Ticket ID ?';

  @override
  String get whatIsTicketIdDesc =>
      'The Ticket ID is a unique service reference number for your device. It is located next to the QR code on documents such as the Service Order or Invoice. You can also scan the QR code on the document for quicker access.';

  @override
  String get invoiceDate => 'Invoice Date';

  @override
  String get warrantyDetails => 'Warranty Details';

  @override
  String get warrantyExpired => 'Warranty expired';

  @override
  String get daysAgo => 'days ago';

  @override
  String get daysRemaining => 'days remaining';

  @override
  String get days => 'days';
}
