import 'package:flutter/foundation.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/tama_trick_progress.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kendamanomics_mobile/services/trick_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TricksProvider extends ChangeNotifier with LoggerMixin {
  final _presistentDataService = KiwiContainer().resolve<PersistentDataService>();
  final _trickService = KiwiContainer().resolve<TrickService>();
  final _tamaTricksRelation = <Map<String, dynamic>>[];
  final String? tamaId;

  List<TamaTrickProgress> _tricks = <TamaTrickProgress>[];
  String? _tamaName;
  String? _tamaGroupName;

  List<Map<String, dynamic>> get tamaTricksRelation => _tamaTricksRelation;
  List<TamaTrickProgress> get tricks => _tricks;
  String? get tamaName => _tamaName;
  String? get tamaGroupName => _tamaGroupName;

  TricksProvider({required this.tamaId}) {
    _fetchTricksProgress();
    _fetchTamaNameById(tamaId);
    _populateTricks(tamaId);
    _fetchTamaGroupNameById(tamaId);
  }

  void _populateTricks(String? tamaId) {
    _tricks = _presistentDataService.filterTricksByTamaId(tamaId);
  }

  void _fetchTamaNameById(String? tamaId) {
    if (tamaId == null || tamaId.isEmpty) {
      _tamaName = null;
      return;
    }
    _tamaName = _presistentDataService.fetchTamaNameById(tamaId) ?? '';
  }

  void _fetchTamaGroupNameById(String? tamaId) {
    if (tamaId == null || tamaId.isEmpty) {
      _tamaGroupName = null;
      return;
    }
    _tamaGroupName = _presistentDataService.fetchTamaGroupName(tamaId) ?? '';
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

  @override
  String get className => 'TricksPageProvider';
}
