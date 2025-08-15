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

class EpisodeUnlockView extends StatelessWidget {
  const EpisodeUnlockView({super.key});

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
          EnumLocal.episodesUnlocked.name.tr,
          style: AppFontStyle.styleW600(AppColor.colorWhite, 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: GetBuilder<WalletController>(
          id: 'episodeUnlock',
          builder: (logic) {
            return SingleChildScrollView(
              controller: logic.scrollController,
              child: Column(
                children: [
                  logic.isEpisodeUnlockLoading
                      ? const TransactionHistoryShimmer()
                      : logic.episodeUnlock.isEmpty
                          ? Center(
                              child: NoDataWidget(text: EnumLocal.youDontHaveAnyEpisodesOnUnlockYet.name.tr)
                                  .paddingOnly(top: Get.height * .25))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: logic.episodeUnlock.length,
                              itemBuilder: (context, index) {
                                final item = logic.episodeUnlock[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 22),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name ?? '',
                                            style: AppFontStyle.styleW600(AppColor.colorWhite, 16),
                                          ),
                                          2.height,
                                          Text(
                                            '${EnumLocal.episode.name.tr} ${item.episodeNumber ?? 0}',
                                            style: AppFontStyle.styleW500(AppColor.colorIconGrey, 12),
                                          ),
                                          2.height,
                                          Text(
                                            item.date ?? '',
                                            style: AppFontStyle.styleW500(AppColor.colorIconGrey, 12),
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
                  logic.isEpisodeUnlockLoading1 == true
                      ? const CircularProgressIndicator(
                          color: AppColor.primaryColor,
                        ).paddingOnly(bottom: 7)
                      : const SizedBox(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
