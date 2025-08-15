import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:story_box/connectivity_manager/connectivity_manager.dart';
import 'package:story_box/custom_widget/block_user_dialog.dart';
import 'package:story_box/custom_widget/custom_gradiant_text.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/home_page/api/get_movies_grouped_by_category_api.dart';
import 'package:story_box/ui/home_page/api/get_movies_series_api.dart';
import 'package:story_box/ui/home_page/api/new_releases_video_api.dart';
import 'package:story_box/ui/home_page/api/trending_movie_series_api.dart';
import 'package:story_box/ui/home_page/model/get_movies_grouped_by_category_model.dart';
import 'package:story_box/ui/home_page/model/get_movies_series_model.dart';
import 'package:story_box/ui/home_page/model/new_releases_video_model.dart';
import 'package:story_box/ui/home_page/model/trending_movie_series_model.dart';
import 'package:story_box/ui/login_page/model/login_user_model.dart';
import 'package:story_box/ui/profile_page/api/profile_api.dart';
import 'package:story_box/ui/reels_page/controller/reels_controller.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';

class HomeController extends GetxController {
  int initialPage = 0;
  CarouselSliderController controller = CarouselSliderController();
  double appBarOpacity = 0.0;
  bool isClaimed = false;

  bool isLoading = false;
  GetMoviesSeriesModel? getMoviesSeriesModel;
  GetMoviesGroupedByCategoryModel? getMoviesGroupedByCategoryModel;
  NewReleasesVideoModel? newReleasesVideoModel;
  TrendingMovieSeriesModel? trendingMovieSeriesModel;
  bool isLoadingMostTrending = false;
  bool isLoadingMostTrending1 = false;
  List<NewReleasesVideos> newReleasesVideos = [];
  final ScrollController scrollController1 = ScrollController();
  List watchedVideos = [];

  int startNewReleaseCount = 1;
  int limitNewReleaseCount = 20;

  final reelsController = Get.find<ReelsController>();
  // User? user;
  LoginUserModel? loginUserModel;
  String getMoviesGroupedByCategoryStart = "1";
  String getMoviesGroupedByCategoryLimit = "10";
  String getMoviesGroupedByCategoryMoviesStart = "1";
  String getMoviesGroupedByCategoryMoviesLimit = "10";

  @override
  void onInit() async {
    log("Enter in home controller");
    scrollController1.addListener(onPagination1);
    profileApiCall();
    InternetConnectivity.isInternetAvailable(
      Get.context!,
      success: () {
        log("message:::::::Success");
      },
      retry: () {
        log("message:::::::Retry");
      },
    );
    isLoadingMostTrending = true;
    getMoviesSeriesModel = await GetMoviesSeriesApi.callApi();

    getMoviesGroupedByCategoryModel =
        await GetMoviesGroupedByCategoryApi.callApi(
      userId: Preference.userId,
      start: getMoviesGroupedByCategoryStart,
      limit: getMoviesGroupedByCategoryLimit,
      moviesStart: getMoviesGroupedByCategoryMoviesStart,
      moviesLimit: getMoviesGroupedByCategoryMoviesLimit,
    );

    newReleasesVideoModel = await NewReleasesVideoApi().callApi(
      userId: Preference.userId,
      start: startNewReleaseCount.toString(),
      limit: limitNewReleaseCount.toString(),
    );
    if (newReleasesVideoModel?.videos != null) {
      newReleasesVideos.addAll(newReleasesVideoModel?.videos ?? []);
    }

    trendingMovieSeriesModel = await TrendingMoviesSeriesApi.callApi(
      start: "1",
      limit: "20",
    );
    isLoadingMostTrending = false;
    getHistory();
    update([
      Constant.idMostTrending,
      Constant.idHomeBlurCarousel,
      Constant.idHomeCarousel,
    ]);
    super.onInit();
  }

  // Future<void> profileApiCall() async {
  //   user = await ProfileApi.callApi();
  //   log("user.isBlock${user?.isBlock}");
  //   update(['userProfile']);
  //   String userDataJson = jsonEncode(user?.toJson());
  //   await Preference.shared.setString(Preference.userData, userDataJson);
  //   final isVip = user?.isVip ?? false;
  //   final coin = user?.coin ?? 0;
  //   await Preference.onIsVip(isVip);
  //   await Preference.onSetUserCoin(coin);
  // }

  Future<void> profileApiCall() async {
    // user = await ProfileApi.callApi();
    loginUserModel = await ProfileApi.callApi();

    log("user.isBlock: ${loginUserModel?.user?.isBlock}");
    log("loginUserModel.status: ${loginUserModel?.status}");

    if (loginUserModel?.message == "you are blocked by the admin.") {
      showBlockedUserDialog();

      return;
    }

    update(['userProfile']);

    String userDataJson = jsonEncode(loginUserModel?.user?.toJson());
    await Preference.shared.setString(Preference.userData, userDataJson);

    final isVip = loginUserModel?.user?.isVip ?? false;
    final coin = loginUserModel?.user?.coin ?? 0;

    await Preference.onIsVip(isVip);
    await Preference.onSetUserCoin(coin);
  }

  Future<void> onPagination1() async {
    if (scrollController1.position.pixels ==
        scrollController1.position.maxScrollExtent) {
      isLoadingMostTrending1 = true;
      update();

      final model = await NewReleasesVideoApi().callApi(
        userId: Preference.userId,
        start: startNewReleaseCount.toString(),
        limit: limitNewReleaseCount.toString(),
      );
      if (model?.videos != null) {
        newReleasesVideos.addAll(model?.videos ?? []);
      }
      isLoadingMostTrending1 = false;
      update();
    }
  }

  void updateAppBarOpacity(double offset) {
    appBarOpacity = (offset / 200).clamp(0.0, 0.5);
    update();
  }

  onPageChanged(int index, CarouselPageChangedReason reason) {
    initialPage = index;
    update([Constant.idHomeCarousel, Constant.idHomeBlurCarousel]);
  }

  void toggleClaim() {
    isClaimed = !isClaimed;
    update([Constant.idHomeCarousel]);
  }

  getHistory() async {
    watchedVideos = await Preference.getWatchedVideos();
    update([Constant.idGetHistory, Constant.idFavourite]);
  }

  onRefresh() async {
    getMoviesSeriesModel = await GetMoviesSeriesApi.callApi();

    getMoviesGroupedByCategoryModel =
        await GetMoviesGroupedByCategoryApi.callApi(
      userId: Preference.userId,
      start: getMoviesGroupedByCategoryStart,
      limit: getMoviesGroupedByCategoryLimit,
      moviesStart: getMoviesGroupedByCategoryMoviesStart,
      moviesLimit: getMoviesGroupedByCategoryMoviesLimit,
    );

    newReleasesVideoModel = await NewReleasesVideoApi().callApi(
      userId: Preference.userId,
      start: "1",
      limit: "20",
      // start: startNewReleaseCount.toString(),
      // limit: limitNewReleaseCount.toString(),
    );
    if (newReleasesVideoModel?.videos != null) {
      newReleasesVideos.addAll(newReleasesVideoModel?.videos ?? []);
    }

    trendingMovieSeriesModel = await TrendingMoviesSeriesApi.callApi(
      start: "1",
      limit: "20",
    );
    isLoadingMostTrending = false;
    getHistory();
    update([
      Constant.idMostTrending,
      Constant.idGetHistory,
      Constant.idHomeCarousel,
      Constant.idHomeBlurCarousel,
    ]);
  }

  likeUnlikeEpisode(int index) async {
    watchedVideos[index]['isLike'] = !watchedVideos[index]['isLike'];
    try {
      Map<String, dynamic> updatedVideo = watchedVideos[index];
      await Preference.addVideoToHistory(updatedVideo);
      update([Constant.idFavourite, Constant.idGetHistory]);
    } catch (e) {
      watchedVideos[index]['isLike'] = !watchedVideos[index]['isLike'];
      update([Constant.idFavourite, Constant.idMostTrending]);
      log("Error updating video in history: $e");
    }
  }

// likeUnlikeEpisode(int index) async {
//   if (watchedVideos[index]['isLike']) {
//     watchedVideos[index]['isLike'] = false;
//   } else {
//     watchedVideos[index]['isLike'] = true;
//   }
//   update(['isFavourite', 'onGetHistory']);
// }
}
