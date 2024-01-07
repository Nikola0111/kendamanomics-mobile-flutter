import 'package:kendamanomics_mobile/constants.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/premium_tamas_group.dart';
import 'package:kendamanomics_mobile/models/tamas_group.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TamasGroupService with LoggerMixin {
  final _persistantDataService = KiwiContainer().resolve<PersistentDataService>();
  final _supabase = Supabase.instance.client;

  Future<Map<String, List<TamasGroup>>?> fetchTamaGroups() async {
    final uuid = await _supabase.rpc('fetch_data_tracking', params: {'filter_tracking_name': 'tamas_group'});
    if (uuid == _persistantDataService.tamasGroupValue) return null;
    _persistantDataService.tamasGroupValue = uuid;
    logI('fetching new pins');
    final data = await _supabase.rpc('fetch_all_tamas_groups_new');
    if (data == null) return null;

    final tamasGroups = <String, List<TamasGroup>>{};
    tamasGroups[kPremiumTamasGroups] = <PremiumTamasGroup>[];
    tamasGroups[kRegularTamasGroups] = <TamasGroup>[];
    for (final map in data) {
      if (_isJsonPremiumTama(map)) {
        tamasGroups[kPremiumTamasGroups]!.add(PremiumTamasGroup.fromJson(json: map));
      } else {
        tamasGroups[kRegularTamasGroups]!.add(TamasGroup.fromJson(json: map));
      }
    }
    return tamasGroups;
  }

  bool _isJsonPremiumTama(Map<String, dynamic> json) {
    if (json.containsKey('background_color') &&
        json.containsKey('price') &&
        json.containsKey('video_url') &&
        json['background_color'] != null &&
        json['price'] != null &&
        json['video_url'] != null) return true;

    return false;
  }

  @override
  String get className => 'TamaGroupService';
}
