import 'package:flutter/cupertino.dart';
import 'package:kendamanomics_mobile/models/tamas_group.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kiwi/kiwi.dart';

class TamasProvider extends ChangeNotifier {
  final _persistentTamaService = KiwiContainer().resolve<PersistentDataService>();
  final _tamasGroups = <TamasGroup>[];
  int _currentPage = 0;

  List<TamasGroup> get tamasGroup => _tamasGroups;
  int get currentPage => _currentPage;

  set currentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  TamasProvider() {
    _populateGroups();
    _updatePlayerTamasData();
  }

  void _populateGroups() {
    _tamasGroups.clear();
    _tamasGroups.addAll(_persistentTamaService.tamasGroup);
  }

  void _updatePlayerTamasData() {
    // TODO: filter submissions which belong to player_id and are approved
  }
}
