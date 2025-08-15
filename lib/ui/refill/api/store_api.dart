import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/refill/model/coin_plan.dart';
import 'package:story_box/ui/refill/model/vip_plan.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class StoreApi {
  static Future<List<CoinPlan>> fetchCoinPlanApi() async {
    Utils.showLog("Fetch Coin Plan API Calling...", level: LogLevel.debug);

    final url = Uri.parse(
      "${ApiConstant.getBaseURL() + ApiConstant.fetchCoinplanByUser}",
    );

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog("Fetch Coin Plan API Response => ${response.body}", level: LogLevel.debug);

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] is List) {
          List<CoinPlan> coinPlan = (jsonData['data'] as List).map((data) => CoinPlan.fromJson(data)).toList();

          return coinPlan;
        } else {
          Utils.showLog("Unexpected JSON structure or empty data list", level: LogLevel.error);
        }
      } else {
        Utils.showLog("Fetch Coin Plan API Status Code Error => ${response.statusCode}", level: LogLevel.error);
      }
    } catch (error) {
      Utils.showLog("Fetch Coin Plan API Error => $error", level: LogLevel.error);
    }

    return [];
  }

  static Future<List<VipPlan>> fetchVipPlanApi() async {
    Utils.showLog("Fetch Vip Plan API Calling...", level: LogLevel.debug);

    final url = Uri.parse(
      "${ApiConstant.getBaseURL() + ApiConstant.fetchVipPlanByUser}",
    );

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog("Fetch Vip Plan API Response => ${response.body}", level: LogLevel.debug);

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['vipPlan'] is List) {
          List<VipPlan> vipPlan = (jsonData['vipPlan'] as List).map((data) => VipPlan.fromJson(data)).toList();

          return vipPlan;
        } else {
          Utils.showLog("Unexpected JSON structure or empty data list", level: LogLevel.error);
        }
      } else {
        Utils.showLog("Fetch Vip Plan API Status Code Error => ${response.statusCode}", level: LogLevel.error);
      }
    } catch (error) {
      Utils.showLog("Fetch Vip Plan API Error => $error", level: LogLevel.error);
    }

    return [];
  }

  static Future<void> recordCoinPlanHistory({
    required String loginUserId,
    required String coinPlanId,
    required String paymentType,
  }) async {
    Utils.showLog("Purchase the coinPlan create history Api Calling...", level: LogLevel.debug);

    final uri = Uri.parse(
        "${ApiConstant.getBaseURL() + ApiConstant.recordCoinPlanHistory}userId=$loginUserId&coinPlanId=$coinPlanId&paymentGateway=$paymentType");

    Utils.showLog("URL => $uri", level: LogLevel.debug);

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == true) {
          final updatedCoin = responseBody['userCoin'];
          await Preference.onSetUserCoin(updatedCoin ?? 0);
        }
        Utils.showLog("Purchase the coinPlan create history Api Response => ${response.body}", level: LogLevel.debug);
      } else {
        Utils.showLog("Purchase the coinPlan create history Api StateCode Error => ",
            level: LogLevel.error, error: "StateCode Error => ${response.statusCode} body => ${response.body}");
      }
    } catch (error) {
      Utils.showLog("Purchase the coinPlan create history Api Error => $error", level: LogLevel.error);
    }
  }

  static Future<void> recordVipPlanHistory({
    required String loginUserId,
    required String vipPlanId,
    required String paymentType,
  }) async {
    Utils.showLog("Purchase the vipPlan create history Api Calling...", level: LogLevel.debug);

    final uri = Uri.parse(
        "${ApiConstant.getBaseURL() + ApiConstant.recordVipPlanHistory}userId=$loginUserId&vipPlanId=$vipPlanId&paymentGateway=$paymentType");

    Utils.showLog("URL => $uri", level: LogLevel.debug);

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == true) {
          await Preference.onIsVip(true);
          Get.find<HomeController>().profileApiCall();
          Preference.isVip;
        }
        Utils.showLog("Purchase the vipPlan create history Api Response => ${response.body}", level: LogLevel.debug);
      } else {
        Utils.showLog("Purchase the vipPlan create history Api StateCode Error => ",
            level: LogLevel.error, error: "StateCode Error => ${response.statusCode} body => ${response.body}");
      }
    } catch (error) {
      Utils.showLog("Purchase the vipPlan create history Api Error => $error", level: LogLevel.error);
    }
  }
}
