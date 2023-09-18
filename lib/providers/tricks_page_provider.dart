import 'package:flutter/foundation.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/tama_trick_progress.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kiwi/kiwi.dart';

class TricksPageProvider extends ChangeNotifier with LoggerMixin {
  final _presistentDataService = KiwiContainer().resolve<PersistentDataService>();
  final _tamaTricksRelation = <Map<String, dynamic>>[];
  final String? tamaId;

  List<TamaTrickProgress> _tricks = <TamaTrickProgress>[];
  String? _tamaName;
  String? _tamaGroupName;

  List<Map<String, dynamic>> get tamaTricksRelation => _tamaTricksRelation;
  List<TamaTrickProgress> get tricks => _tricks;
  String? get tamaName => _tamaName;
  String? get tamaGroupName => _tamaGroupName;

  TricksPageProvider({required this.tamaId}) {
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

  @override
  String get className => 'TricksPageProvider';
}
