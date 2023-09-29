import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/tama.dart';
import 'package:kendamanomics_mobile/models/tama_trick_progress.dart';
import 'package:kendamanomics_mobile/models/tamas_group.dart';
import 'package:kendamanomics_mobile/models/trick.dart';

class PersistentDataService with LoggerMixin {
  static const _tamasFileName = 'tamas';
  static const _groupsFileName = 'groups';
  static const _tamaTricksRelationFileName = 'tama_tricks_relation';
  static const _tricksFileName = 'tricks';

  final _tamaGroups = <TamasGroup>[];
  final _tamas = <String, Tama>{};
  final _tricks = <Trick>[];
  final _tamaTricksRelation = <Map<String, dynamic>>[];
  bool _loaded = false;

  List<TamasGroup> get tamasGroup => _tamaGroups;
  List<Trick> get tricks => _tricks;
  Map<String, Tama> get tamas => _tamas;

  // order is important: first load the connection between tricks and tamas, then load tamas, then load tricks and upon
  // creation add them to their tama
  Future<void> init() async {
    if (_loaded) return;
    await _loadTamaTricksRelation();

    await _loadTamas();
    await _loadTricks();

    await _loadGroups();

    _loaded = true;
  }

  Future<void> _loadTamaTricksRelation() async {
    final data = await rootBundle.loadString('assets/statics/$_tamaTricksRelationFileName.json');
    try {
      Map<String, dynamic> jsonResult = json.decode(data);
      for (var tamaJson in jsonResult['data']) {
        _tamaTricksRelation.add({
          'tama_id': tamaJson['tama_id'],
          'trick_id': tamaJson['trick_id'],
          'trick_points': tamaJson['trick_points'],
          'trick_order': tamaJson['trick_order'],
        });
      }
    } catch (e) {
      logE('error loading tama tricks relation: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> _loadTamas() async {
    final data = await rootBundle.loadString('assets/statics/$_tamasFileName.json');
    try {
      Map<String, dynamic> jsonResult = json.decode(data);
      _tamas.clear();
      for (var tamaJson in jsonResult['data']) {
        if (tamaJson == null) continue;
        final tama = Tama.fromJson(json: tamaJson);
        if (tama.id != null) {
          _tamas[tama.id!] = tama;
        }
      }
    } catch (e) {
      logE('error loading tamas: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> _loadTricks() async {
    final data = await rootBundle.loadString('assets/statics/$_tricksFileName.json');
    try {
      Map<String, dynamic> jsonResult = json.decode(data);
      _tricks.clear();
      for (var tricksJson in jsonResult['data']) {
        if (tricksJson == null) continue;

        final tamaID = _tamaTricksRelation
            .where((element) => element['trick_id'] == tricksJson['trick_id'])
            .toList()
            .map((e) => e['tama_id'])
            .first;

        final trick = Trick.fromJson(json: tricksJson, tamaID: tamaID);
        if (trick.id != null) {
          _tricks.add(trick);

          final trickIndex =
              _tamaTricksRelation.where((element) => element['trick_id'] == trick.id && tamaID == element['tama_id']);

          if (_tamas.containsKey(trick.tamaID)) {
            _tamas[trick.tamaID]!
                .tricks!
                .add(TamaTrickProgress.fromTrick(trick: trick, trickPosition: trickIndex.first['trick_order']));
          }
        }

        compute((message) => _sortTricksInTamas(), null);
      }
    } catch (e) {
      logE('error loading tricks: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> _loadGroups() async {
    final data = await rootBundle.loadString('assets/statics/$_groupsFileName.json');
    try {
      Map<String, dynamic> jsonResult = json.decode(data);
      _tamaGroups.clear();
      for (var groupsJson in jsonResult['data']) {
        if (groupsJson == null) continue;

        final tamas = _tamas.values.toList();
        final tamasForGroup = tamas.where((element) => element.tamasGroupID == groupsJson['tamas_group_id']).toList();

        final group = TamasGroup.fromJson(json: groupsJson, tamas: tamasForGroup);
        if (group.id != null) {
          _tamaGroups.add(group);
        }
      }
    } catch (e) {
      logE('error loading tama groups: ${e.toString()}');
      rethrow;
    }
  }

  List<TamaTrickProgress> filterTricksByTamaId(String? tamaId) {
    if (tamaId == null || tamaId.isEmpty) {
      return [];
    }
    return _tamas[tamaId]!.tricks ?? [];
  }

  Trick? getTrickByID(String? trickID) {
    if (trickID == null || trickID.isEmpty) {
      return null;
    }

    final trick = _tricks.where((element) => element.id == trickID);
    if (trick.isEmpty) return null;
    return trick.first;
  }

  String? fetchTamaNameById(String? tamaId) {
    if (tamaId == null || tamaId.isEmpty) {
      return null;
    }
    final tama = _tamas[tamaId];
    return tama?.name;
  }

  String? fetchTamaGroupName(String? tamaId) {
    if (tamaId == null || tamaId.isEmpty) {
      return null;
    }
    final tama = _tamas[tamaId];
    if (tama != null) {
      final tamaGroup = _tamaGroups.firstWhere((element) => element.id == tama.tamasGroupID);

      return tamaGroup.name;
    }
    return null;
  }

  void _sortTricksInTamas() {
    final tamas = _tamas.values.toList();

    for (final tama in tamas) {
      tama.tricks?.sort((a, b) {
        if (a.trickPosition != null && b.trickPosition != null) {
          return a.trickPosition!.compareTo(b.trickPosition!);
        }

        return 0;
      });
    }
  }

  @override
  String get className => 'PersistentDataService';
}
