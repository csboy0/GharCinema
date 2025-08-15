import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:story_box/payment/in_app_purchase/in_app_purchase_helper.dart';
import 'package:story_box/payment/stripe/stripe_service.dart';
import 'package:story_box/ui/refill/controller/refill_controller.dart';
import 'package:story_box/ui/setting_view_page/api/setting_api.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/progress_dialog.dart';

import '../in_app_purchase/iap_callback.dart';

class PaymentController extends GetxController implements IAPCallback {
  final refillController = Get.find<RefillController>();

  final StripeService stripeService = StripeService();
  final InAppPurchaseHelper inAppPurchaseHelper = InAppPurchaseHelper();

  bool isPremium = false;
  bool isProcessingPayment = false;

  Map<String, PurchaseDetails>? purchases;

  @override
  void onInit() {
    super.onInit();
    _initializePaymentServices();
  }

  Future<void> _initializePaymentServices() async {
    try {
      log("Initializing payment services");

      // Initialize IAP
      await inAppPurchaseHelper.initialize();
      inAppPurchaseHelper.setupPurchaseListener(this);

      // Get existing purchases
      purchases = inAppPurchaseHelper.getPurchases();

      // Clear any pending transactions
      await inAppPurchaseHelper.clearPendingTransactions();

      // Load settings
      await SettingApi.callApi();

      log("Payment services initialized successfully");
    } catch (e) {
      log("Error initializing payment services: $e");
    }
  }

  Future<void> makePaymentViaStripe() async {
    if (isProcessingPayment) {
      log("Payment already in progress");
      return;
    }

    try {
      isProcessingPayment = true;

      num amount = refillController.selectedCoinPlan?.offerPrice ?? 0.0;
      log("Stripe payment amount: $amount");

      int amountInCents = (amount * 1).toInt(); // Convert to cents
      log("Amount in cents: $amountInCents");

      Get.dialog(ProgressDialog(), barrierDismissible: false);

      await stripeService.makePayment(
        amount: amountInCents.toString(),
        currency: Constant.currencyCode,
        coinPlanId: refillController.selectedCoinPlan?.sId ?? '',
        onSuccess: (coinPlanId) async {
          Get.back(); // Close loading dialog
          log("Stripe payment successful");

          // Call success API
          await _handlePaymentSuccess('Stripe');
        },
        onFailure: (error) {
          Get.back(); // Close loading dialog
          log("Stripe payment failed: $error");

          Fluttertoast.showToast(
            msg: "Payment failed: $error",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },
      );
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      log("Error in Stripe payment: $e");

      Fluttertoast.showToast(
        msg: "Payment error: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      isProcessingPayment = false;
    }
  }

  Future<void> makeInAppPurchase(String productKey) async {
    if (isProcessingPayment) {
      log("Payment already in progress");
      return;
    }

    try {
      isProcessingPayment = true;
      log("Starting in-app purchase for product: $productKey");

      // Validate selected plan
      if (refillController.selectedCoinPlan == null) {
        throw Exception("No coin plan selected");
      }

      // Initialize IAP helper
      List<String> productIds = [productKey];
      inAppPurchaseHelper.init(
        paymentType: "In App Purchase",
        userId: Preference.userId,
        productKey: productIds,
        rupee: refillController.selectedCoinPlan?.offerPrice?.toDouble() ?? 0.0,
      );

      // Load store info
      bool storeInitialized = await inAppPurchaseHelper.initStoreInfo();
      if (!storeInitialized) {
        throw Exception("Failed to initialize store");
      }

      // Get product details
      ProductDetails? product =
          inAppPurchaseHelper.getProductDetail(productKey);
      log("product Details :::::${product?.id}");
      if (product == null) {
        throw Exception("Product not found: $productKey");
      }

      log("Product found: ${product.id} - ${product.title} - ${product.price}");

      // Show loading
      Get.dialog(
        ProgressDialog(),
        barrierDismissible: false,
      );

      // Start purchase
      await inAppPurchaseHelper.buyProduct(product);
    } catch (e) {
      isProcessingPayment = false;
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      log("Error in in-app purchase: $e");
      Fluttertoast.showToast(
        msg: "Purchase failed: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _handlePaymentSuccess(String paymentMethod) async {
    try {
      log("Handling payment success for method: $paymentMethod");

      // Call the API to record the purchase
      await refillController.recordCoinPlanHistoryApi(paymentMethod);

      // Show success message
      Fluttertoast.showToast(
        msg: "Payment successful!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Update UI or navigate as needed
      // You might want to close dialogs, refresh data, etc.

      log("Payment success handled successfully");
    } catch (e) {
      log("Error handling payment success: $e");
      // Even if API call fails, we should still show success to user
      // since the payment was processed
      Fluttertoast.showToast(
        msg: "Payment successful! (Recording pending)",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // IAP Callback implementations
  @override
  void onLoaded(bool initialized) {
    log("IAP loaded: $initialized");
  }

  @override
  void onPending(PurchaseDetails product) {
    log("IAP pending: ${product.productID}");
    // Keep the loading dialog open for pending purchases
  }

  @override
  void onSuccessPurchase(PurchaseDetails product) async {
    log("IAP success: ${product.productID}");

    // Close loading dialog
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    isProcessingPayment = false;

    // Handle successful purchase
    await _handlePaymentSuccess('In App Purchase');
  }

  @override
  void onBillingError(dynamic error) {
    log("IAP billing error: $error");

    // Close loading dialog
    if (Get.isDialogOpen == true) {
      Get.back();
      Get.back();
    }

    isProcessingPayment = false;

    String errorMessage = "Purchase failed";
    if (error != null) {
      errorMessage = error.toString();
    }

    Fluttertoast.showToast(
      msg: errorMessage,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> restorePurchases() async {
    try {
      log("Restoring purchases");
      Get.dialog(ProgressDialog(), barrierDismissible: false);

      await inAppPurchaseHelper.restorePurchases();

      // Wait a moment for the restore process
      await Future.delayed(Duration(seconds: 2));

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Fluttertoast.showToast(
        msg: "Restore completed",
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      log("Error restoring purchases: $e");
      Fluttertoast.showToast(
        msg: "Restore failed: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    inAppPurchaseHelper.dispose();
    super.onClose();
  }
}
