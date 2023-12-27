import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/services/auth_service.dart';
import 'package:kendamanomics_mobile/services/in_app_purchase_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PurchaseService with LoggerMixin {
  final _authService = KiwiContainer().resolve<AuthService>();
  final _inAppPurchaseService = KiwiContainer().resolve<InAppPurchaseService>();
  final _supabase = Supabase.instance.client;

  PurchaseService() {
    _inAppPurchaseService.subscribe(_listenToInAppPurchaseService);
  }

  void _listenToInAppPurchaseService(InAppPurchaseEvents event, dynamic params) async {
    switch (event) {
      case InAppPurchaseEvents.purchased:
        final productID = params.first;
        logI('premium tama purchased, updating premium tamas groups table, productID: $productID');
        try {
          await _updatePurchasedPremiumTamas(productID);
          logI('table updated successfully');
        } catch (e) {
          logE('failed to update premium tamas table ${e.toString()}');
          // show in ui that this failed, contact administrator?
        }
        break;
    }
  }

  Future<void> _updatePurchasedPremiumTamas(String productID) async {
    final playerID = _authService.player?.id;
    await _supabase.rpc('update_purchased_groups_table', params: {'p_id': playerID, 't_g_id': productID});
  }

  Future<List<String>> fetchPurchasedGroupsData() async {
    final playerID = _authService.player?.id;
    logI('fetching purchased groups data');
    final data = await _supabase.rpc('fetch_purchased_groups_data', params: {'query_player_id': playerID});
    logI('data fetched: $data');
    final ids = <String>[];
    for (final id in data) {
      ids.add(id['premium_group_id']);
    }

    return ids;
  }

  @override
  String get className => 'PurchaseService';
}
