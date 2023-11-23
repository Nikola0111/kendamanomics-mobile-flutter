import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/models/tamas_group.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TamasGroupService with LoggerMixin {
  final _persistantDataService = KiwiContainer().resolve<PersistentDataService>();
  final _supabase = Supabase.instance.client;

  Future<List<TamasGroup>?> fetchTamaGroups() async {
    final uuid = await _supabase.rpc('fetch_data_tracking', params: {'filter_tracking_name': 'tamas_group'});
    if (uuid == _persistantDataService.tamasGroupValue) return null;
    _persistantDataService.tamasGroupValue = uuid;
    logI('fetching new pins');
    final data = await _supabase.rpc('fetch_all_tamas_groups');
    if (data == null) return null;

    final tamasGroups = <TamasGroup>[];
    for (final map in data) {
      tamasGroups.add(TamasGroup.fromJson(json: map));
    }
    return tamasGroups;
  }

  @override
  String get className => 'TamaGroupService';
}
