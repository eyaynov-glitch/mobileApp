import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  bool eventsAsGrid = true;

  void toggleEventLayout(bool asGrid) {
    eventsAsGrid = asGrid;
    notifyListeners();
  }
}
