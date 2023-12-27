import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kendamanomics_mobile/mixins/logger_mixin.dart';
import 'package:kendamanomics_mobile/mixins/subscription_mixin.dart';
import 'package:kendamanomics_mobile/services/persistent_data_service.dart';
import 'package:kiwi/kiwi.dart';

class InAppPurchaseService with LoggerMixin, SubscriptionMixin {
  final _persistentDataService = KiwiContainer().resolve<PersistentDataService>();
  final _inAppPurchaseInstance = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late bool available;

  final _products = <ProductDetails>[];

  InAppPurchaseService() {
    _init();
  }

  void _init() async {
    available = await _inAppPurchaseInstance.isAvailable();

    final Stream<List<PurchaseDetails>> purchaseUpdates = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdates.listen(_handlePurchaseUpdates);
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> details) {
    print('payment happened');
    print('details are: ${details.first.toString()}');
  }

  Future<void> purchasePremiumTamasGroup({required String premiumTamasGroupID}) async {
    final selectedProductDetails = _products.where((element) => element.id == premiumTamasGroupID).first;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: selectedProductDetails);
    await _inAppPurchaseInstance.buyConsumable(purchaseParam: purchaseParam);
  }

  void queryProducts() async {
    final premiumTamasGroupsIDs = _persistentDataService.premiumTamasGroupIDs.map((e) => e.replaceAll('-', '')).toSet();
    final ProductDetailsResponse response = await _inAppPurchaseInstance.queryProductDetails(premiumTamasGroupsIDs);
    // if (response.notFoundIDs.isNotEmpty) {} error handling
    _products.clear();
    _products.addAll(response.productDetails);
  }

  void dispose() {
    _subscription.cancel();
  }

  @override
  String get className => 'InAppPurchaseService';
}
