import 'debug.dart';

abstract class ApiConstant {
  /// --------------- API URLS -----------------------

  static const liveURL = "https://admin.gharcinema.in/"; // Enter your base URL like :: http://182.168.20.243:5000/
  static const SECRET_KEY = "XM7fincsra"; // Enter your key like :: ssf45sd1fs5d1sdf1s56165s15sdf1s

  static const localURL = "https://admin.gharcinema.in/";

  static getBaseURL() {
    if (Debug.isLocal) {
      return localURL;
    } else {
      return liveURL;
    }
  }

  static const login = "api/client/user/loginOrSignUp";

  static const getMoviesSeries = "api/client/movieSeries/fetchMoviesSeries";
  static const getMoviesGroupedByCategory = "api/client/movieSeries/getMoviesGroupedByCategory?";
  static const newReleasesVideo = "api/client/movieSeries/fetchNewReleasesForUser?";
  static const trendingMovieSeries = "api/client/movieSeries/getTrendingMoviesSeries?";

  static const createDailyCheckInRewardHistory = "api/client/dailyCoinReward/handleDailyCheckInReward?";
  static const createAdWatchRewardHistory = "api/client/user/handleAdWatchReward?";

  static const getVideosGroupedByMovieSeries = "api/client/shortVideo/getVideosGroupedByMovieSeries?";

  static const adRewardCoin = "api/client/adRewardCoin/getAdRewardByUser?";
  static const dailyRewardCoin = "api/client/dailyCoinReward/getDailyRewardCoinByUser?";

  // >>>>> >>>>> >>>>> Reels Api <<<<< <<<<< <<<<<

  static const fetchMovieSeriesTrailer = "api/client/shortVideo/getVideosGroupedByMovieSeries?";
  static const fetchEpisodeWiseVideo = "api/client/shortVideo/retrieveMovieSeriesVideosForUser?";
  static const createLikeDislikeOfVideo = "api/client/shortVideo/likeOrDislikeOfVideo?";
  static const createFavoriteVideo = "api/client/userVideoList/videoAddedToMyListByUser?";
  static const getFavoriteVideo = "api/client/userVideoList/getAllVideosAddedToMyListByUser?";

  static const getTransactionHistory = "api/client/history/retrieveUserSubscriptionHistory?";
  static const getEpisodeUnlockHistory = "api/client/history/getEpisodeUnlockHistory?";
  static const getEpisodeAutoUnlockHistory = "api/client/history/fetchEpisodeAutoUnlockHistory?";
  static const fetchRewardCoinHistoryByUser = "api/client/history/fetchCoinHistoryByUser?";

  static const fetchCoinPlanHistory = "api/client/history/fetchCoinplanHistoryOfUser?";
  static const retrieveSettingsForUser = "api/client/setting/retrieveSettingsForUser";
  static const fetchProfile = "api/client/user/fetchProfile?";
  static const getReportReason = "api/client/report/getReportReason";
  static const fetchCoinplanByUser = "api/client/coinplan/fetchCoinplanByUser";
  static const recordCoinPlanHistory = "api/client/coinplan/recordCoinPlanHistory?";
  static const fetchVipPlanByUser = "api/client/vipPlan/fetchVipPlanByUser";
  static const recordVipPlanHistory = "api/client/vipPlan/recordVipPlanHistory?";
  static const deleteUserAccount = "api/client/user/deleteUserAccount?";
  static const findContentBySearch = "api/client/movieSeries/findContentBySearch?";
  static const handleWatchHistoryCreation = "api/client/watchHistory/handleWatchHistoryCreation?";
  static const deductCoinForVideoView = "api/client/shortVideo/deductCoinForVideoView?";
  static const viewAdToUnlockVideo = "api/client/shortVideo/viewAdToUnlockVideo?";
  static const unlockEpisodesAutomatically = "api/client/shortVideo/unlockEpisodesAutomatically?";
}
