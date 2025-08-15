import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/preference.dart';

class StripeService {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment({
    required String amount,
    required String currency,
    required String coinPlanId,
    required Function(String coinPlanId) onSuccess, // Success callback
    required Function(String error) onFailure, // Failure callback
  }) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            merchantDisplayName: 'storybox',
            googlePay: const PaymentSheetGooglePay(
              merchantCountryCode: 'US',
              testEnv: true,
            ),
            style: ThemeMode.dark,
          ),
        );
        await presentPaymentSheet(coinPlanId, onSuccess, onFailure);
      }
    } catch (e) {
      onFailure(e.toString()); // Trigger failure callback
    }
  }

  Future<void> presentPaymentSheet(String coinPlanId, Function(String) onSuccess, Function(String) onFailure) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      onSuccess(coinPlanId); // Trigger success callback
    } catch (e) {
      onFailure(e.toString()); // Trigger failure callback
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization": "Bearer ${Constant.stripeTestSecretKey}",
          "Content-Type": 'application/x-www-form-urlencoded',
        },
      );

      return response.statusCode == 200 ? jsonDecode(response.body) : null;
    } catch (e) {
      return null;
    }
  }

  String calculateAmount(String amount) {
    final int calculatedAmount = int.parse(amount) * 100;
    return calculatedAmount.toString();
  }
}

/*class StripeService {
  static final _instance = StripeService._internal();
  factory StripeService() => _instance;
  StripeService._internal();

  Future<void> makePayment({
    required String amount,
    required String currency,
    required String coinPlanId,
    required Function(String) onSuccess,
    required Function(String) onFailure,
  }) async {
    try {
      print("🔥 [StripeService] makePayment started");
      print("💰 [StripeService] Amount: $amount");
      print("💰 [StripeService] Currency: $currency");
      print("💰 [StripeService] CoinPlanId: $coinPlanId");

      // 1. Check Stripe initialization
      print("🔍 [StripeService] Checking Stripe initialization...");

      // 2. Create Payment Intent
      print("🔍 [StripeService] Creating payment intent...");

      // Backend API call કરો payment intent માટે
      final paymentIntentResponse = await createPaymentIntent(
        amount: amount,
        currency: currency,
        coinPlanId: coinPlanId,
      );

      print("✅ [StripeService] Payment intent created: ${paymentIntentResponse.toString()}");

      if (paymentIntentResponse == null) {
        print("❌ [StripeService] Payment intent is null");
        onFailure("Failed to create payment intent");
        return;
      }

      // 3. Initialize Payment Sheet
      print("🔍 [StripeService] Initializing payment sheet...");

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentResponse['client_secret'],
          merchantDisplayName: 'Your App Name',
          style: ThemeMode.dark, // or ThemeMode.light
        ),
      );

      print("✅ [StripeService] Payment sheet initialized");

      // 4. Present Payment Sheet
      print("🔍 [StripeService] Presenting payment sheet...");

      await Stripe.instance.presentPaymentSheet();

      print("✅ [StripeService] Payment sheet presented successfully");
      print("✅ [StripeService] Payment completed successfully");

      // Success callback
      onSuccess(coinPlanId);
    } on StripeException catch (e) {
      print("❌ [StripeService] StripeException: ${e.error}");

      if (e.error.code == FailureCode.Canceled) {
        print("🚫 [StripeService] Payment cancelled by user");
        onFailure("Payment cancelled");
      } else {
        print("💥 [StripeService] Stripe error: ${e.error.message}");
        onFailure(e.error.message ?? "Payment failed");
      }
    } catch (e) {
      print("💥 [StripeService] General error: $e");
      onFailure("Payment error: $e");
    }
  }

  // Backend API call માટે payment intent create કરવા
  Future<Map<String, dynamic>?> createPaymentIntent({
    required String amount,
    required String currency,
    required String coinPlanId,
  }) async {
    try {
      print("🔍 [API] Creating payment intent via backend...");

      // Convert amount to cents (Stripe expects amount in smallest currency unit)
      final amountInCents = (double.parse(amount) * 100).toInt();

      print("💰 [API] Amount in cents: $amountInCents");

      // તમારા backend API endpoint
      final response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"), // API endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Preference.accessToken}', // જો auth જરૂરી હોય
        },
        body: jsonEncode({
          'amount': amountInCents,
          'currency': currency.toLowerCase(),
          'coin_plan_id': coinPlanId,
          'user_id': Preference.userId,
        }),
      );

      print("📡 [API] Response status: ${response.statusCode}");
      print("📡 [API] Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("✅ [API] Payment intent created successfully");
        return responseData;
      } else {
        print("❌ [API] Failed to create payment intent: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("💥 [API] Error creating payment intent: $e");
      return null;
    }
  }
}

// Alternative simple test method
class StripeServiceTest {
  static Future<void> testStripeSheet() async {
    try {
      print("🧪 [TEST] Testing Stripe payment sheet...");

      // Test માટે dummy payment intent
      const testClientSecret = "pi_test_1234567890_secret_abcdefghijk";

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: testClientSecret,
          merchantDisplayName: 'Test Merchant',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      print("✅ [TEST] Stripe sheet test successful");
    } catch (e) {
      print("❌ [TEST] Stripe sheet test failed: $e");
    }
  }
}*/
