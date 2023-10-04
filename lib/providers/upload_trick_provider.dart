import 'package:flutter/cupertino.dart';
import 'package:kendamanomics_mobile/models/trick.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kiwi/kiwi.dart';

class UploadTrickProvider extends ChangeNotifier {
  final _persistentDataService = KiwiContainer().resolve<PersistentDataService>();
  final String? trickID;
  Trick? _trick;
  int _pageIndex = 0;

  int get pageIndex => _pageIndex;
  Trick? get trick => _trick;

  set pageIndex(int value) {
    _pageIndex = value;
    notifyListeners();
  }

  UploadTrickProvider({required this.trickID, required VoidCallback calculateViewportHeight}) {
    calculateViewportHeight();
    _getTrick();
  }

  void _getTrick() {
    _trick = _persistentDataService.getTrickByID(trickID);
  }
}
