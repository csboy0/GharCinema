import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/preference.dart';

class VideoViewApi {
  static Future<void> callApi({required String loginUserId, required String shortVideoId}) async {
    final uri = Uri.parse(
        "${ApiConstant.getBaseURL() + ApiConstant.deductCoinForVideoView}userId=$loginUserId&shortVideoId=$shortVideoId");

    log("Deduct watch short video uri => $uri");

    final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};

    try {
      final response = await http.patch(uri, headers: headers);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == true) {
          final updatedCoin = responseBody['userCoin'];
          await Preference.onSetUserCoin(updatedCoin ?? 0);
        }
        log(
          "Deduct watch Video Api Response => ${response.body}",
        );
      } else {
        log("Deduct watch Video Api StateCode Error",
            error: "Deduct watch Video Api StateCode Error => ${response.statusCode} body => ${response.body}",
            stackTrace: StackTrace.current);
      }
    } catch (error) {
      log("Deduct   watch Video Api Error ", error: error, stackTrace: StackTrace.current);
    }
  }
}
