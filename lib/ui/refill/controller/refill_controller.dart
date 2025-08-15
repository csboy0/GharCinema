import 'dart:developer';

import 'package:get/get.dart';
import 'package:story_box/ui/refill/api/store_api.dart';
import 'package:story_box/ui/refill/model/coin_plan.dart';
import 'package:story_box/ui/refill/model/vip_plan.dart';
import 'package:story_box/ui/setting_view_page/api/setting_api.dart';
import 'package:story_box/ui/setting_view_page/model/setting.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/payment/in_app_purchase/in_app_purchase_helper.dart';
import 'package:story_box/payment/in_app_purchase/iap_callback.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:story_box/utils/utils.dart';

class RefillController extends GetxController {
  List<CoinPlan> coinPlan = [];
  List<VipPlan> vipPlan = [];
  bool isLoadingVipPlan = false;
  bool isLoadingCoinPlan = false;
  CoinPlan? selectedCoinPlan;

  Setting? setting;

  @override
  void onInit() {
    getCoinPlanApi();
    getVipPlanApi();
    SettingApi.callApi();

    super.onInit();

    log("Constant.stripeSwitch${Constant.stripeSwitch}");
    log("Constant.googlePlaySwitch${Constant.googlePlaySwitch}");
    log("Constant.googlePlaySwitch${SettingApi.setting?.flutterWaveSwitch}");
    log("Constant.googlePlaySwitch${SettingApi.setting?.razorPaySwitch}");
  }

  getCoinPlanApi() async {
    isLoadingCoinPlan = true;
    coinPlan = await StoreApi.fetchCoinPlanApi();
    isLoadingCoinPlan = false;
    update(['coinPlan']);
  }

  getVipPlanApi() async {
    isLoadingVipPlan = true;
    vipPlan = await StoreApi.fetchVipPlanApi();
    isLoadingVipPlan = false;
    update(['vipPlan']);
  }

  void selectCoinPlan(int index) {
    selectedCoinPlan = coinPlan[index];
    update(['coinPlan']);
  }

  // Method to handle in-app purchase for coin plans
  Future<void> handleCoinPlanInAppPurchase() async {
    try {
      if (selectedCoinPlan == null) {
        log("No coin plan selected");
        return;
      }

      String productKey = selectedCoinPlan!.productKey ?? "";
      if (productKey.isEmpty) {
        log("Product key is empty for coin plan");
        return;
      }

      List<String> kProductIds = <String>[productKey];

      // Initialize with custom callback
      InAppPurchaseHelper().init(
        paymentType: "In App Purchase",
        userId: Preference.userId,
        productKey: kProductIds,
        rupee: selectedCoinPlan!.offerPrice?.toDouble() ?? 0.0,
      );

      // Setup purchase listener with callback for coin plan
      InAppPurchaseHelper().setupPurchaseListener(CoinPlanIAPCallback(
        coinPlanId: selectedCoinPlan!.sId ?? '',
        refillController: this,
      ));

      log("Coin plan initialization completed");

      // Wait for store info to load
      bool storeInitialized = await InAppPurchaseHelper().initStoreInfo();

      if (!storeInitialized) {
        log("Store initialization failed");
        return;
      }

      log("selectedCoinPlan.productKey :: $productKey");

      ProductDetails? product =
          InAppPurchaseHelper().getProductDetail(productKey);
      if (product != null) {
        log("Product details retrieved successfully for :: ${product.id}");
        await InAppPurchaseHelper().buyProduct(product);
      } else {
        log("Product is null for :: $productKey");
      }
    } catch (e) {
      log("Error in handleCoinPlanInAppPurchase: $e");
      Utils.showToast(Get.context!, "Error initiating purchase");
    }
  }

  recordCoinPlanHistoryApi(
    String paymentType,
  ) async {
    await StoreApi.recordCoinPlanHistory(
      loginUserId: Preference.userId,
      coinPlanId: selectedCoinPlan?.sId ?? '',
      paymentType: paymentType,
    );
    Preference.userCoin;
    update(['updateCoin']);
  }

  recordVipPlanHistoryApi(String paymentType, String id) async {
    await StoreApi.recordVipPlanHistory(
      loginUserId: Preference.userId,
      vipPlanId: id,
      paymentType: paymentType,
    );
    Preference.isVip;
    update(['vipPlan']);
  }
}

class CoinPlanIAPCallback extends IAPCallback {
  final String coinPlanId;
  final RefillController refillController;

  CoinPlanIAPCallback({
    required this.coinPlanId,
    required this.refillController,
  });

  @override
  void onSuccessPurchase(PurchaseDetails product) {
    log("Coin Plan purchase successful: ${product.productID}");

    // Call the API to record coin plan history
    refillController.recordCoinPlanHistoryApi(
      "in_app_purchase",
    );

    // Show success message
    Utils.showToast(Get.context!, "Coins purchased successfully!");

    // Navigate back or refresh UI if needed
    Get.back();
  }

  @override
  void onBillingError(dynamic error) {
    log("Coin Plan purchase error: $error");
    Utils.showToast(Get.context!, "Purchase failed. Please try again.");
  }

  @override
  void onPending(PurchaseDetails product) {
    log("Coin Plan purchase pending: ${product.productID}");
    Utils.showToast(Get.context!, "Purchase is pending...");
  }
}
