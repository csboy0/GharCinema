import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:story_box/custom_widget/block_user_dialog.dart';
import 'package:story_box/shimmer/reels_shimmer_ui.dart';
import 'package:story_box/ui/profile_page/api/profile_api.dart';
import 'package:story_box/ui/reels_page/controller/reels_controller.dart';
import 'package:story_box/ui/reels_page/widget/reels_widget.dart';
import 'package:story_box/utils/color.dart';

class ReelsView extends GetView<ReelsController> {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    // if (Get.currentRoute == AppRoutes.bottomBarPage) {
    //   controller.init();
    // }

    controller.blockFunction();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColor.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      body: GetBuilder<ReelsController>(
        id: "onGetReels",
        builder: (controller) => controller.isLoadingReels
            ? const ReelsShimmerUi()
            : RefreshIndicator(
                color: AppColor.colorBlack,
                onRefresh: () async {
                  await 400.milliseconds.delay();
                  await controller.init();
                  // controller.loginUserModel = await ProfileApi.callApi();
                  // if (controller.loginUserModel?.message ==
                  //     "you are blocked by the admin.") {
                  //   showBlockedUserDialog();
                  //
                  //   return;
                  // }
                },
                child: PreloadPageView.builder(
                  controller: controller.preloadPageController,
                  itemCount: controller.mainReels.length,
                  preloadPagesCount: 4,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (value) async {
                    controller.onPagination(value);
                    controller.onChangePage(value);
                  },
                  itemBuilder: (context, index) {
                    return GetBuilder<ReelsController>(
                      id: "onChangePage",
                      builder: (controller) => PreviewReelsView(
                        index: index,
                        currentPageIndex: controller.currentPageIndex,
                      ),
                    );
                  },
                ),
              ),
      ),
      bottomNavigationBar: GetBuilder<ReelsController>(
        id: "onPagination",
        builder: (controller) => Visibility(
          visible: controller.isPaginationLoading,
          child: const LinearProgressIndicator(color: AppColor.colorPrimary),
        ),
      ),
    );
  }
}
