import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:story_box/custom_widget/custom_icon_button.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/reels_page/api/create_favorite_video_api.dart';
import 'package:story_box/ui/reels_page/api/create_like_dislike_of_video_api.dart';
import 'package:story_box/ui/reels_page/controller/reels_controller.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

class PreviewReelsView extends StatefulWidget {
  const PreviewReelsView(
      {super.key, required this.index, required this.currentPageIndex});

  final int index;
  final int currentPageIndex;

  @override
  State<PreviewReelsView> createState() => _PreviewReelsViewState();
}

class _PreviewReelsViewState extends State<PreviewReelsView>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<ReelsController>();

  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;

  RxBool isPlaying = true.obs;
  RxBool isShowIcon = false.obs;

  RxBool isBuffering = false.obs;
  RxBool isVideoLoading = true.obs;

  RxBool isShowLikeAnimation = false.obs;
  RxBool isShowLikeIconAnimation = false.obs;

  RxBool isReelsPage = true.obs; // This is Use to Stop Auto Playing..

  RxBool isLike = false.obs;
  RxBool isFavorite = false.obs;

  RxMap customChanges = {"like": 0, "favorite": 0}.obs;

  RxBool isReadMore = false.obs;

  @override
  void initState() {
    print("call widget");
    initializeVideoPlayer();
    customSetting();
    // controller.blockFunction();

    if (controller.loginUserModel?.message == "you are blocked by the admin.") {
      print("block...................");
      chewieController?.pause();
    }
    200.milliseconds.delay();
    log('ISFAVOUTITE :: ${controller.mainReels[widget.index].isAddedList} ==== ${controller.mainReels[widget.index].movieSeriesName}');
    super.initState();
  }

  @override
  void dispose() {
    onDisposeVideoPlayer();
    Utils.showLog("Dispose Method Called Success", level: LogLevel.debug);
    super.dispose();
  }

  Future<void> initializeVideoPlayer() async {
    try {
      // String videoPath = controller.mainReels[widget.index].videos?.videoUrl ?? "";
      String videoPath =
          controller.mainReels[widget.index].videos?.videoUrl ?? "";

      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(videoPath));

      await videoPlayerController?.initialize();

      if (videoPlayerController != null &&
          (videoPlayerController?.value.isInitialized ?? false)) {
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          looping: true,
          allowedScreenSleep: false,
          allowMuting: false,
          showControlsOnInitialize: false,
          showControls: false,
          maxScale: 1,
        );

        if (chewieController != null) {
          isVideoLoading.value = false;
          (widget.index == widget.currentPageIndex && isReelsPage.value)
              ? onPlayVideo()
              : null; // Use => First Time Video Playing...
        } else {
          isVideoLoading.value = true;
        }

        videoPlayerController?.addListener(
          () {
            // Use => If Video Buffering then show loading....
            (videoPlayerController?.value.isBuffering ?? false)
                ? isBuffering.value = true
                : isBuffering.value = false;

            if (isReelsPage.value == false) {
              onStopVideo(); // Use => On Change Routes...
            }
          },
        );
      }
    } catch (e) {
      onDisposeVideoPlayer();
      Utils.showLog(
          "Reels Video Initialization Failed !!! ${widget.index} => $e",
          level: LogLevel.error);
    }
  }

  void onStopVideo() {
    isPlaying.value = false;
    videoPlayerController?.pause();
  }

  void onPlayVideo() {
    isPlaying.value = true;
    videoPlayerController?.play();
  }

  void onDisposeVideoPlayer() {
    try {
      onStopVideo();
      videoPlayerController?.dispose();
      chewieController?.dispose();
      chewieController = null;
      videoPlayerController = null;
      isVideoLoading.value = true;
    } catch (e) {
      Utils.showLog(">>>> On Dispose VideoPlayer Error => $e",
          level: LogLevel.error);
    }
  }

  void customSetting() {
    isLike.value = controller.mainReels[widget.index].videos?.isLike ?? false;
    isFavorite.value = controller.mainReels[widget.index].isAddedList ?? false;
    customChanges["like"] = int.parse(
        "${controller.mainReels[widget.index].videos?.totalLikes ?? 0}");
    customChanges["favorite"] = int.parse(
        "${controller.mainReels[widget.index].totalAddedToList ?? 0}");
    controller.update();
  }

  void onClickVideo() async {
    if (isVideoLoading.value == false) {
      videoPlayerController!.value.isPlaying ? onStopVideo() : onPlayVideo();
      isShowIcon.value = true;
      await 2.seconds.delay();
      isShowIcon.value = false;
    }
    if (isReelsPage.value == false) {
      isReelsPage.value = true; // Use => On Back Reels Page...
    }
  }

  void onClickPlayPause() async {
    videoPlayerController!.value.isPlaying ? onStopVideo() : onPlayVideo();
    if (isReelsPage.value == false) {
      isReelsPage.value = true; // Use => On Back Reels Page...
    }
  }

  // Future<void> onClickShare() async {
  //   isReelsPage.value = false;
  //
  //   Get.dialog(const LoadingUi(), barrierDismissible: false); // Start Loading...
  //
  //   await BranchIoServices.onCreateBranchIoLink(
  //     id: controller.mainReels[widget.index].id ?? "",
  //     name: controller.mainReels[widget.index].caption ?? "",
  //     image: controller.mainReels[widget.index].videoImage ?? "",
  //     userId: controller.mainReels[widget.index].userId ?? "",
  //     pageRoutes: "Video",
  //   );
  //
  //   final link = await BranchIoServices.onGenerateLink();
  //
  //   Get.back(); // Stop Loading...
  //
  //   if (link != null) {
  //     CustomShare.onShareLink(link: link);
  //   }
  //   await ReelsShareApi.callApi(loginUserId: Database.loginUserId, videoId: controller.mainReels[widget.index].id!);
  // }

  Future<void> onClickLike() async {
    if (isLike.value) {
      isLike.value = false;
      customChanges["like"]--;
      controller.update(["onGetLikeCount"]);
    } else {
      isLike.value = true;
      customChanges["like"]++;
      controller.update(["onGetLikeCount"]);
    }

    Vibration.vibrate(duration: 50, amplitude: 128);

    isShowLikeIconAnimation.value = true;
    await 500.milliseconds.delay();
    isShowLikeIconAnimation.value = false;

    await CreateLikeDislikeOfVideoApi.callApi(
      loginUserId: Preference.userId,
      videoId: controller.mainReels[widget.index].videos?.id ?? "",
    );
  }

  // Future<void> onClickFavorite() async {
  //   await CreateFavoriteVideoApi.callApi(
  //     loginUserId: Preference.userId,
  //     movieSeriesId: controller.mainReels[widget.index].id ?? "",
  //   );
  //   if (isFavorite.value) {
  //     isFavorite.value = false;
  //     customChanges["favorite"]--;
  //     controller.update(["onGetFavCount"]);
  //   } else {
  //     isFavorite.value = true;
  //     customChanges["favorite"]++;
  //     controller.update(["onGetFavCount"]);
  //   }
  //   Vibration.vibrate(duration: 50, amplitude: 128);
  // }
  Future<void> onClickFavorite() async {
    await CreateFavoriteVideoApi.callApi(
      loginUserId: Preference.userId,
      movieSeriesId: controller.mainReels[widget.index].id ?? "",
    );
    if (isFavorite.value) {
      isFavorite.value = false;
      customChanges["favorite"]--;
      controller.mainReels[widget.index].isAddedList = isFavorite.value;
      controller.update(["onGetFavCount"]);
    } else {
      isFavorite.value = true;
      customChanges["favorite"]++;
      controller.mainReels[widget.index].isAddedList = isFavorite.value;
      controller.update(["onGetFavCount"]);
    }

    Vibration.vibrate(duration: 50, amplitude: 128);
  }

  Future<void> onDoubleClick() async {
    if (isLike.value) {
      isLike.value = false;
      customChanges["like"]--;
    } else {
      isLike.value = true;
      customChanges["like"]++;

      isShowLikeAnimation.value = true;
      Vibration.vibrate(duration: 50, amplitude: 128);
      await 1200.milliseconds.delay();
      isShowLikeAnimation.value = false;
    }

    await CreateLikeDislikeOfVideoApi.callApi(
      loginUserId: Preference.userId,
      videoId: controller.mainReels[widget.index].videos?.id ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index == widget.currentPageIndex) {
      // Use => Play Current Video On Scrolling...
      isReadMore.value = false;
      (isVideoLoading.value == false && isReelsPage.value)
          ? onPlayVideo()
          : null;
    } else {
      // Restart Previous Video On Scrolling...
      isVideoLoading.value == false
          ? videoPlayerController?.seekTo(Duration.zero)
          : null;
      onStopVideo(); // Stop Previous Video On Scrolling...
    }
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            GestureDetector(
              onTap: onClickVideo,
              // onDoubleTap: onDoubleClick,
              child: Container(
                color: AppColor.colorBlack,
                height: (Get.height - Constant.bottomBarSize),
                width: Get.width,
                child: Obx(
                  () => isVideoLoading.value
                      ? const Align(
                          alignment: Alignment.bottomCenter,
                          child: LinearProgressIndicator(
                              color: AppColor.colorPrimary))
                      : SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width:
                                  videoPlayerController?.value.size.width ?? 0,
                              height:
                                  videoPlayerController?.value.size.height ?? 0,
                              child: Chewie(controller: chewieController!),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: isShowLikeAnimation.value,
                child: Align(
                  alignment: Alignment.center,
                  child: Lottie.asset(
                    AppAsset.lottieGift,
                    fit: BoxFit.cover,
                    height: 300,
                    width: 300,
                  ),
                ),
              ),
            ),
            Obx(() => Align(
                  alignment: Alignment.center,
                  child: isPlaying.value
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: onClickPlayPause,
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Center(
                              child: Image.asset(
                                AppAsset.icPlay,
                                // width: 30,
                                // height: 30,
                                color: AppColor.colorWhite.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                )),
            Positioned(
              bottom: 0,
              child: Obx(
                () => Visibility(
                  visible: (isVideoLoading.value == false),
                  child: Container(
                    height: Get.height / 4,
                    width: Get.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.transparent,
                          AppColor.colorBlack.withOpacity(0.7)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              child: Container(
                padding: const EdgeInsets.only(top: 30, bottom: 85),
                height: Get.height,
                width: 40,
                child: Column(
                  children: [
                    CustomIconButton(
                      icon: AppAsset.icSearch,
                      circleSize: 40,
                      callback: () {
                        isReelsPage.value = false;
                        Get.toNamed(AppRoutes.search);
                      },
                      iconSize: 36,
                      iconColor: AppColor.colorWhite,
                    ),
                    const Spacer(),
                    10.height,
                    Obx(
                      () => SizedBox(
                        height: 40,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: isShowLikeIconAnimation.value ? 15 : 50,
                          width: isShowLikeIconAnimation.value ? 15 : 50,
                          alignment: Alignment.center,
                          child: CustomIconButton(
                            icon: isLike.value
                                ? AppAsset.icSelectedLike
                                : AppAsset.icLike,
                            callback: onClickLike,
                            iconSize: 34,
                            // iconColor: isLike.value ? AppColor.colorRedContainer : AppColor.colorWhite,
                          ),
                        ),
                      ),
                    ),
                    GetBuilder<ReelsController>(
                        id: 'onGetLikeCount',
                        builder: (context) {
                          return Text(
                            CustomFormatNumber.convert(customChanges["like"]),
                            style:
                                AppFontStyle.styleW700(AppColor.colorWhite, 14),
                          );
                        }),
                    15.height,
                    Obx(
                      () => SizedBox(
                        height: 40,
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: CustomIconButton(
                              icon: isFavorite.value
                                  ? AppAsset.icFavoriteSelected
                                  : AppAsset.icFavorite,
                              callback: onClickFavorite,
                              iconSize: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GetBuilder<ReelsController>(
                        id: 'onGetFavCount',
                        builder: (context) {
                          return Text(
                            CustomFormatNumber.convert(
                                customChanges["favorite"]),
                            style:
                                AppFontStyle.styleW700(AppColor.colorWhite, 14),
                          );
                        }),
                    15.height,
                    CustomIconButton(
                      icon: AppAsset.icList,
                      circleSize: 40,
                      callback: () {
                        onStopVideo();
                        isReelsPage.value = false;
                        Get.toNamed(
                          AppRoutes.episodeWiseReels,
                          arguments: {
                            "id":
                                controller.mainReels[widget.index].videos?.id ??
                                    "",
                            "movieSeriesId":
                                controller.mainReels[widget.index].id ?? "",
                            "totalVideos":
                                controller.mainReels[widget.index].totalVideos,
                            "isNavigateOnHome": true
                          },
                        )?.then(
                          (value) {
                            onPlayVideo();
                          },
                        );
                      },
                      iconSize: 30,
                      iconColor: AppColor.colorWhite,
                    ),
                    Text(
                      EnumLocal.list.name.tr,
                      style: AppFontStyle.styleW700(AppColor.colorWhite, 14),
                    ),
                    15.height,
                    CustomIconButton(
                      icon: AppAsset.icShare,
                      circleSize: 40,
                      callback: () {
                        Share.share('check out my website https://example.com');
                        isReelsPage.value = false;
                      },
                      iconSize: 30,
                      iconColor: AppColor.colorWhite,
                    ),
                    Text(
                      EnumLocal.share.name.tr,
                      style: AppFontStyle.styleW700(AppColor.colorWhite, 14),
                    ),
                    60.height,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 15,
              bottom: 20,
              child: SizedBox(
                height: 400,
                width: Get.width / 1.5,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          controller.mainReels[widget.index].movieSeriesName ??
                              "",
                          style:
                              AppFontStyle.styleW700(AppColor.colorWhite, 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        6.height,
                        Visibility(
                          visible: controller.mainReels[widget.index]
                                  .movieSeriesDescription
                                  ?.trim()
                                  .isNotEmpty ??
                              false,
                          child: ReadMoreText(
                            controller.mainReels[widget.index]
                                    .movieSeriesDescription ??
                                "",
                            trimMode: TrimMode.Line,
                            trimLines: 3,
                            style:
                                AppFontStyle.styleW500(AppColor.colorWhite, 14),
                            colorClickableText: AppColor.colorPrimary,
                            trimCollapsedText: ' Show more',
                            trimExpandedText: ' Show less',
                            moreStyle: AppFontStyle.styleW500(
                                AppColor.colorPrimary, 13.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomFormatNumber {
  static String convert(int number) {
    if (number >= 10000000) {
      double millions = number / 1000000;
      return '${millions.toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      double thousands = number / 1000;
      return '${thousands.toStringAsFixed(1)}k';
    } else {
      return number.toString();
    }
  }
}
