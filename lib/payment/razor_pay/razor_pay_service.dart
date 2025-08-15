import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/utils.dart';

class RazorPayService {
  static late Razorpay razorPay;
  static late String razorKeys;
  Callback onComplete = () {};

  void init({
    required String razorKey,
    required Callback callback,
  }) {
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    razorKeys = razorKey;
    onComplete = () => callback.call();
  }

  Future handlePaymentSuccess(PaymentSuccessResponse response) async => onComplete();

  void razorPayCheckout(num amount) async {
    debugPrint("Payment Amount => $amount");
    var options = {
      'key': razorKeys,
      'amount': amount,
      'name': 'Ghar Cinema',
      'theme.color': '#ed3a57',
      'description': 'Ghar Cinema',
      'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
      'currency': Constant.currencyCode,
      'prefill': {'contact': "Your Contact", 'email': "Your Email"},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint("Razor Payment Error => ${e.toString()}");
    }
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Utils.showToast(Get.context!, response.message ?? "");
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Utils.showToast(Get.context!, "External wallet: ${response.walletName!}");
  }
}
