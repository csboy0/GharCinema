import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/my_wallet/controller/wallet_controller/wallet_controller.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class UnlockEpisodesAutoApi {
  static Future<void> callApi({
    required String loginUserId,
    required bool type,
    required String movieWebSeriesId,
  }) async {
    final queryParameters = {
      Params.userId: loginUserId,
      Params.movieWebseriesId: movieWebSeriesId,
      'type': type.toString(),
    };

    Utils.showLog(" Auto unlock Api queryParameters => $queryParameters");

    String queryString = Uri(queryParameters: queryParameters).query;

    final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.unlockEpisodesAutomatically + queryString);
    final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};

    Utils.showLog("unlock Api Url => $url");

    try {
      var response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showToast(Get.context!, 'Success');
        final controller = Get.find<WalletController>();
        controller.onEpisodeAutoUnlock();
        log("Auto unlock Api Response => ${response.body}");
      } else {
        log("Auto unlock Api StateCode Error => ", error: "StateCode Error => ${response.statusCode} body => ${response.body}");
      }
    } catch (error) {
      log("Auto unlock Api Error => ", error: "Error => $error");
    }
    return;
  }
}
