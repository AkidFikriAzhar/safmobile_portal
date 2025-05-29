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

  @override
  String get about => 'Tentang Saf Mobile Portal';

  @override
  String get terms => 'Terma dan Syarat';

  @override
  String get privacy => 'Dasar Privasi';

  @override
  String get refund => 'Polisi Bayaran Balik & Pemulangan';

  @override
  String get contact => 'Hubungi Kami';

  @override
  String get aboutTitle => '🛠️ Mengenai Saf Mobile Portal';

  @override
  String get aboutDescription =>
      'Saf Mobile Portal ialah platform pelanggan yang dibangunkan khas oleh Akid Fikri Azhar — pengasas Saf Mobile dan TheKampungKod </>. Portal ini dibina untuk memudahkan semakan status pembaikan dan pembayaran, sejajar dengan komitmen kami terhadap ketelusan, kemudahan dan memanfaatkan penggunaan teknologi yang moden seiring arus masa kini.';

  @override
  String get goalTitle => '🎯 Matlamat Kami';

  @override
  String get goalIntro =>
      'Kami bangunkan Saf Mobile Portal ini dengan 3 maklamat utama:';

  @override
  String get goal1Bold => '✅ Ketelusan';

  @override
  String get goal1 => 'Semak status job sheet anda bila-bila masa.';

  @override
  String get goal2Bold => '✅ Kemudahan';

  @override
  String get goal2 =>
      'Bayar invois lebih awal secara dalam talian – supaya urusan pickup di kedai jadi lebih pantas dan mudah.';

  @override
  String get goal3Bold => '✅ Keselamatan';

  @override
  String get goal3 => 'Data anda dilindungi dan diproses dengan selamat.';

  @override
  String get featuresTitle => '📱 Kelebihan';

  @override
  String get feature1Title => '🔍 Semak Status Pembaikan';

  @override
  String get feature1Desc =>
      'Imbas kod QR pada resit anda untuk terus akses status job sheet.';

  @override
  String get feature2Title => '💸 Bayar Invois Tertunggak';

  @override
  String get feature2Desc =>
      'Lihat butiran invois dan buat pembayaran melalui FPX, e-wallet, kad kredit / debit atau Buy Now Pay Later.';

  @override
  String get feature3Title => '📜 Rekod Digital';

  @override
  String get feature3Desc =>
      'Simpan sejarah servis dan bayaran untuk rujukan masa depan.';

  @override
  String get whoShouldUseTitle => '🤝 Siapa Patut Guna Aplikasi Web Ini?';

  @override
  String get whoShouldUseDesc =>
      'Portal ini direka khas untuk pelanggan Saf Mobile yang ingin:\n• Semak status dengan mudah\n• Bayar baki bila-bila masa\n• Kekal kemas kini dengan servis';

  @override
  String get techTitle => '🧠 Teknologi Digunakan ';

  @override
  String get techDesc =>
      'Saf Mobile Portal dibina menggunakan Flutter, Firebase dan API Billplz — untuk pengalaman yang pantas, selamat dan lancar.';

  @override
  String get getStartedTitle => '📌 Mula Sekarang';

  @override
  String get getStartedDesc =>
      'Jika anda menerima resit dengan kod QR, imbas untuk akses portal.\nPerlukan bantuan? Hubungi kami melalui WhatsApp.';

  @override
  String get useSafMobileNow => 'Gunakan Saf Mobile Portal Sekarang';

  @override
  String get version => 'Versi';
}
