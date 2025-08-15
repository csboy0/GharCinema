import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:story_box/ads/google_reward_ad.dart';
import 'package:story_box/ui/episode_wise_reels_page/api/fetch_episode_wise_reels_api.dart';
import 'package:story_box/ui/episode_wise_reels_page/api/unlock_episodes_auto_api.dart';
import 'package:story_box/ui/episode_wise_reels_page/api/watch_ad_unlock_video_api.dart';
import 'package:story_box/ui/episode_wise_reels_page/api/watch_short_video_api.dart';
import 'package:story_box/ui/episode_wise_reels_page/model/fetch_episode_wise_reels_model.dart';
import 'package:story_box/ui/episode_wise_reels_page/model/view_ad_to_unlock_video_model.dart';
import 'package:story_box/ui/episode_wise_reels_page/widget/episode_wise_reels_widget.dart';
import 'package:story_box/ui/profile_page/controller/profile_controller.dart';
import 'package:story_box/ui/reels_page/api/video_view_api.dart';
import 'package:story_box/utils/custom_progress_dialog.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class EpisodeWiseReelsController extends GetxController {
  PreloadPageController preloadPageController = PreloadPageController();

  final profileController = Get.find<ProfileController>();

  int currentPageIndex = 0;
  bool isChecked = false;
  String? movieSeriesId;
  int? totalVideos;
  bool? isNavigateOnHome = false;

  bool isLoadingReels = false;
  bool isPaginationLoading = false;

  List<Videos> mainReels = [];
  FetchEpisodeWiseReelsModel? fetchEpisodeWiseReelsModel;
  ViewAdToUnlockVideoModel? viewAdToUnlockVideo;

  int? episodeUnlockAdsCount;

  bool isBottomSheetShown = false;
  bool hasOpenedBottomSheetOnce = false;

  Future<void> init() async {
    log("INIT ::::");
    if (movieSeriesId == null) {
      if (Get.arguments["movieSeriesId"] != null ||
          Get.arguments["totalVideos"] != null ||
          Get.arguments["isNavigateOnHome"] != null) {
        movieSeriesId = (Get.arguments["movieSeriesId"]);
        totalVideos = (Get.arguments["totalVideos"]);
        isNavigateOnHome = (Get.arguments["isNavigateOnHome"]);

        log("Movie series id :: $movieSeriesId");
        log("Total videos of movies :: $totalVideos");
        log("Is navigate on home :: $isNavigateOnHome");
      }
    }

    currentPageIndex = 0;
    mainReels.clear();
    isLoadingReels = true;

    update(["onGetReels"]);
    FetchEpisodeWiseReelsApi.startPagination = 0;
    await onGetReels();
    if (isNavigateOnHome == true) {
      if (!hasOpenedBottomSheetOnce) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          log("message::::::::>>>>>>>>Bottom Sheet has been shown once");

          log("message::::::::>>>>>>>>Bottom Sheet has been shown once");
          hasOpenedBottomSheetOnce = true; // Mark that the sheet has been shown
          Get.bottomSheet(const ShowAllEpisodeBottomSheet());
        });
      }
    }
    GoogleRewardAd.loadAd();
  }

  Future<void> onGetReels() async {
    fetchEpisodeWiseReelsModel = await FetchEpisodeWiseReelsApi.callApi(
        loginUserId: Preference.userId,
        videoId: "",
        movieSeriesId: movieSeriesId ?? "");
    if (fetchEpisodeWiseReelsModel?.data?.videos?.isNotEmpty ?? false) {
      final paginationData = fetchEpisodeWiseReelsModel?.data?.videos ?? [];
      // paginationData.shuffle();

      print(
          "coin data :${fetchEpisodeWiseReelsModel?.data?.videos?.last?.coin}");
      mainReels.addAll(paginationData);

      print("coin data1 :${mainReels?.last?.coin}");
      episodeUnlockAdsCount =
          fetchEpisodeWiseReelsModel?.userInfo?.episodeUnlockAds ?? 0;
      log('episodeUnlockAds :: $episodeUnlockAdsCount');
      log('fetchEpisodeWiseReelsModel :: ${fetchEpisodeWiseReelsModel?.totalVideosCount}');
      totalVideos = fetchEpisodeWiseReelsModel?.totalVideosCount;
      log('totalVideos :: ${fetchEpisodeWiseReelsModel?.totalVideosCount}');
    }
    isLoadingReels = false;
    update(["onGetReels"]);
  }

  void onPagination(int value) async {
    if ((mainReels.length - 1) == value) {
      if (isPaginationLoading == false) {
        isPaginationLoading = true;
        update(["onPagination"]);
        await onGetReels();
        isPaginationLoading = false;
        update(["onPagination"]);
      }
    }
  }

  Function(BuildContext)? handleLockedVideoCallback;

  void onChangePage(int index) async {
    // if (mainReels[index].isLocked == true && Preference.isVip == false) {
    //   // Revert to the previous page
    //   preloadPageController.jumpToPage(currentPageIndex);
    //   Get.snack bar(
    //     "Locked Video",
    //     "This video is locked. Unlock it to proceed.",
    //     backgroundColor: AppColor.colorBlack.withOpacity(0.8),
    //     colorText: Colors.white,
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   return;
    // }
    currentPageIndex = index;
    onAutoUnlock(index + 1);
    update(["onChangePage"]);
  }

  Future<void> onAutoUnlock(int nextIndex) async {
    final nextVideo = mainReels[nextIndex];
    if (nextVideo.isLocked != false &&
        Preference.isAutoCheck &&
        nextIndex < mainReels.length) {
      if ((nextVideo.coin ?? 0) <=
          (profileController.loginUserModel?.user?.coin ?? 0)) {
        await autoDeductWatchVideoApi(videoId: nextVideo.id);
        nextVideo.isLocked = false;
        log("Next video unlocked!");
      } else {
        Utils.showToast(Get.context!, 'Please purchase the coin');
        log("Not enough coins for next video!");
      }
    }
  }

  void jumpPage(int index) {
    preloadPageController.jumpToPage(index);
    Get.back();
  }

  watchVideoApi({
    int? currentWatchTime,
    String? videoId,
  }) async {
    log("watchVideoApi");
    await WatchShortVideoApi.callApi(
      currentWatchTime: currentWatchTime ?? 0,
      videoId: videoId ?? '',
      loginUserId: Preference.userId,
    );
  }

  Future<void> deductWatchVideoApi({required String? videoId}) async {
    try {
      Get.dialog(
        const CustomProgressDialog(),
        barrierDismissible: false,
      );

      await VideoViewApi.callApi(
        shortVideoId: videoId ?? '',
        loginUserId: Preference.userId,
      );

      update();
    } catch (e) {
      log("Error in deductWatchVideoApi",
          error: e, stackTrace: StackTrace.current);
    } finally {
      // Close the loader dialog if it's open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  Future<void> autoDeductWatchVideoApi({required String? videoId}) async {
    await VideoViewApi.callApi(
      shortVideoId: videoId ?? '',
      loginUserId: Preference.userId,
    );
    update();
  }

  void onClickPlay({required String? shortVideoId}) async {
    Utils.showLog("Reward Ad Clicked");

    // Show Reward Ad
    await GoogleRewardAd.showAd(fun: () {
      viewAdToUnlockVideoApiCall(shortVideoId: shortVideoId);
      Utils.showLog("Ad Watched Successfully");
      Utils.showLog("Reward User");
    });
  }

  viewAdToUnlockVideoApiCall({required String? shortVideoId}) async {
    viewAdToUnlockVideo = await WatchAdUnlockVideoApi.callApi(
      loginUserId: Preference.userId,
      movieWebseriesId: movieSeriesId ?? "",
      shortVideoId: shortVideoId ?? '',
    );
    episodeUnlockAdsCount = (episodeUnlockAdsCount ?? 0) + 1;
    log("episodeUnlockAdsCount + 1 :: $episodeUnlockAdsCount");
  }

  autoUnlockApi({required bool? type, String? movieId}) async {
    await UnlockEpisodesAutoApi.callApi(
        loginUserId: Preference.userId,
        movieWebSeriesId: movieId ?? movieSeriesId ?? '',
        type: type ?? false);
  }
}
