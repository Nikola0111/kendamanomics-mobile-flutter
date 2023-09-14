import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/tama.dart';
import 'package:kendamanomics_mobile/models/tamas_group.dart';
import 'package:kendamanomics_mobile/models/trick.dart';

class PersistentDataService with LoggerMixin {
  static const _tamasFileName = 'tamas';
  static const _groupsFileName = 'groups';
  static const _tamaTricksFileName = 'tama_tricks';
  static const _tricksFileName = 'tricks';

  final _tamaGroups = <TamasGroup>[];
  final _tamas = <String, Tama>{};
  final _tricks = <Trick>[];
  final _tamaTricksRelation = <Map<String, dynamic>>[];
  bool _loaded = false;

  List<TamasGroup> get tamasGroup => _tamaGroups;

  // order is important: first load the connection between tricks and tamas, then load tamas, then load tricks and upon
  // creation add them to their tama
  Future<void> init() async {
    if (_loaded) return;
    await _loadTamaTricks();

    await _loadTamas();
    await _loadTricks();

    await _loadGroups();

    _loaded = true;
  }

  Future<void> _loadTamaTricks() async {
    final data = await rootBundle.loadString('assets/statics/$_tamaTricksFileName.json');
    try {
      Map<String, dynamic> jsonResult = json.decode(data);
      for (var tamaJson in jsonResult['data']) {
        _tamaTricksRelation.add({
          'tama_id': tamaJson['tama_id'],
          'trick_id': tamaJson['trick_id'],
          'trick_points': tamaJson['trick_points'],
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
        final trick = Trick.fromJson(json: tricksJson);
        if (trick.id != null) {
          _tricks.add(trick);
          final tamaIDs = _tamaTricksRelation.where((element) => element['trick_id'] == trick.id).toList();
          for (final tamaTrickMap in tamaIDs) {
            final tamaID = tamaTrickMap['tama_id'];
            if (_tamas.containsKey(tamaID)) _tamas[tamaID]!.tricks.add(trick);
          }
        }
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

  @override
  String get className => 'PersistentDataService';
}
