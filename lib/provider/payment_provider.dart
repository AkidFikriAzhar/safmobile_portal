import 'package:flutter/foundation.dart';

class PaymentProvider extends ChangeNotifier {
  int currentPaymentMethod = 1;

  bool _isLoadingApi = false;

  bool get isLoadingApi => _isLoadingApi;

  void setCurrentPaymentMethod(int value) {
    currentPaymentMethod = value;
    notifyListeners();
  }

  void setLoadingApi(bool value) {
    _isLoadingApi = value;
    notifyListeners();
  }

  static Future<void> choosePaymentMethod() async {}
}
