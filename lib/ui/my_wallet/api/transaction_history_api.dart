import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/my_wallet/model/transaction_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

import '../../../utils/preference.dart';

class TransactionHistoryApi {
  static Future<List<CoinPlanHistory>> callApi() async {
    Utils.showLog("Fetch Coin History API Calling...", level: LogLevel.debug);

    final userId = Preference.userId;
    final url = Uri.parse(
      "${ApiConstant.getBaseURL() + ApiConstant.fetchCoinPlanHistory}userId=$userId",
    );

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog("Fetch Coin History API Response => ${response.body}", level: LogLevel.debug);

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] is List) {
          List<CoinPlanHistory> coinHistoryList =
              (jsonData['data'] as List).map((coinData) => CoinPlanHistory.fromJson(coinData)).toList();

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
