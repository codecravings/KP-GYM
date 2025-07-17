import 'package:flutter/foundation.dart';

class ShiftProvider with ChangeNotifier {
  bool _isMorningShift = true;
  
  // Getter
  bool get isMorningShift => _isMorningShift;
  
  // Set shift
  void setShift(bool isMorning) {
    _isMorningShift = isMorning;
    notifyListeners();
  }
  
  // Toggle shift
  void toggleShift() {
    _isMorningShift = !_isMorningShift;
    notifyListeners();
  }
}