import 'package:flutter/cupertino.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/tamas_group.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kendamanomics_mobile/services/tama_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum TamasProviderState { loading, none, success, errorFetchingProgress }

class TamasProvider extends ChangeNotifier with LoggerMixin {
  final _persistentDataService = KiwiContainer().resolve<PersistentDataService>();
  final _tamasService = KiwiContainer().resolve<TamaService>();
  final _tamasGroups = <TamasGroup>[];
  final _progressData = <String, int>{};
  TamasProviderState _state = TamasProviderState.loading;
  int _currentPage = 0;

  List<TamasGroup> get tamasGroup => _tamasGroups;
  int get currentPage => _currentPage;
  TamasProviderState get state => _state;

  set currentPage(int index) {
    _currentPage = index;
    // this will be tested when we have 2 or more groups, currently only working with one tama_group
    _fillCurrentPageTamas();
  }

  TamasProvider() {
    _populateGroups();
    _updatePlayerTamasData();
  }

  void _populateGroups() {
    _tamasGroups.clear();
    _tamasGroups.addAll(_persistentDataService.tamasGroup);
  }

  void _updatePlayerTamasData({int retry = 2}) async {
    try {
      _progressData.clear();
      final ret = await _tamasService.getTamasProgress();
      _progressData.addAll(ret);

      _fillCurrentPageTamas();

      // in compute fill the tricks for other tamas?
      _state = TamasProviderState.success;
      notifyListeners();
    } on PostgrestException catch (e) {
      logE('error updating tamas data: ${e.toString()}');
      if (retry > 0) {
        logI('retrying: attempts left: $retry');
        return _updatePlayerTamasData(retry: --retry);
      }

      _state = TamasProviderState.errorFetchingProgress;
      notifyListeners();
    }
  }

  void _fillCurrentPageTamas() {
    for (int i = 0; i < _tamasGroups[_currentPage].playerTamas.length; i++) {
      final playerTama = _tamasGroups[_currentPage].playerTamas[i];
      final tamaID = playerTama.tama.id;
      if (_progressData.containsKey(tamaID)) {
        _tamasGroups[_currentPage].playerTamas[i] = playerTama.copyWith(completedTricks: _progressData[tamaID]);
      } else {
        _tamasGroups[_currentPage].playerTamas[i] = playerTama.copyWith(completedTricks: 0);
      }
    }
  }

  @override
  String get className => 'TamasProvider';
}