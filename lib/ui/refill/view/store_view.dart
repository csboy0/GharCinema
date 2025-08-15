// ignore_for_file: must_be_immutable
import 'dart:developer';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:story_box/main.dart';
import 'package:story_box/payment/controller/payment_controller.dart';
import 'package:story_box/payment/flutter_wave/flutter_wave_service.dart';
import 'package:story_box/payment/in_app_purchase/iap_callback.dart';
import 'package:story_box/payment/in_app_purchase/in_app_purchase_helper.dart';
import 'package:story_box/payment/razor_pay/razor_pay_service.dart';
import 'package:story_box/payment/view/payment_gateway_list_page.dart';
import 'package:story_box/shimmer/my_subscription_shimmer.dart';
import 'package:story_box/shimmer/refill_grid_shimmer.dart';
import 'package:story_box/shimmer/vip_plan_shimmer.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/refill/controller/refill_controller.dart';
import 'package:story_box/ui/refill/model/coin_plan.dart';
import 'package:story_box/ui/refill/model/vip_plan.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/dummy_data.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class StoreView extends StatelessWidget {
  StoreView({super.key});

  final controller = Get.put(RefillController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      body: SingleChildScrollView(
        child: GetBuilder<RefillController>(
            id: 'vipPlan',
            builder: (context) {
              return Column(
                children: [
                  Container(
                    height: 80,
                    padding:
                        const EdgeInsets.only(right: 20, top: 16, bottom: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            AppColor.colorPrimary.withOpacity(0.15),
                            AppColor.colorPrimary.withOpacity(0.1),
                            AppColor.colorBlack.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 50,
                            width: 50,
                            color: Colors.transparent,
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            print("back..................");
                            Get.back();
                          },
                        ),
                        const Spacer(),
                        Text(
                          EnumLocal.store.name.tr,
                          style:
                              AppFontStyle.styleW500(AppColor.colorWhite, 20),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColor.colorTextDarkGrey.withOpacity(.2),
                          ),
                          child: Text(
                            EnumLocal.restore.name.tr,
                            style: AppFontStyle.styleW400(
                                AppColor.colorTextDarkGrey, 12),
                          ),
                        )
                      ],
                    ).paddingOnly(top: 20),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, bottom: 16, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColor.colorIconGrey.withOpacity(.2),
                            ),
                            gradient: LinearGradient(
                                colors: [
                                  AppColor.colorPrimary.withOpacity(0.04),
                                  AppColor.colorPrimary.withOpacity(0.01),
                                  // AppColor.colorBlack.withOpacity(0.1),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(AppAsset.coin,
                                      width: 22, height: 22),
                                  6.width,
                                  Text(
                                    EnumLocal.balance.name.tr,
                                    style: AppFontStyle.styleW600(
                                        AppColor.greyColor, 20),
                                  ),
                                  const Spacer(),
                                  Obx(
                                    () => Text(
                                      '${Preference.userCoin}',
                                      style: AppFontStyle.styleW500(
                                          AppColor.colorSecondaryTextGrey, 22),
                                    ),
                                  ),
                                  6.width,
                                  Text(
                                    EnumLocal.coin.name.tr,
                                    style: AppFontStyle.styleW400(
                                        AppColor.greyColor, 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).paddingOnly(right: 16),
                        if (Preference.isVip == false) 20.height,
                        Preference.isVip == false
                            ? GetBuilder<RefillController>(
                                id: 'vipPlan',
                                builder: (controller) {
                                  return controller.isLoadingVipPlan
                                      ? const VipPlanShimmer(
                                          isShow: true,
                                        )
                                      : SizedBox(
                                          height: 90,
                                          child: ListView.builder(
                                            itemCount:
                                                controller.vipPlan.length,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                child: VipPlanCard(
                                                    vipPlan: controller
                                                        .vipPlan[index]),
                                              );
                                            },
                                          ),
                                        );
                                },
                              )
                            : GetBuilder<HomeController>(
                                id: "userProfile",
                                builder: (logic) {
                                  return logic.loginUserModel?.user
                                              ?.vipPlanStartDate ==
                                          null
                                      ? const MySubscriptionShimmer()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              EnumLocal.mySubscription.name.tr,
                                              style: AppFontStyle.styleW500(
                                                  AppColor.greyColor, 20),
                                            ).paddingOnly(top: 16),
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.asset(
                                                    AppAsset.subscriptionBg,
                                                    height: 200,
                                                    width: Get.width,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ).paddingOnly(
                                                    right: 16, top: 16),
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 22,
                                                      right: 32,
                                                      left: 16,
                                                      bottom: 22,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          AppAsset.vipCrown,
                                                          scale: 4,
                                                        ),
                                                        Text(
                                                          logic
                                                                      .loginUserModel
                                                                      ?.user
                                                                      ?.currentPlan
                                                                      ?.validityType ==
                                                                  'month'
                                                              ? EnumLocal
                                                                  .monthlyVIP
                                                                  .name
                                                                  .tr
                                                              : logic
                                                                          .loginUserModel
                                                                          ?.user
                                                                          ?.currentPlan
                                                                          ?.validityType ==
                                                                      'year'
                                                                  ? EnumLocal
                                                                      .yearlyVIP
                                                                      .name
                                                                      .tr
                                                                  : EnumLocal
                                                                      .weeklyVIP
                                                                      .name
                                                                      .tr,
                                                          style: AppFontStyle
                                                              .styleW900(
                                                                  AppColor
                                                                      .brownColor,
                                                                  22),
                                                        ),
                                                        Text(
                                                          '${EnumLocal.unlockAllSeriesFor.name.tr} ${logic.loginUserModel?.user?.currentPlan?.validity} ${logic.loginUserModel?.user?.currentPlan?.validityType}',
                                                          style: AppFontStyle
                                                              .styleW600(
                                                                  AppColor
                                                                      .brownColor
                                                                      .withOpacity(
                                                                          .7),
                                                                  14),
                                                        ),
                                                        10.height,
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              EnumLocal
                                                                  .dateOfPurchase
                                                                  .name
                                                                  .tr,
                                                              style: AppFontStyle
                                                                  .styleW600(
                                                                      AppColor
                                                                          .brownColor
                                                                          .withOpacity(
                                                                              .7),
                                                                      16),
                                                            ),
                                                            Text(
                                                              Utils.formatDate(logic
                                                                      .loginUserModel
                                                                      ?.user
                                                                      ?.vipPlanStartDate ??
                                                                  ''),
                                                              style: AppFontStyle
                                                                  .styleW800(
                                                                      AppColor
                                                                          .brownColor,
                                                                      16),
                                                            ),
                                                          ],
                                                        ),
                                                        4.height,
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              EnumLocal
                                                                  .planDuration
                                                                  .name
                                                                  .tr,
                                                              style: AppFontStyle
                                                                  .styleW600(
                                                                      AppColor
                                                                          .brownColor
                                                                          .withOpacity(
                                                                              .7),
                                                                      16),
                                                            ),
                                                            Text(
                                                              calculateDateDifference(logic
                                                                      .loginUserModel
                                                                      ?.user
                                                                      ?.vipPlanEndDate ??
                                                                  ''),
                                                              style: AppFontStyle
                                                                  .styleW800(
                                                                      AppColor
                                                                          .brownColor,
                                                                      16),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                },
                              ),
                        20.height,
                        Text(
                          EnumLocal.reFill.name.tr,
                          style: AppFontStyle.styleW500(AppColor.greyColor, 20),
                        ).paddingOnly(right: 16),
                        12.height,
                        GetBuilder<RefillController>(
                            id: "coinPlan",
                            builder: (controller) {
                              return controller.isLoadingCoinPlan
                                  ? const RefillGridShimmer()
                                  : GridView.builder(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        childAspectRatio: 1.7,
                                      ),
                                      itemCount: controller.coinPlan.length,
                                      itemBuilder: (context, index) {
                                        final coinPlan =
                                            controller.coinPlan[index];
                                        return RefillCard(
                                          coinPlan: coinPlan,
                                          isSelected:
                                              controller.selectedCoinPlan ==
                                                  coinPlan,
                                          onTap: () async {
                                            final refillController =
                                                Get.find<RefillController>();

                                            String productKey = refillController
                                                    .selectedCoinPlan
                                                    ?.productKey ??
                                                "";

                                            controller.selectCoinPlan(index);

                                            final enabledMethods = {
                                              'stripe': Constant.stripeSwitch,
                                              'inApp':
                                                  Constant.googlePlaySwitch ||
                                                      Platform.isIOS,
                                              'razorpay':
                                                  Constant.razorPaySwitch,
                                              'flutterwave':
                                                  Constant.flutterWaveSwitch,
                                            };

                                            final enabledList = enabledMethods
                                                .entries
                                                .where((e) => e.value)
                                                .toList();

                                            if (enabledList.length == 1) {
                                              // Only one method enabled — trigger it directly
                                              final method =
                                                  enabledList.first.key;
                                              final refillController =
                                                  Get.find<RefillController>();
                                              final paymentController =
                                                  Get.put(PaymentController());

                                              switch (method) {
                                                case 'stripe':
                                                  paymentController
                                                      .makePaymentViaStripe();
                                                  break;

                                                // case 'inApp':
                                                //   PaymentGatewayListPage().onInAppPurchase(); // static call
                                                //   break;

                                                case 'razorpay':
                                                  RazorPayService().init(
                                                    razorKey:
                                                        Constant.razorSecretKey,
                                                    callback: () async {
                                                      Utils.showLog(
                                                          "Razorpay Payment Successfully");
                                                    },
                                                  );

                                                  String amount =
                                                      refillController
                                                              .selectedCoinPlan
                                                              ?.offerPrice
                                                              .toString() ??
                                                          '0';

                                                  int amountInCents =
                                                      ((double.tryParse(
                                                                      amount) ??
                                                                  0) *
                                                              100)
                                                          .toInt();
                                                  print(
                                                      "amountInCents::::::::::::::::::::::${amountInCents}");

                                                  Future.delayed(1.seconds, () {
                                                    RazorPayService()
                                                        .razorPayCheckout(
                                                            amountInCents);
                                                  });
                                                  break;

                                                case 'flutterwave':
                                                  String amount =
                                                      refillController
                                                              .selectedCoinPlan
                                                              ?.offerPrice
                                                              .toString() ??
                                                          '0';

                                                  int amountInCents =
                                                      ((double.tryParse(
                                                                      amount) ??
                                                                  0) *
                                                              100)
                                                          .toInt();
                                                  FlutterWaveService.init(
                                                    amount: amountInCents
                                                        .toString(),
                                                    onPaymentComplete:
                                                        () async {
                                                      Utils.showLog(
                                                          "Flutter Wave Payment Successfully");

                                                      Utils.showToast(
                                                          Get.context!,
                                                          "Payment Successfully");

                                                      Get.back(); // Stop Loading...
                                                      // if (isSuccess != null) {
                                                      //   Get.close(2);
                                                      // }
                                                    },
                                                  );
                                                  break;

                                                case 'inApp':
                                                  await controller
                                                      .handleCoinPlanInAppPurchase();

                                                  break;
                                              }
                                            } else {
                                              // Multiple methods enabled — show bottom sheet
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                // clipBehavior: Clip.antiAlias,
                                                context: context,
                                                backgroundColor:
                                                    AppColor.bgGreyColor,
                                                builder: (context) {
                                                  return PaymentGatewayListPage();
                                                },
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ).paddingOnly(right: 16);
                            }),
                        20.height,
                        Text(
                          "Tips:",
                          style:
                              AppFontStyle.styleW500(AppColor.greyColor, 14.5),
                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: DummyData.tips.length,
                          itemBuilder: (context, index) => Text(
                            DummyData.tips[index],
                            style: AppFontStyle.styleW500(
                                AppColor.greyColor, 14.5),
                          ),
                        ).paddingOnly(right: 16),
                        GestureDetector(
                          onTap: () {
                            print("copy");

                            FlutterClipboard.copy(Constant.contactEmail)
                                .then((_) {
                              Utils.showToast(
                                  Get.context!, Constant.contactEmail);
                            });
                          },
                          child: Container(
                            color: AppColor.transparent,
                            child: Text(
                              Constant.contactEmail,
                              style: AppFontStyle.styleW700(
                                  AppColor.primaryColor, 14.5),
                            ).paddingOnly(left: 15),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  String calculateDateDifference(String? endDateString) {
    if (endDateString == null || endDateString.isEmpty) {
      return "No VIP plan"; // Handle null or empty end date
    }

    // Parse the end date string to a DateTime object
    DateTime? endDate;
    try {
      endDate = DateTime.parse(endDateString);
    } catch (e) {
      return "Invalid date"; // Handle invalid date format
    }

    // Get the current date
    DateTime currentDate = DateTime.now();

    if (endDate.isBefore(currentDate)) {
      return "Plan expired"; // Handle expired plan
    }

    // Calculate the difference in days
    Duration difference = endDate.difference(currentDate);
    int totalDays = difference.inDays;

    // Convert the difference to weeks, months, and years
    if (totalDays >= 365) {
      int years = totalDays ~/ 365;
      return "$years year${years > 1 ? 's' : ''} left";
    } else if (totalDays >= 30) {
      int months = totalDays ~/ 30;
      return "$months month${months > 1 ? 's' : ''} left";
    } else if (totalDays >= 7) {
      int weeks = totalDays ~/ 7;
      return "$weeks week${weeks > 1 ? 's' : ''} left";
    } else {
      return "$totalDays day${totalDays > 1 ? 's' : ''} left";
    }
  }
}

class VipPlanCard extends StatelessWidget {
  VipPlanCard({super.key, required this.vipPlan});

  final VipPlan vipPlan;
  final refillController = Get.find<RefillController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onInAppPurchase();
      },
      child: SizedBox(
        height: 80,
        width: Get.width - 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                AppAsset.vipPlanBg,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppAsset.vipCrown,
                  scale: 4,
                ),
                4.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      vipPlan.validityType == 'month'
                          ? EnumLocal.monthlyVIP.name.tr
                          : vipPlan.validityType == 'year'
                              ? EnumLocal.yearlyVIP.name.tr
                              : EnumLocal.weeklyVIP.name.tr,
                      style: AppFontStyle.styleW700(AppColor.brownColor, 18),
                    ),
                    Text(
                      '${EnumLocal.unlockAllSeriesFor.name.tr} ${vipPlan.validity} \n${vipPlan.validityType}',
                      style: AppFontStyle.styleW600(
                          AppColor.brownColor.withOpacity(.7), 12),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    onInAppPurchase();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xff1d1311),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Text(
                        "${Constant.currencyIcon} ${vipPlan.price?.toStringAsFixed(2)}",
                        style: AppFontStyle.styleW700(
                            AppColor.colorLightYellow, 16),
                      ),
                    ),
                  ).paddingOnly(right: 16),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  PaymentController paymentController = Get.put(PaymentController());

  Future<void> onInAppPurchase() async {
    try {
      String productKey = vipPlan.productKey ?? "";
      if (productKey.isEmpty) {
        log("Product key is empty for VIP plan");
        return;
      }

      List<String> kProductIds = <String>[productKey];

      // Initialize with custom callback
      InAppPurchaseHelper().init(
        paymentType: "In App Purchase",
        userId: Preference.userId,
        productKey: kProductIds,
        rupee: vipPlan.price?.toDouble() ?? 0.0,
      );

      // Setup purchase listener with callback
      InAppPurchaseHelper().setupPurchaseListener(VipPlanIAPCallback(
        vipPlanId: vipPlan.sId ?? '',
        refillController: refillController,
      ));

      log("Initialization completed");

      // Wait for store info to load
      bool storeInitialized = await InAppPurchaseHelper().initStoreInfo();

      if (!storeInitialized) {
        log("Store initialization failed");
        return;
      }

      log("vipPlan.productKey :: $productKey");

      // Check if user already owns this subscription
      Map<String, PurchaseDetails> existingPurchases =
          InAppPurchaseHelper().getPurchases();

      if (existingPurchases.containsKey(productKey)) {
        log("User already owns this subscription");

        // Check if it's still active
        PurchaseDetails existingPurchase = existingPurchases[productKey]!;

        // For subscriptions, we should verify if it's still active
        bool isActive = await _checkSubscriptionActive(existingPurchase);

        if (isActive) {
          // Subscription is active, no need to purchase again
          Utils.showToast(
              Get.context!, "You already have an active subscription!");
          return;
        } else {
          // Subscription expired, proceed with purchase
          log("Existing subscription expired, proceeding with new purchase");
        }
      }

      ProductDetails? product =
          InAppPurchaseHelper().getProductDetail(productKey);
      if (product != null) {
        log("Product details retrieved successfully for :: ${product.id}");
        await InAppPurchaseHelper().buyProduct(product);
      } else {
        log("Product is null for :: $productKey");
      }
    } catch (e) {
      log("Error in onInAppPurchase: $e");
      Utils.showToast(Get.context!, "Error initiating purchase");
    }
  }

  Future<bool> _checkSubscriptionActive(PurchaseDetails purchase) async {
    // Implement your logic to check if subscription is still active
    // This could involve checking with your backend or parsing the purchase date

    // For now, return true if the purchase exists
    // In production, you should implement proper subscription validation
    return true;
  }
}

// Custom callback class for VIP plan purchases
class VipPlanIAPCallback extends IAPCallback {
  final String vipPlanId;
  final RefillController refillController;

  VipPlanIAPCallback({
    required this.vipPlanId,
    required this.refillController,
  });

  @override
  void onSuccessPurchase(PurchaseDetails product) {
    log("VIP Plan purchase successful: ${product.productID}");

    // Call the API to record VIP plan history
    refillController.recordVipPlanHistoryApi("subscription", vipPlanId);

    // Show success message
    Utils.showToast(Get.context!, "VIP subscription activated successfully!");

    // Navigate back or refresh UI if needed
    Get.back();
  }

  @override
  void onBillingError(dynamic error) {
    log("VIP Plan purchase error: $error");
    Utils.showToast(Get.context!, "Purchase failed. Please try again.");
  }

  @override
  void onPending(PurchaseDetails product) {
    log("VIP Plan purchase pending: ${product.productID}");
    Utils.showToast(Get.context!, "Purchase is pending...");
  }
}

class RefillCard extends StatelessWidget {
  final CoinPlan coinPlan;
  final bool isSelected;
  final VoidCallback onTap;

  const RefillCard(
      {super.key,
      required this.coinPlan,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    double percentageBonus =
        ((coinPlan.bonusCoin ?? 0) / (coinPlan.coin ?? 1)) * 100;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppColor.colorButtonPink
                    : AppColor.colorIconGrey.withOpacity(.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                4.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${coinPlan.coin}',
                      style: AppFontStyle.styleW700(
                          AppColor.colorSecondaryTextGrey, 32),
                    ),
                    Text(
                      ' +${coinPlan.bonusCoin}',
                      style: AppFontStyle.styleW600(AppColor.greyColor, 14),
                    ),
                  ],
                ),
                Text(
                  EnumLocal.coins.name.tr,
                  style: AppFontStyle.styleW400(AppColor.greyColor, 14.5),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3.2),
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.colorButtonPink.withOpacity(.1)
                        : const Color(0xff131213),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${Constant.currencyIcon} ${coinPlan.offerPrice?.toStringAsFixed(2)}',
                        style: AppFontStyle.styleW600(
                            AppColor.colorSecondaryTextGrey, 16),
                      ),
                      7.width,
                      Text(
                          '${Constant.currencyIcon} ${coinPlan.price?.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColor.greyColor,
                            color: AppColor.greyColor,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (coinPlan.offerPrice != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: const BoxDecoration(
                color: AppColor.colorButtonPink,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Text(
                "${percentageBonus.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
