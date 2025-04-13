import 'package:flutter/foundation.dart';

class DocumentProvider extends ChangeNotifier {
  int _totalBilling = 0;

  int get totalBilling => _totalBilling;

  void incrementBilling(int billing) {
    _totalBilling = billing;
    notifyListeners();
  }
}
