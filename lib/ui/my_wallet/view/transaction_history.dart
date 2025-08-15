import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/custom_widget/no_data_widget.dart';
import 'package:story_box/main.dart';
import 'package:story_box/shimmer/transaction_history_shimmer.dart';
import 'package:story_box/ui/my_wallet/controller/wallet_controller/wallet_controller.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/utils.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      appBar: AppBar(
        backgroundColor: AppColor.colorBlack,
        centerTitle: true,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () => Get.back(),
        ),
        title: Text(
          EnumLocal.transactionHistory.name.tr,
          style: AppFontStyle.styleW600(AppColor.colorWhite, 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<WalletController>(
                id: 'coinPlanHistoryList',
                builder: (walletController) {
                  return walletController.isCoinPlanLoading
                      ? const TransactionHistoryShimmer()
                      : walletController.transactionHistoryList.isNotEmpty
                          ? Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: walletController.transactionHistoryList.length,
                                  itemBuilder: (context, index) {
                                    final item = walletController.transactionHistoryList[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 22),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.type == 1
                                                    ? EnumLocal.dailyCheckInReward.name.tr
                                                    : item.type == 2
                                                        ? EnumLocal.asViewReward.name.tr
                                                        : item.type == 3
                                                            ? EnumLocal.loginReward.name.tr
                                                            : item.type == 4
                                                                ? EnumLocal.referralReward.name.tr
                                                                : item.type == 5
                                                                    ? EnumLocal.coinPlanSubscription.name.tr
                                                                    : item.type == 6
                                                                        ? EnumLocal.unlockVideo.name.tr
                                                                        : item.type == 7
                                                                            ? EnumLocal.autoUnlockVideo.name.tr
                                                                            : "",
                                                style: AppFontStyle.styleW600(AppColor.colorWhite, 16),
                                              ),
                                              6.height,
                                              Text(
                                                Utils.formatDate(item.createdAt ?? ''),
                                                style: AppFontStyle.styleW500(AppColor.colorTextGrey, 12),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${item.coin}',
                                                    style: AppFontStyle.styleW600(AppColor.colorWhite, 16),
                                                  ),
                                                  6.width,
                                                  Image.asset(AppAsset.coin, width: 24, height: 24),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                26.height,
                                Text(
                                  EnumLocal.thatsAllForNow.name.tr,
                                  style: AppFontStyle.styleW600(AppColor.greyColor, 14),
                                ),
                              ],
                            )
                          : Center(
                              child: NoDataWidget(text: EnumLocal.youDontHaveAnyTransactionsYet.name.tr)
                                  .paddingOnly(top: Get.height * .25));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
