import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../utils/utils.dart';
import 'iap_callback.dart';
import 'iap_receipt_data.dart';

class InAppPurchaseHelper {
  static final InAppPurchaseHelper _inAppPurchaseHelper =
      InAppPurchaseHelper._internal();

  InAppPurchaseHelper._internal();

  factory InAppPurchaseHelper() {
    return _inAppPurchaseHelper;
  }

  // Purchase parameters
  double rupee = 0;
  String userId = "";
  String paymentType = "";
  List<String> productId = [];

  final InAppPurchase _connection = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  IAPCallback? _iapCallback;

  bool _isInitialized = false;

  void init({
    required double rupee,
    required String userId,
    required String paymentType,
    required List<String> productKey,
  }) {
    this.rupee = rupee;
    this.userId = userId;
    this.paymentType = paymentType;
    productId = productKey;
    log("InAppPurchaseHelper initialized with products: $productKey");
  }

  Future<void> initialize() async {
    if (_isInitialized) {
      log("InAppPurchaseHelper already initialized");
      return;
    }

    log("Initializing InAppPurchaseHelper");

    _isInitialized = true;
    log("InAppPurchaseHelper initialization completed");
  }

  ProductDetails? getProductDetail(String productID) {
    for (ProductDetails item in _products) {
      if (item.id == productID) {
        return item;
      }
    }
    log("Product not found: $productID");
    return null;
  }

  void setupPurchaseListener(IAPCallback iapCallback) {
    log("setupPurchaseListener>>>>>>>>>");
    _iapCallback = iapCallback;

    if (_subscription != null) {
      _subscription!.cancel();
    }

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _connection.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        log("Purchase stream received: ${purchaseDetailsList.length} items");
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      cancelOnError: false,
      onError: (error) {
        log("Purchase stream error: $error");
        _iapCallback?.onBillingError(error);
      },
    );
  }

  Future<bool> initStoreInfo() async {
    if (!_isInitialized) {
      await initialize();
    }

    log("Checking store availability");
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      log("Store is not available");
      _iapCallback?.onBillingError("Store is not available");
      return false;
    }

    log("Querying product details for: $productId");
    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(productId.toSet());

    if (productDetailResponse.error != null) {
      log("Error querying products: ${productDetailResponse.error}");
      _iapCallback?.onBillingError(productDetailResponse.error);
      return false;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      log("No products found");
      _iapCallback?.onBillingError("No products found");
      return false;
    }

    _products = productDetailResponse.productDetails;
    log("Found ${_products.length} products");

    for (var product in _products) {
      log("Product: ${product.id} - ${product.title} - ${product.price}");
    }

    // Check for existing purchases after initializing products
    await _checkExistingPurchases();

    return true;
  }

  Future<void> _checkExistingPurchases() async {
    try {
      log("Checking for existing purchases");

      // For checking existing purchases, we need to use restorePurchases()
      // This will trigger the purchase stream with existing purchases
      await _connection.restorePurchases();

      // The restored purchases will be handled by the purchase stream listener
      // in _handlePurchaseUpdates method with PurchaseStatus.restored

      log("Restore purchases initiated");
    } catch (e) {
      log("Error checking existing purchases: $e");
    }
  }

  Future<void> _handlePurchaseUpdates(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      log("Processing purchase: ${purchaseDetails.productID} - Status: ${purchaseDetails.status}");

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          log("Purchase pending: ${purchaseDetails.productID}");
          _iapCallback?.onPending(purchaseDetails);
          break;

        case PurchaseStatus.purchased:
          log("Purchase successful: ${purchaseDetails.productID}");
          await _handleSuccessfulPurchase(purchaseDetails);
          break;

        case PurchaseStatus.restored:
          log("Purchase restored: ${purchaseDetails.productID}");
          await _handleSuccessfulPurchase(purchaseDetails);
          break;

        case PurchaseStatus.error:
          log("Purchase error: ${purchaseDetails.error}");

          // Handle specific error cases
          if (purchaseDetails.error?.code == 'purchase_error' &&
              purchaseDetails.error!.message.contains('itemAlreadyOwned')) {
            log("Item already owned, treating as successful purchase");

            // For already owned subscriptions, we should check if it's active
            // and treat it as a successful purchase
            await _handleAlreadyOwnedSubscription(purchaseDetails);
          } else {
            _iapCallback?.onBillingError(purchaseDetails.error);
          }
          break;

        case PurchaseStatus.canceled:
          log("Purchase canceled: ${purchaseDetails.productID}");
          Get.back();
          Fluttertoast.showToast(msg: "Payment canceled");
          break;
      }

      // Complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        log("Completing purchase: ${purchaseDetails.productID}");
        await _connection.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _handleAlreadyOwnedSubscription(
      PurchaseDetails purchaseDetails) async {
    try {
      log("Handling already owned subscription: ${purchaseDetails.productID}");

      // Check if this subscription is still active
      bool isActive = await _checkSubscriptionStatus(purchaseDetails.productID);

      if (isActive) {
        // Treat as successful purchase
        await _handleSuccessfulPurchase(purchaseDetails);
      } else {
        // Subscription expired, user needs to renew
        _iapCallback?.onBillingError("Subscription expired. Please renew.");
      }
    } catch (e) {
      log("Error handling already owned subscription: $e");
      _iapCallback?.onBillingError("Error processing subscription: $e");
    }
  }

  Future<bool> _checkSubscriptionStatus(String productId) async {
    // You can implement this by checking with your backend
    // or by querying the subscription status from Google Play

    // For now, let's assume it's active if it's already owned
    // In production, you should verify with your server
    log("Checking subscription status for: $productId");
    return true;
  }

  Future<void> _handleSuccessfulPurchase(
      PurchaseDetails purchaseDetails) async {
    try {
      // Verify the purchase (you should implement proper verification)
      bool isValid = await _verifyPurchase(purchaseDetails);

      if (isValid) {
        // Check if already processed
        final prefs = await SharedPreferences.getInstance();
        String key =
            "processed_${purchaseDetails.productID}_${purchaseDetails.transactionDate}";
        bool alreadyProcessed = prefs.getBool(key) ?? false;

        if (!alreadyProcessed) {
          log("Processing new purchase: ${purchaseDetails.purchaseID}");

          // Mark as processed
          await prefs.setBool(key, true);

          // Add to purchases list
          _purchases.add(purchaseDetails);

          // Notify via stream
          MyApp.purchaseStreamController.add(purchaseDetails);

          // Show success message
          Fluttertoast.showToast(
            msg: "Payment successful!",
            backgroundColor: Colors.green,
          );

          // Notify callback
          _iapCallback?.onSuccessPurchase(purchaseDetails);

          log("Purchase processed successfully");
        } else {
          log("Purchase already processed: ${purchaseDetails.productID}");
        }
      } else {
        log("Purchase verification failed: ${purchaseDetails.productID}");
        _iapCallback?.onBillingError("Purchase verification failed");
      }
    } catch (e) {
      log("Error handling successful purchase: $e");
      _iapCallback?.onBillingError("Error processing purchase: $e");
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // For now, return true. In production, you should verify with your server
    // or with Apple/Google's servers
    log("Verifying purchase: ${purchaseDetails.productID}");

    if (Platform.isIOS) {
      return await _verifyApplePurchase(purchaseDetails);
    } else {
      // For Android, you might want to verify with Google Play
      return true; // Simplified for now
    }
  }

  Future<bool> _verifyApplePurchase(PurchaseDetails purchaseDetails) async {
    try {
      var dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      Map<String, String> data = {
        "receipt-data": purchaseDetails.verificationData.localVerificationData
      };

      String verifyReceiptUrl = Utils.sandboxVerifyReceiptUrl
          ? 'https://sandbox.itunes.apple.com/verifyReceipt'
          : 'https://buy.itunes.apple.com/verifyReceipt';

      final response = await dio.post<String>(verifyReceiptUrl, data: data);
      Map<String, dynamic> profile = jsonDecode(response.data!);

      var receiptData = IapReceiptData.fromJson(profile);

      if (receiptData.status == 0) {
        log("Apple purchase verified successfully");
        return true;
      } else {
        log("Apple purchase verification failed: ${receiptData.status}");
        return false;
      }
    } catch (e) {
      log("Error verifying Apple purchase: $e");
      return false;
    }
  }

  Future<void> buyProduct(ProductDetails productDetails) async {
    log("Attempting to buy product: ${productDetails.id}");

    try {
      // Clear any pending transactions first
      await clearPendingTransactions();

      PurchaseParam purchaseParam;

      if (Platform.isAndroid) {
        purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: userId,
        );
      } else {
        purchaseParam = PurchaseParam(
          productDetails: productDetails,
          applicationUserName: userId,
        );
      }

      bool purchaseResult;

      if (productDetails.id.contains('subscription')) {
        // For subscriptions
        purchaseResult =
            await _connection.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        // For consumable products
        purchaseResult =
            await _connection.buyConsumable(purchaseParam: purchaseParam);
      }

      log("Purchase initiated: $purchaseResult");
    } catch (error) {
      log("Error buying product: $error");
      _iapCallback?.onBillingError(error);
    }
  }

  Future<void> clearPendingTransactions() async {
    if (Platform.isIOS) {
      try {
        final transactions = await SKPaymentQueueWrapper().transactions();
        for (final transaction in transactions) {
          if (transaction.transactionState !=
              SKPaymentTransactionStateWrapper.purchasing) {
            await SKPaymentQueueWrapper().finishTransaction(transaction);
          }
        }
        log("Cleared ${transactions.length} pending iOS transactions");
      } catch (e) {
        log("Error clearing iOS transactions: $e");
      }
    }
  }

  Future<void> restorePurchases() async {
    log("Restoring purchases");
    try {
      await _connection.restorePurchases();
    } catch (e) {
      log("Error restoring purchases: $e");
      _iapCallback?.onBillingError("Error restoring purchases: $e");
    }
  }

  Map<String, PurchaseDetails> getPurchases() {
    Map<String, PurchaseDetails> purchases = Map.fromEntries(
      _purchases.map((PurchaseDetails purchase) {
        return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
      }),
    );
    return purchases;
  }

  void dispose() {
    log("Disposing InAppPurchaseHelper");
    _subscription?.cancel();
    _subscription = null;
    _iapCallback = null;
  }
}
