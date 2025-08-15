import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/ads/google_reward_ad.dart';
import 'package:story_box/ui/earn_reward_page/view/earn_reward_view.dart';
import 'package:story_box/ui/home_page/view/home_view.dart';
import 'package:story_box/ui/login_page/model/login_user_model.dart';
import 'package:story_box/ui/my_list/view/my_list_view.dart';
import 'package:story_box/ui/profile_page/api/profile_api.dart';
import 'package:story_box/ui/profile_page/view/profile_view.dart';
import 'package:story_box/ui/reels_page/view/reels_view.dart';
import 'package:story_box/ui/refill/view/store_view.dart';
import 'package:story_box/utils/constant.dart';

class BottomBarController extends GetxController {
  int selectedTabIndex = 0;
  PageController pageController = PageController();
  LoginUserModel? loginUserModel;

  List bottomBarPages = [
    const HomeViewPage(),
    const ReelsView(),
    const MyListViewPage(
      isShowArrow: false,
    ),
    const EranRewardView(),
    const ProfileViewPage(),
  ];

  void onChangeBottomBar(int index) {
    if (index != selectedTabIndex) {
      selectedTabIndex = index;
      update([Constant.idOnChangeBottomBar, Constant.idBottomBar]);
    }
  }

  @override
  void onInit() {
    log("INIT ::");
    GoogleRewardAd.loadAd();
    profileApiCall();
    super.onInit();
  }

  Future<void> profileApiCall() async {
    loginUserModel = await ProfileApi.callApi();
    print("call bottombar api");
  }
}
