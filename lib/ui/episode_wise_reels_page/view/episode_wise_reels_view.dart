import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/shimmer/reels_shimmer_ui.dart';
import 'package:story_box/ui/episode_wise_reels_page/controller/episode_wise_reels_controller.dart';
import 'package:story_box/ui/episode_wise_reels_page/widget/episode_wise_reels_widget.dart';
import 'package:story_box/utils/color.dart';

class EpisodeWiseReelsView extends GetView<EpisodeWiseReelsController> {
  const EpisodeWiseReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.preloadPageController = PreloadPageController(initialPage: Get.arguments["playIndex"] ?? 0);
    Timer(const Duration(milliseconds: 100), () {
      controller.onChangePage(Get.arguments["playIndex"] ?? 0);
    });

    if (Get.currentRoute == AppRoutes.episodeWiseReels) {
      controller.init();
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColor.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      body: GetBuilder<EpisodeWiseReelsController>(
        id: "onGetReels",
        builder: (controller) => controller.isLoadingReels
            ? const ReelsShimmerUi(
                isShowEpisode: true,
              )
            : RefreshIndicator(
                color: AppColor.colorBlack,
                onRefresh: () async {
                  await 400.milliseconds.delay();
                  await controller.init();
                },
                child: PreloadPageView.builder(
                  controller: controller.preloadPageController,
                  itemCount: controller.mainReels.length,
                  preloadPagesCount: 2,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (value) async {
                    ///TODO for pagination
                    // controller.onPagination(value);


                    controller.onChangePage(value);
                  },
                  itemBuilder: (context, index) {
                    return GetBuilder<EpisodeWiseReelsController>(
                      id: "onChangePage",
                      builder: (controller) => EpisodeWisePreviewReelsView(
                        index: index,
                        currentPageIndex: controller.currentPageIndex,
                      ),
                    );
                  },
                ),
              ),
      ),
      bottomNavigationBar: GetBuilder<EpisodeWiseReelsController>(
        id: "onPagination",
        builder: (controller) => Visibility(
          visible: controller.isPaginationLoading,
          child: const LinearProgressIndicator(color: AppColor.colorPrimary),
        ),
      ),
    );
  }
}
