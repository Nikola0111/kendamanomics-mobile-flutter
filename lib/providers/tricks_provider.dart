import 'package:flutter/foundation.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/tama_trick_progress.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kendamanomics_mobile/services/trick_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum TrickState { loading, done, error }

class TricksProvider extends ChangeNotifier with LoggerMixin {
  final _persistentDataService = KiwiContainer().resolve<PersistentDataService>();
  final _trickService = KiwiContainer().resolve<TrickService>();
  final _tamaTricksRelation = <Map<String, dynamic>>[];
  final String? tamaId;
  TrickState _state = TrickState.loading;
  List<TamaTrickProgress> _tricks = <TamaTrickProgress>[];
  String? _tamaName;
  String? _tamaGroupName;

  TrickState get state => _state;
  List<Map<String, dynamic>> get tamaTricksRelation => _tamaTricksRelation;
  List<TamaTrickProgress> get tricks => _tricks;
  String? get tamaName => _tamaName;
  String? get tamaGroupName => _tamaGroupName;

  TricksProvider({required this.tamaId}) {
    _populateTricks(tamaId);
    _fetchTamaNameById(tamaId);
    _fetchTamaGroupNameById(tamaId);
    _fetchTricksForTama();
  }

  void _populateTricks(String? tamaId) {
    _tricks = _persistentDataService.filterTricksByTamaId(tamaId);
    if (_tricks.isNotEmpty) {
      _state = TrickState.done;
      _fetchTricksProgress();
    }
  }

  void _fetchTamaNameById(String? tamaId) {
    if (tamaId == null || tamaId.isEmpty) {
      _tamaName = null;
      return;
    }
    _tamaName = _persistentDataService.fetchTamaNameById(tamaId) ?? '';
  }

  void _fetchTamaGroupNameById(String? tamaId) {
    if (tamaId == null || tamaId.isEmpty) {
      _tamaGroupName = null;
      return;
    }
    _tamaGroupName = _persistentDataService.fetchTamaGroupName(tamaId) ?? '';
  }

  void _fetchTricksProgress() async {
    if (tamaId == null) return;
    try {
      final data = await _trickService.fetchTrickProgress(tamaID: tamaId!);
      for (final trickID in data.keys) {
        final tricks = _tricks.where((element) => element.trick?.id == trickID);
        if (tricks.isNotEmpty) {
          tricks.first.trickStatus = data[trickID]!;
        }
      }

      notifyListeners();
    } on PostgrestException catch (e) {
      logE('error fetching tricks progress for tamaID - $tamaId: ${e.toString()}');
    }
  }

  void _fetchTricksForTama() async {
    if (tamaId == null) return;
    try {
      final newTricks = await _trickService.fetchTricksByTamaID(tamaID: tamaId!);
      if (newTricks == null) return;

      _persistentDataService.updateTricks(newTricks: newTricks, tamaID: tamaId!);

      if (_state == TrickState.loading) {
        _populateTricks(tamaId);
        _state = TrickState.done;
        _fetchTricksProgress();
        notifyListeners();
      }
    } on PostgrestException catch (e) {
      logE('error fetching tricks progress for tamaID - $tamaId: ${e.toString()}');
    }
  }

  @override
  String get className => 'TricksPageProvider';
}
