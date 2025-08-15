import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:story_box/utils/utils.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:story_box/utils/constant.dart';

class FlutterWaveService {
  static Future<void> init(
      {required String amount, required Callback onPaymentComplete}) async {
    final Customer customer = Customer(
        name: "Flutter wave Developer",
        email: "customer@customer.com",
        phoneNumber: '8876543345');

    // Utils.showLog("Flutter Wave Id => ${Constant.flutterWaveId}");
    // final Flutterwave flutterWave = Flutterwave(
    //   // context: Get.context!,
    //   publicKey: Constant.flutterWaveId,
    //   currency: Constant.currencyCode,
    //   redirectUrl: "https://www.google.com/",
    //   txRef: DateTime.now().microsecond.toString(),
    //   amount: amount,
    //   customer: customer,
    //   paymentOptions: "ussd, card, barter, pay attitude",
    //   customization: Customization(title: "Heart Haven"),
    //   isTestMode: true,
    // );

    print("Constant.flutterWaveId${Constant.flutterWaveId}");
    final Flutterwave flutterWave = Flutterwave(
      // context: Get.context!,
      publicKey: Constant.flutterWaveId,
      currency: "USD",
      redirectUrl: "https://www.google.com/",
      txRef: DateTime.now().microsecondsSinceEpoch.toString(),
      amount:
          amount.isNotEmpty && double.tryParse(amount) != null ? amount : "1",
      customer: Customer(
        name: "Test User",
        email: "test@example.com",
        phoneNumber: "08012345678",
      ),
      paymentOptions: "card, ussd, barter, payattitude",
      customization: Customization(title: "Heart Haven"),
      isTestMode: true,
    );

    Utils.showLog("Flutter Wave Payment Finish");

    try {
      final ChargeResponse response = await flutterWave.charge(Get.context!);

      print("response.status${response.status}");
      if (response.status == "successful") {
        // Utils.showToast(Get.context!, "Payment Successfully");

        Fluttertoast.showToast(
            msg: "Payment Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black);
        Utils.showLog("Payment Successfully..................");
        onPaymentComplete.call();
      }

      // if (response.success == true) {
      //   onPaymentComplete.call();
      // }

      Utils.showLog("Flutter Wave Response => ${response.toString()}");
    } catch (e) {
      Utils.showLog("Flutterwave payment error: $e");
    }
  }
}
