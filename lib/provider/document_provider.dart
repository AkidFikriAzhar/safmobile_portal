import 'package:flutter/foundation.dart';
import 'package:safmobile_portal/model/technician.dart';

class DocumentProvider extends ChangeNotifier {
  Technician? technicianLate;

  int _totalBilling = 0;

  int get totalBilling => _totalBilling;

  void incrementBilling(int billing) {
    _totalBilling = billing;
    notifyListeners();
  }
}
