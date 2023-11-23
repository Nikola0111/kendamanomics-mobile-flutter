import 'package:flutter/cupertino.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/player_tama.dart';
import 'package:kendamanomics_mobile/models/tamas_group.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kendamanomics_mobile/services/tama_service.dart';
import 'package:kendamanomics_mobile/services/tamas_group_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum TamasProviderState { loading, none, success, errorFetchingProgress }

class TamasProvider extends ChangeNotifier with LoggerMixin {
  final _persistentDataService = KiwiContainer().resolve<PersistentDataService>();
  final _tamasService = KiwiContainer().resolve<TamaService>();
  final _tamaGroupService = KiwiContainer().resolve<TamasGroupService>();
  final _tamasGroups = <TamasGroup>[];
  final _progressData = <String, int>{};
  TamasProviderState _state = TamasProviderState.loading;
  int _currentPage = 0;
  bool _isDisposed = false;

  List<TamasGroup> get tamasGroup => _tamasGroups;
  int get currentPage => _currentPage;
  TamasProviderState get state => _state;

  set currentPage(int index) {
    _currentPage = index;
    // this will be tested when we have 2 or more groups, currently only working with one tama_group
    _fillCurrentPageTamas();
    notifyListeners();
  }

  TamasProvider() {
    _populateGroups();
    _updatePlayerTamasData();

    _fetchTamaGroups();
    _fetchTamas();
  }

  void _populateGroups() {
    _tamasGroups.clear();
    _tamasGroups.addAll(_persistentDataService.tamasGroup);
  }

  void _updatePlayerTamasData({int retry = 2}) async {
    logI('fetching tama progress data for player ${KiwiContainer().resolve<AuthService>().player?.id}');
    try {
      _progressData.clear();
      final ret = await _tamasService.getTamasProgress();
      _progressData.addAll(ret);

      _fillCurrentPageTamas();

      // in compute fill the tricks for other tamas?
      _state = TamasProviderState.success;
      logI('tama progress data successfully fetched and filled for page ${_tamasGroups[_currentPage].name}');
      _notify();
    } on PostgrestException catch (e) {
      logE('error updating tamas data: ${e.toString()}');
      if (retry > 0) {
        logI('retrying: attempts left: $retry');
        return _updatePlayerTamasData(retry: --retry);
      }

      _state = TamasProviderState.errorFetchingProgress;
      _notify();
    }
  }

  void _fillCurrentPageTamas() {
    for (int i = 0; i < _tamasGroups[_currentPage].playerTamas.length; i++) {
      final playerTama = _tamasGroups[_currentPage].playerTamas[i];
      final tamaID = playerTama.tama.id;
      if (_progressData.containsKey(tamaID)) {
        _tamasGroups[_currentPage].playerTamas[i] = playerTama.copyWith(
          completedTricks: _progressData[tamaID],
          badgeType: _progressData[tamaID] == playerTama.tama.numOfTricks ? BadgeType.completedTama : BadgeType.none,
        );
      } else {
        _tamasGroups[_currentPage].playerTamas[i] = playerTama.copyWith(completedTricks: 0);
      }
    }

    logI(
      'filled tamas for current pin: ${_tamasGroups[_currentPage].name}, number of tamas is ${_tamasGroups[_currentPage].playerTamas.length}',
    );
  }

  void _fetchTamas({int retry = 2}) async {
    try {
      final newTamas = await _tamasService.fetchTamas();
      if (newTamas == null) return;
      _persistentDataService.updateTamas(tamas: newTamas);
    } on PostgrestException catch (e) {
      logE('error fetching tamas: ${e.toString()}');
      if (retry > 0) {
        logI('retrying: attempts left: $retry');
        return _fetchTamas(retry: --retry);
      }
    }
  }

  // this should be called if we know there are differing tamas
  void _fetchTamaGroups({int retry = 2}) async {
    try {
      final newTamasGroups = await _tamaGroupService.fetchTamaGroups();
      if (newTamasGroups == null) return;
      _persistentDataService.updateTamasGroups(tamasGroups: newTamasGroups);
    } on PostgrestException catch (e) {
      logE('error fetching tamas groups: ${e.toString()}');
      if (retry > 0) {
        logI('retrying: attempts left: $retry');
        return _fetchTamaGroups(retry: --retry);
      }

      _state = TamasProviderState.errorFetchingProgress;
      _notify();
    }
  }

  void _notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  String get className => 'TamasProvider';
}
