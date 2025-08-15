// ignore_for_file: must_be_immutable
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:story_box/main.dart';
import 'package:story_box/ui/profile_page/view/delete_account_view.dart';
import 'package:story_box/ui/setting_view_page/controller/setting_controller.dart';
import 'package:story_box/ui/setting_view_page/widget/setting_widget.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/custom_dialog.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/preference.dart';

class SettingViewPage extends StatelessWidget {
  SettingViewPage({super.key});

  final controller = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      appBar: AppBar(
        backgroundColor: AppColor.colorBlack,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            color: AppColor.transparent,
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColor.colorWhite,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          EnumLocal.setting.name.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColor.bgGreyColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  SettingItemViewWidget(
                    onTap: () {
                      controller.launchUrlLink(Constant.termsOfUsePolicyLink);
                    },
                    text: EnumLocal.termsOfService.name.tr,
                  ),
                  Divider(
                    color: AppColor.greyColor.withOpacity(0.1),
                  ),
                  SettingItemViewWidget(
                    onTap: () {
                      controller.launchUrlLink(Constant.privacyPolicyLink);
                    },
                    text: EnumLocal.privacyPolicy.name.tr,
                  ),
                  Divider(
                    color: AppColor.greyColor.withOpacity(0.4),
                  ),
                  SettingItemViewWidget(
                    onTap: () async {
                      log("${Preference.userId} ");
                      Get.to(() => const DeleteAccountView());
                    },
                    text: EnumLocal.deleteAccount.name.tr,
                  ),
                  Divider(
                    color: AppColor.greyColor.withOpacity(0.4),
                  ),
                  SettingItemViewWidget(
                    onTap: () {
                      _showRatingDialog(context);
                    },
                    text: EnumLocal.rateUs.name.tr,
                  ),
                  8.height,
                ],
              ),
            ),
          ),
          10.height,
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomDialog(
                    text: EnumLocal.areYouSureWantToLogout.name.tr,
                    buttonText: EnumLocal.logout.name.tr,
                    onTap: () {
                      controller.onLogOut();
                    },
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: const Color(0xff454446),
              minimumSize: Size(Get.width, 50),
            ),
            child: Text(
              EnumLocal.signOut.name.tr,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ).paddingAll(16),
        ],
      ),
    );
  }

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'com.incodes.storybox',
    appStoreIdentifier: '1491556149',
  );

  void _showRatingDialog(BuildContext context) async {
    await rateMyApp.showRateDialog(
      context,
      title: EnumLocal.rateThisApp.name.tr,
      message: EnumLocal.ifYouLikeThisApp.name.tr,
      rateButton: EnumLocal.rate.name.tr,
      noButton: EnumLocal.noThanks.name.tr,
      laterButton: EnumLocal.maybeLater.name.tr,
      listener: (button) {
        switch (button) {
          case RateMyAppDialogButton.rate:
            log('Clicked on "Rate".');
            break;
          case RateMyAppDialogButton.later:
            log('Clicked on "Later".');
            break;
          case RateMyAppDialogButton.no:
            log('Clicked on "No".');
            break;
        }
        return true;
      },
      ignoreNativeDialog: Platform.isAndroid,
      dialogStyle: const DialogStyle(
          titleAlign: TextAlign.center, titleStyle: TextStyle(fontSize: 22), messageStyle: TextStyle(fontSize: 18)),
      onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
    );
  }
}
