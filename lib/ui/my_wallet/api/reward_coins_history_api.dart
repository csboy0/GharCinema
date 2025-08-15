// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:http/http.dart' as http;
// import 'package:story_box/ui/my_wallet/model/reward_coins_history_model.dart';
// import 'package:story_box/utils/params.dart';
//
// import '../../../utils/api.dart';
//
// class RewardCoinsHistoryApi {
//   int startCount = 1;
//   int limitCount = 20;
//
//   Future<List<RewardCoinsHistoryModel>> callApi({
//     required String userId,
//     required String start,
//     required String limit,
//   }) async {
//     try {
//       startCount++;
//       final queryParameters = {
//         Params.userId: userId,
//         Params.start: start,
//         Params.limit: limit,
//       };
//       log("Fetch Coin History API Calling...");
//       final url = Uri.parse("${ApiConstant.getBaseURL() + ApiConstant.fetchRewardCoinHistoryByUser + queryParameters}");
//       log("Get Movies Grouped By Category Url :: $url");
//
//       final headers = {"key": ApiConstant.SECRET_KEY};
//       final response = await http.get(url, headers: headers);
//
//       if (response.statusCode == 200) {
//         log("Fetch Coin History API Response => ${response.body}");
//
//         final Map<String, dynamic> jsonData = jsonDecode(response.body);
//
//         if (jsonData['status'] == true && jsonData['data'] is List) {
//           List<RewardCoinsHistoryModel> coinHistoryList =
//               (jsonData['data'] as List).map((coinData) => RewardCoinsHistoryModel.fromJson(coinData)).toList();
//
//           return coinHistoryList;
//         } else {
//           log(
//             "Unexpected JSON structure or empty data list",
//           );
//         }
//       } else {
//         log("Fetch Coin History API Status Code Error => ${response.statusCode}");
//       }
//     } catch (error) {
//       log("Fetch Coin History API Error => $error");
//     }
//     return [];
//   }
// }
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/my_wallet/model/reward_coins_history_model.dart';

import '../../../utils/api.dart';
import '../../../utils/preference.dart';
import '../../../utils/utils.dart';

class RewardCoinsHistoryApi {
  static Future<List<RewardCoinsHistoryModel>> callApi() async {
    Utils.showLog("Fetch Coin History API Calling...", level: LogLevel.debug);

    final userId = Preference.userId;
    final url = Uri.parse(
      "${ApiConstant.getBaseURL() + ApiConstant.fetchRewardCoinHistoryByUser}startDate=All&endDate=All&userId=$userId",
    );

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog("Fetch Coin History API Response => ${response.body}", level: LogLevel.debug);

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] is List) {
          List<RewardCoinsHistoryModel> coinHistoryList =
              (jsonData['data'] as List).map((coinData) => RewardCoinsHistoryModel.fromJson(coinData)).toList();

          return coinHistoryList;
        } else {
          Utils.showLog("Unexpected JSON structure or empty data list", level: LogLevel.error);
        }
      } else {
        Utils.showLog("Fetch Coin History API Status Code Error => ${response.statusCode}", level: LogLevel.error);
      }
    } catch (error) {
      Utils.showLog("Fetch Coin History API Error => $error", level: LogLevel.error);
    }

    return [];
  }
}
