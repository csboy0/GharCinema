import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/profile_page/controller/profile_controller.dart';
import 'package:story_box/ui/profile_page/widget/profile_widget.dart';
import 'package:story_box/ui/refill/view/store_view.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';

class ProfileViewPage extends StatelessWidget {
  const ProfileViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      body: SingleChildScrollView(
        child: GetBuilder<ProfileController>(
          id: "userProfile",
          builder: (profileController) {
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColor.colorPrimary.withOpacity(0.15),
                            AppColor.colorPrimary.withOpacity(0.1),
                            AppColor.colorBlack.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 12, right: 8, top: 34),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 55,
                            width: 55,
                            child: Preference.shared
                                            .getString(Preference.profilePic) !=
                                        null &&
                                    Preference.shared
                                        .getString(Preference.profilePic)!
                                        .isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl: Preference.shared.getString(
                                              Preference.profilePic) ??
                                          '',
                                      placeholder: (context, url) => Center(
                                        child: Image.asset(
                                          AppAsset.placeHolderImage,
                                          color: AppColor.colorIconGrey,
                                        ).paddingAll(16),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error,
                                              color: Colors.red),
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                    ),
                                  )
                                : Image.asset(AppAsset.icProfileMen),
                          ),
                          10.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width * 0.6,
                                child: Text(
                                  Preference.shared
                                          .getString(Preference.name) ??
                                      '',
                                  style: AppFontStyle.styleW700(
                                      AppColor.colorWhite, 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  if (Preference.shared
                                          .getInt(Preference.loginType) ==
                                      2) ...{
                                    Image.asset(
                                      AppAsset.icGoogle,
                                      scale: 7,
                                    ),
                                  } else if (Preference.shared
                                          .getInt(Preference.loginType) ==
                                      4) ...{
                                    Image.asset(
                                      AppAsset.icApple,
                                      scale: 7,
                                    ),
                                  } else if (Preference.shared
                                          .getInt(Preference.loginType) ==
                                      3) ...{
                                    const SizedBox.shrink()
                                  },
                                  if (Preference.shared
                                          .getInt(Preference.loginType) !=
                                      3)
                                    4.width,
                                  Text(
                                    "UID: ${Preference.shared.getString(Preference.uniqueId)}",
                                    style: AppFontStyle.styleW700(
                                        AppColor.grey, 14),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),

                18.height,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: AppColor.colorWhite.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                EnumLocal.myWallet.name.tr,
                                style: AppFontStyle.styleW500(
                                    AppColor.colorWhite, 20),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.wallet,
                                    arguments: {
                                      "coin": profileController
                                              .loginUserModel?.user?.coin ??
                                          0,
                                      "rewardCoin": profileController
                                              .loginUserModel
                                              ?.user
                                              ?.rewardCoin ??
                                          0
                                    },
                                  );
                                  // Get.to(
                                  //   () => MyWalletPage(
                                  //     coin: profileController.user?.coin ?? 0,
                                  //     rewardCoin: profileController.user?.rewardCoin ?? 0,
                                  //   ),
                                  // );
                                },
                                child: Text(
                                  EnumLocal.details.name.tr,
                                  style: AppFontStyle.styleW400(
                                      AppColor.greyColor, 16),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: AppColor.greyColor.withOpacity(0.7),
                                size: 18,
                              )
                            ],
                          ),
                          5.height,
                          Divider(
                            color: AppColor.greyColor.withOpacity(0.4),
                          ),
                          5.height,
                          Row(
                            children: [
                              Image.asset(AppAsset.coin, width: 24, height: 24),
                              6.width,
                              Text(
                                '${Preference.userCoin}',
                                style: AppFontStyle.styleW600(
                                    AppColor.colorWhite, 22),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => StoreView())?.then(
                                    (value) =>
                                        profileController.profileDataGet(),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(colors: [
                                        AppColor.colorPrimary,
                                        AppColor.colorSecondary
                                      ])),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0, vertical: 4),
                                    child: Text(
                                      EnumLocal.reFill.name.tr,
                                      style: AppFontStyle.styleW700(
                                          AppColor.colorWhite, 18),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                25.height,
                ProfileItemViewWidget(
                  imagePath: AppAsset.icEarnRewards,
                  text: EnumLocal.earnRewards.name.tr,
                  imageHeight: 22,
                  onTap: () {
                    Get.toNamed(AppRoutes.rewards);
                  },
                ),
                ProfileItemViewWidget(
                  imagePath: AppAsset.icMyListProfile,
                  text: EnumLocal.myList.name.tr,
                  imageHeight: 22,
                  onTap: () {
                    // Define the action on tap
                    Get.toNamed(
                      AppRoutes.myList,
                      arguments: {
                        "isShowArrow": true,
                      },
                    );
                  },
                ),
                // ProfileItemViewWidget(
                //   imagePath: AppAsset.icInvitationCode,
                //   text: EnumLocal.invitationCode.name.tr,
                //   imageHeight: 22,
                //   onTap: () {
                //     // Define the action on tap
                //     log('Earn Rewards tapped');
                //   },
                // ),
                // ProfileItemViewWidget(
                //   imagePath: AppAsset.icCoupons,
                //   text: EnumLocal.myCoupons.name.tr,
                //   imageHeight: 22,
                //   onTap: () {
                //     // Define the action on tap
                //     log('Earn Rewards tapped');
                //   },
                // ),
                // ProfileItemViewWidget(
                //   imagePath: AppAsset.icFeedback,
                //   text: EnumLocal.feedback.name.tr,
                //   imageHeight: 22,
                //   onTap: () {
                //     // Define the action on tap
                //     log('Earn Rewards tapped');
                //   },
                // ),
                ProfileItemViewWidget(
                  imagePath: AppAsset.icLanguage,
                  text: EnumLocal.language.name.tr,
                  imageHeight: 22,
                  onTap: () {
                    // Define the action on tap
                    Get.toNamed(AppRoutes.language);
                  },
                ),
                ProfileItemViewWidget(
                  imagePath: AppAsset.icSetting,
                  text: EnumLocal.setting.name.tr,
                  imageHeight: 22,
                  onTap: () {
                    // Define the action on tap

                    Get.toNamed(AppRoutes.setting);
                    log('Earn Rewards tapped');
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
