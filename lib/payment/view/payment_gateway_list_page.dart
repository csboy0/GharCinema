// ignore_for_file: must_be_immutable
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:story_box/payment/flutter_wave/flutter_wave_service.dart';
import 'package:story_box/ui/refill/controller/refill_controller.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

import '../../utils/font_style.dart';
import '../controller/payment_controller.dart';
import '../razor_pay/razor_pay_service.dart';

class PaymentGatewayListPage extends StatelessWidget {
  PaymentGatewayListPage({super.key});

  PaymentController paymentController = Get.put(PaymentController());
  final refillController = Get.find<RefillController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.59,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
        border: Border.symmetric(
            vertical: BorderSide(color: AppColor.colorWhite.withValues(alpha: 0.10))
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xff1A0B25),
            Color(0xff18050C),
          ],
        ),
      ),
      width: Get.width,
      child: Column(
        children: [
          Container(
            height: 58,
            width: Get.width,
            decoration: BoxDecoration(
              color: AppColor.colorWhite.withValues(alpha: 0.20),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
                topLeft: Radius.circular(24),
              ),
            ),
            child: Center(
              child: Text(
                EnumLocal.selectPaymentOption.name.tr,
                style: AppFontStyle.styleW700(AppColor.colorWhite, 19),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                if (Constant.stripeSwitch)
                  PaymentItemBuilder(
                    EnumLocal.stripe.name.tr,
                    AppAsset.stripe,
                        () async {
                      Get.back(); // Close the payment selection dialog
                      await paymentController.makePaymentViaStripe();
                    },
                  ),
                if (Constant.googlePlaySwitch)
                  Platform.isAndroid
                      ? PaymentItemBuilder(
                    EnumLocal.inAppPurchase.name.tr,
                    AppAsset.icGoogle,
                        () async {
                      Get.back(); // Close the payment selection dialog
                      await _handleInAppPurchase();
                    },
                  )
                      : PaymentItemBuilder(
                    EnumLocal.applePurchase.name.tr,
                    AppAsset.applePay,
                        () async {
                      Get.back(); // Close the payment selection dialog
                      await _handleInAppPurchase();
                    },
                  ),
                if (Constant.razorPaySwitch)
                  PaymentItemBuilder(
                    EnumLocal.razorPay.name.tr,
                    AppAsset.razor,
                        () async {
                      Get.back(); // Close the payment selection dialog
                      await _handleRazorPayPayment();
                    },
                  ),
                if (Constant.flutterWaveSwitch)
                  PaymentItemBuilder(
                    'Flutter Wave',
                    AppAsset.flutterWave,
                        () async {
                      Get.back(); // Close the payment selection dialog
                      await _handleFlutterWavePayment();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleInAppPurchase() async {
    try {
      log("Starting in-app purchase process");

      // Validate selected coin plan
      if (refillController.selectedCoinPlan == null) {
        log("No coin plan selected");
        Utils.showToast(Get.context!,"Please select a coin plan first");
        return;
      }

      // Get product key
      String productKey = refillController.selectedCoinPlan?.productKey ?? "";
      if (productKey.isEmpty) {
        log("Product key is empty for plan: ${refillController.selectedCoinPlan?.toJson()}");
        Utils.showToast(Get.context!,"Product key not found for this plan");
        return;
      }

      log("Initiating purchase for product: $productKey");
      log("Plan details: ${refillController.selectedCoinPlan?.toJson()}");

      // Start the purchase process
      await paymentController.makeInAppPurchase(productKey);

    } catch (e) {
      log("Error in _handleInAppPurchase: $e");
      Utils.showToast(Get.context!,"Failed to start purchase: $e");
    }
  }

  Future<void> _handleRazorPayPayment() async {
    try {
      log("Starting Razorpay payment");

      if (refillController.selectedCoinPlan == null) {
        Utils.showToast(Get.context!,"Please select a coin plan first");
        return;
      }

      RazorPayService().init(
        razorKey: Constant.razorSecretKey,
        callback: () async {
          log("Razorpay payment successful");
          // Call success API
          await refillController.recordCoinPlanHistoryApi('Razorpay');
        },
      );

      String amount = refillController.selectedCoinPlan?.offerPrice.toString() ?? '0';
      int amountInCents = ((double.tryParse(amount) ?? 0) * 100).toInt();

      log("Razorpay amount in cents: $amountInCents");

      await 1.seconds.delay();
      RazorPayService().razorPayCheckout(amountInCents);

    } catch (e) {
      log("Error in Razorpay payment: $e");
      Utils.showToast(Get.context!,"Razorpay payment failed: $e");
    }
  }

  Future<void> _handleFlutterWavePayment() async {
    try {
      log("Starting FlutterWave payment");

      if (refillController.selectedCoinPlan == null) {
        Utils.showToast(Get.context!,"Please select a coin plan first");
        return;
      }

      String amount = refillController.selectedCoinPlan?.offerPrice.toString() ?? '0';

      log("FlutterWave payment amount: $amount");

      FlutterWaveService.init(
        amount: amount,
        onPaymentComplete: () async {
          log("FlutterWave payment successful");
          // Call success API
          await refillController.recordCoinPlanHistoryApi('FlutterWave');
        },
      );

    } catch (e) {
      log("Error in FlutterWave payment: $e");
      Utils.showToast(Get.context!,"FlutterWave payment failed: $e");
    }
  }
}

class PaymentItemBuilder extends StatelessWidget {
  String name, icon;
  Callback onTapItem;

  PaymentItemBuilder(
      this.name,
      this.icon,
      this.onTapItem, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTapItem,
        child: Container(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.all(8),
        width: Get.width,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.colorWhite.withValues(alpha: 0.13)),
          color: AppColor.colorWhite.withValues(alpha: 0.08),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: const Color(0xff3E3041),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                icon,
                height: 50,
                width: 50,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              name,
              style: AppFontStyle.styleW700(AppColor.colorWhite, 16),
            ),
            const Spacer(),
            Image.asset(
              AppAsset.icRightArrow,
              width: 20,
              height: 20,
            ).paddingOnly(right: 12),
          ],
        ),
      ),
    );
  }
}
