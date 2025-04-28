import 'package:flutter/foundation.dart';

class PaymentProvider extends ChangeNotifier {
  bool _isLoadingApi = false;
  bool _isAgree = false;

  bool get isAgree => _isAgree;
  bool get isLoadingApi => _isLoadingApi;

  void setAgree(bool value) {
    _isAgree = value;
    notifyListeners();
  }

  void setLoadingApi(bool value) {
    _isLoadingApi = value;
    notifyListeners();
  }

  static Future<void> choosePaymentMethod() async {}
}
