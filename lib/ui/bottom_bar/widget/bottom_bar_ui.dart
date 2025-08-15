// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/ui/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:story_box/ui/reels_page/controller/reels_controller.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';

class BottomBarUi extends StatelessWidget {
    BottomBarUi({super.key});

  ReelsController reelsController = Get.put(ReelsController());
  @override
  Widget build(BuildContext context) {
    reelsController.init();
    return GetBuilder<BottomBarController>(
      id: Constant.idBottomBar,
      builder: (logic) {
        return BottomAppBar(
          padding: EdgeInsets.zero,
          height: Constant.bottomBarSize,
          color: AppColor.colorBlack,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    logic.onChangeBottomBar(0);
                    reelsController.init();
                  },
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Image.asset(
                      logic.selectedTabIndex == 0 ? AppAsset.icHomeSelected : AppAsset.icHome,
                      width: 26,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    logic.onChangeBottomBar(1);
                  },
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Image.asset(
                      logic.selectedTabIndex == 1 ? AppAsset.icReelsSelected : AppAsset.icReels,
                      width: 26,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    reelsController.init();
                    logic.onChangeBottomBar(2);
                  },
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Image.asset(
                      logic.selectedTabIndex == 2 ? AppAsset.icMyListSelected : AppAsset.icMyList,
                      width: 26,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    logic.onChangeBottomBar(3);
                  },
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Image.asset(
                      logic.selectedTabIndex == 3 ? AppAsset.icGiftSelected : AppAsset.icGift,
                      width: 26,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    logic.onChangeBottomBar(4);
                  },
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Image.asset(
                      logic.selectedTabIndex == 4 ? AppAsset.icProfileSelected : AppAsset.icProfile,
                      height: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
