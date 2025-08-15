import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/episode_wise_reels_page/model/view_ad_to_unlock_video_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class WatchAdUnlockVideoApi {
  static Future<ViewAdToUnlockVideoModel?> callApi({
    required String loginUserId,
    required String shortVideoId,
    required String movieWebseriesId,
  }) async {
    final queryParameters = {
      Params.userId: loginUserId,
      Params.movieWebseriesId: movieWebseriesId,
      Params.shortVideoId: shortVideoId,
    };

    Utils.showLog("Watch ad for unlock Api queryParameters => $queryParameters");

    String queryString = Uri(queryParameters: queryParameters).query;

    final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.viewAdToUnlockVideo + queryString);
    final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};

    Utils.showLog("Watch ad for unlock Api Url => $url");

    try {
      var response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        Get.back();
        log("Watch ad for unlock Api Response => ${response.body}");

        return ViewAdToUnlockVideoModel.fromJson(jsonResponse);
      } else {
        log("Watch ad for unlock Api StateCode Error => ",
            error: "StateCode Error => ${response.statusCode} body => ${response.body}");
      }
    } catch (error) {
      log("Watch ad for unlock Api Error => ", error: "Error => $error");
    }
    return null;
  }
}
