import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/setting_view_page/model/setting.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/app_exception.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/utils.dart';

class SettingApi {
  static Setting? setting;

  static Future<Setting?> callApi() async {
    try {
      final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.retrieveSettingsForUser);
      log("Get setting Url :: $url");

      final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
      log("Get setting Headers :: $headers");

      final response = await http.get(url, headers: headers);

      log("Get setting Status Code :: ${response.statusCode}");
      log("Get setting Response :: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setting = Setting.fromJson(jsonResponse['setting']);

        Constant.googlePlaySwitch = setting?.googlePlaySwitch ?? false;
        Constant.stripeSwitch = setting?.stripeSwitch ?? false;
        Constant.razorPaySwitch = setting?.razorPaySwitch ?? false;
        Constant.flutterWaveSwitch = setting?.flutterWaveSwitch ?? false;
        Constant.contactEmail = setting?.contactEmail ?? "";
        Constant.currencyIcon = setting?.currency?.symbol ?? "";

        print("contactEmail:::::::::::${Constant.contactEmail}");
        print("contactEmail:::::::::::${Constant.currencyIcon}");
      }
      log("Get setting Api Called Successfully");
    } on AppException catch (exception) {
      Utils.showToast(Get.context!, exception.message);
    } catch (e) {
      log("Error call Get setting Api :: $e");
    } finally {}
    return null;
  }
}
