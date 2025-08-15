import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/ui/episode_wise_reels_page/controller/episode_wise_reels_controller.dart';
import 'package:story_box/ui/my_wallet/api/episode_auto_unlock_api.dart';
import 'package:story_box/ui/my_wallet/api/episode_unlock_api.dart';
import 'package:story_box/ui/my_wallet/api/reward_coins_history_api.dart';
import 'package:story_box/ui/my_wallet/api/transaction_history_api.dart';
import 'package:story_box/ui/my_wallet/model/EpisodeAutoUnlockModel.dart';
import 'package:story_box/ui/my_wallet/model/episode_unlock_model.dart';
import 'package:story_box/ui/my_wallet/model/reward_coins_history_model.dart';
import 'package:story_box/ui/my_wallet/model/transaction_model.dart';
import 'package:story_box/utils/preference.dart';

class WalletController extends GetxController {
  List<CoinPlanHistory> transactionHistoryList = [];
  bool isCoinPlanLoading = false;

  List<RewardCoinsHistoryModel> rewardCoins = [];
  bool isRewardCoinsLoading = false;

  List<EpisodeUnlockModel> episodeUnlock = [];
  bool isEpisodeUnlockLoading = false;
  bool isEpisodeUnlockLoading1 = false;

  List<EpisodeAutoUnlockModel> episodeAutoUnlock = [];
  bool isEpisodeAutoUnlockLoading = false;

  int startUnlockCount = 1;
  int limitUnlockCount = 20;

  int startAutoUnlockCount = 1;
  int limitAutoUnlockCount = 20;

  int? coin;
  int? rewardCoin;

  final ScrollController scrollController = ScrollController();
  final controller = Get.put(EpisodeWiseReelsController());

  @override
  void onInit() {
    if (coin == null) {
      if (Get.arguments["coin"] != null || Get.arguments["rewardCoin"] != null) {
        coin = (Get.arguments["coin"]);
        rewardCoin = (Get.arguments["rewardCoin"]);
        log("coin :: $coin");
        log("rewardCoin :: $rewardCoin");
      }
    }

    scrollController.addListener(onPagination1);

    onGetTransactionHistory();
    onEpisodeUnlock();
    onEpisodeAutoUnlock();
    onGetRewardCoins();
    super.onInit();
  }

  bool isSwitchOn = true;
  List<bool> switchStates = [];

  // onSwitch(value) {
  //   isSwitchOn = value;
  //   controller.autoUnlockApi(type: isSwitchOn);
  //   update(['idSwitchOn', 'episodeAutoUnlock']);
  // }

  void onSwitch(int index, bool value, String? movieId) {
    switchStates[index] = value;
    controller.autoUnlockApi(type: value, movieId: movieId);
    Preference.onIsAutoCheck(false);
    update(['idSwitchOn', 'episodeAutoUnlock']);
  }

  Future<void> onGetTransactionHistory() async {
    isCoinPlanLoading = true;
    transactionHistoryList = await TransactionHistoryApi.callApi();
    isCoinPlanLoading = false;
    update(["coinPlanHistoryList"]);
  }

  Future<void> onEpisodeUnlock() async {
    isEpisodeUnlockLoading = true;
    episodeUnlock = await EpisodeUnlockApi().callApi(
      userId: Preference.userId,
      start: startUnlockCount,
      limit: limitUnlockCount.toString(),
    );
    isEpisodeUnlockLoading = false;
    update(["episodeUnlock"]);
  }

  Future<void> onEpisodeAutoUnlock() async {
    isEpisodeAutoUnlockLoading = true;
    episodeAutoUnlock = await EpisodeAutoUnlockApi().callApi(
      userId: Preference.userId,
      start: startAutoUnlockCount.toString(),
      limit: limitAutoUnlockCount.toString(),
    );
    switchStates = List.generate(episodeAutoUnlock.length, (index) => true);
    isEpisodeAutoUnlockLoading = false;
    update(["episodeAutoUnlock"]);
  }

  Future<void> onPagination1() async {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      isEpisodeUnlockLoading1 = true;
      update(["episodeUnlock"]);

      startUnlockCount++;

      final model = await EpisodeUnlockApi().callApi(
        userId: Preference.userId,
        start: startUnlockCount,
        limit: limitUnlockCount.toString(),
      );
      if (model.isNotEmpty) {
        episodeUnlock.addAll(model);
      }
      isEpisodeUnlockLoading1 = false;
      update(["episodeUnlock"]);
    }
  }

  Future<void> onGetRewardCoins() async {
    isRewardCoinsLoading = true;
    rewardCoins = await RewardCoinsHistoryApi.callApi();
    isRewardCoinsLoading = false;
    update(["rewardCoins"]);
  }
}
