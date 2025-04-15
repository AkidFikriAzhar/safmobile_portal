import 'package:flutter/foundation.dart';

class ServiceOrderProvider extends ChangeNotifier {
  int _currentStep = 0;
  int get currentStep => _currentStep;
  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }
}
