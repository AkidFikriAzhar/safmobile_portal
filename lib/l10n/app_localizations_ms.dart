// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get language => 'Bahasa Melayu';

  @override
  String get homeTitle => 'Lihat Invois, Resit atau Status Service Order Anda';

  @override
  String get search => 'Cari';

  @override
  String get changeLanguage => 'Tukar Bahasa';

  @override
  String get enterTicketID => 'Masukkan Tiket ID';

  @override
  String get scanQr => 'Imbas Kod QR';

  @override
  String get copyright =>
      '© 2025 Assaff Enterprise 202103058817 (003242985-U) | Hak Cipta Terpelihara';

  @override
  String get theme => 'Tema';

  @override
  String get more => 'Lagi';

  @override
  String get errorTicketId => 'Sila masukkan Tiket ID yang betul!';

  @override
  String get searchResult => 'Hasil Carian';

  @override
  String get noResult => 'Tiada rekod dijumpai';

  @override
  String get loading => 'Memuatkan data...';

  @override
  String get showingResult => 'Menunjukkan hasil carian untuk Tiket ID';

  @override
  String get receipt => 'Resit';

  @override
  String get invoice => 'Invois';

  @override
  String get paymentMade => 'Bayaran telah dibuat';

  @override
  String get paymentNotMade => 'Bayaran belum dibuat';

  @override
  String get close => 'Tutup';

  @override
  String billingItem(int length) {
    return '$length Item dalam Bil';
  }

  @override
  String get paid => 'Telah Dibayar';

  @override
  String get unpaid => 'Belum Dibayar';

  @override
  String get customerInfo => 'Maklumat Pelanggan';

  @override
  String get technicianInfo => 'Maklumat Juruteknik';

  @override
  String get issued => 'Dikeluarkan';

  @override
  String get due => 'Tarikh Tamat';

  @override
  String get warranty => 'Jaminan';

  @override
  String get price => 'Harga';

  @override
  String get total => 'Jumlah';

  @override
  String get discount => 'Diskaun';

  @override
  String get amount => 'Amaun';

  @override
  String get paymentMethod => 'Kaedah Pembayaran';

  @override
  String get payNow => 'Bayar Sekarang';

  @override
  String get downloadPdf => 'Muat Turun PDF';

  @override
  String get generalInformation => 'Maklumat Umum';

  @override
  String get repairStatus => 'Status Pembaikan';

  @override
  String get receivedDate => 'Tarikh Diterima';

  @override
  String get estimatedDate => 'Anggaran Siap';

  @override
  String get deviceModel => 'Model Peranti';

  @override
  String get deviceColour => 'Warna Peranti';

  @override
  String get deviceImei => 'IMEI Peranti';

  @override
  String get dropOffBranch => 'Cawangan Serahan';

  @override
  String get returnReason => 'Sebab Pemulangan';

  @override
  String get pending => 'Menunggu';

  @override
  String get pendingDescription =>
      'Peranti anda telah berjaya diterima dan sedang menunggu giliran untuk pemeriksaan teknikal.';

  @override
  String get diagnose => 'Diagnosis';

  @override
  String get diagnoseDescription =>
      'Juruteknik kami sedang menjalankan pemeriksaan terperinci untuk mengenalpasti punca masalah pada peranti anda.';

  @override
  String get repair => 'Pembaikan';

  @override
  String get repairDescription =>
      'Proses pembaikan sedang dijalankan berdasarkan hasil diagnosa. Komponen akan diganti jika perlu untuk memulihkan fungsi peranti anda.';

  @override
  String get checking => 'Pemeriksaan';

  @override
  String get checkingDescription =>
      'Peranti telah dibaiki dan kini menjalani pemeriksaan akhir kualiti untuk memastikan semua fungsi beroperasi dengan baik.';

  @override
  String get done => 'Selesai';

  @override
  String get doneDescription =>
      'Peranti anda telah berjaya dibaiki dan sedia untuk diambil.';

  @override
  String get returnDevice => 'Peranti tidak dapat diperbaiki';

  @override
  String get reason => 'Alasan';

  @override
  String get totalAmount => 'Jumlah Keseluruhan';

  @override
  String get securePayment => 'Pembayaran Terjamin';

  @override
  String get name => 'Nama';

  @override
  String get nameError => 'Sila masukkan nama anda';

  @override
  String get phoneNumber => 'Nombor Telefon';

  @override
  String get phoneNumberError => 'Sila masukkan nombor telefon anda';

  @override
  String get emailError => 'Sila massukkan alamat email anda';

  @override
  String get continueText => 'Teruskan';

  @override
  String get cancel => 'Batal';

  @override
  String get pleaseWaitCreatingBill =>
      'Sila tunggu sementara kami memproses bayaran anda...';

  @override
  String get confirmPayment => 'Pembayaran';

  @override
  String get confirmPaymentDescription =>
      'Anda akan dibawa ke halaman pembayaran Billplz. Dengan meneruskan, anda bersetuju dengan';

  @override
  String get termsAndConditions => 'Terma dan Syarat';

  @override
  String get agreeContinue => 'Saya setuju dan teruskan';

  @override
  String get paymentSuccess => 'Pembayaran Berjaya';

  @override
  String get paymentSuccessDialogDescription =>
      'Invois ini telah berjaya dibayar';

  @override
  String get paymentProcessing => 'Pembayaran Sedang Diproses';

  @override
  String get paymentProcessingDescription =>
      'Jika pembayaran anda berjaya, status akan dikemaskini secara automatik dalam sistem kami. Anda boleh kembali ke portal utama untuk menyemak status pembayaran.';

  @override
  String get reopenPaymentPage => 'Buka Semula Halaman Pembayaran';

  @override
  String get returnToMainPortal => 'Kembali ke Portal Utama';

  @override
  String get paymentCompleted => 'Pembayaran Selesai';

  @override
  String get paymentCompletedDescription =>
      'Kami telah menerima pembayaran anda dengan berjaya. Anda boleh kembali ke halaman portal utama untuk menyemak status pembayaran.';
}
