import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PurchaseService with LoggerMixin {
  final _authService = KiwiContainer().resolve<AuthService>();
  final _supabase = Supabase.instance.client;

  Future<List<String>> fetchPurchasedGroupsData() async {
    final playerID = _authService.player?.id;
    logI('fetching purchased groups data');
    final data = await _supabase.rpc('fetch_purchased_groups_data', params: {'query_player_id': playerID});
    logI('data fetched: $data');
    final ids = <String>[];
    for(final id in data) {
      ids.add(id['premium_group_id']);
    }

    return ids;
  }

  @override
  String get className => 'PurchaseService';
}
