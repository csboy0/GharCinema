import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:story_box/custom_widget/block_user_dialog.dart';
import 'package:story_box/ui/login_page/model/login_user_model.dart';
import 'package:story_box/ui/profile_page/api/profile_api.dart';
import 'package:story_box/ui/reels_page/api/fetch_favourite%20_video_api.dart';
import 'package:story_box/ui/reels_page/api/fetch_movie_series_trailer_api.dart';
import 'package:story_box/ui/reels_page/model/fetch_movie_series_trailer_model.dart';
import 'package:story_box/ui/reels_page/model/video.dart';
import 'package:story_box/utils/preference.dart';

class ReelsController extends GetxController {
  PreloadPageController preloadPageController = PreloadPageController();

  bool selectedIndexIsFavorite = false;
  int isFavoriteCount = 0;

  int currentPageIndex = 0;
  bool isLoadingReels = false;
  bool isLoadingMyList = false;
  bool isPaginationLoading = false;

  List<TrailerData> mainReels = [];
  FetchMovieSeriesTrailerModel? fetchMovieSeriesTrailerModel;

  List<Video> favoriteVideos = [];
  LoginUserModel? loginUserModel;

  Future<void> init() async {
    currentPageIndex = 0;
    mainReels.clear();
    FetchMovieSeriesTrailerApi.startPagination = 0;
    isLoadingReels = true;
    update(["onGetReels"]);
    await onGetReels();
    print("callApiRell");
    isLoadingReels = false;
  }

  // User? user;

  callApi() async {
    await onGetReels();
    update(["onGetReels"]);
  }

  @override
  Future<void> onInit() async {
    print("call reel controller");
    onGetFavVideo();
    callApi();
    // loginUserModel = await ProfileApi.callApi();
    // if (loginUserModel?.message == "you are blocked by the admin.") {
    //   showBlockedUserDialog();
    //
    //   return;
    // }
    super.onInit();
  }

  blockFunction() async {
    loginUserModel = await ProfileApi.callApi();
    if (loginUserModel?.message == "you are blocked by the admin.") {
      showBlockedUserDialog();
    }
  }

  void onChangePage(int index) async {
    currentPageIndex = index;
    update(["onChangePage"]);
  }

  Future<void> onGetReels() async {
    fetchMovieSeriesTrailerModel =
        await FetchMovieSeriesTrailerApi.callApi(userId: Preference.userId);

    print("dataaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

    final blockMessage =
        fetchMovieSeriesTrailerModel?.message?.toLowerCase().trim();
    if (fetchMovieSeriesTrailerModel?.message == "You are blocked by admin.") {
      showBlockedUserDialog(); // Show custom dialog
      return;
    }

    if (fetchMovieSeriesTrailerModel?.data?.isNotEmpty ?? false) {
      final paginationData = fetchMovieSeriesTrailerModel?.data ?? [];
      paginationData.shuffle();
      mainReels.addAll(paginationData);
    }
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

  Future<void> onGetFavVideo() async {
    isLoadingMyList = true;
    favoriteVideos = await GetFavoriteVideoApi.callApi();

    isLoadingMyList = false;
    update(["onGetFavVideo"]);
  }
}
