import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/app_exception.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

import '../model/login_user_model.dart';

class LoginApi {
  LoginUserModel? loginUserModel;

  static Future<LoginUserModel?> callApi({
    required int loginType,
    required String fcmToken,
    required String email,
    required String identity,
    required String name,
    String? profilePic,
  }) async {
    try {
      final body = json.encode({
        Params.loginType: loginType,
        Params.fcmToken: fcmToken,
        Params.email: email,
        Params.identity: identity,
        Params.name: name,
        Params.profilePic: profilePic
      });

      log("Login Quick Body :: $body");

      final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.login);
      log("Login Quick Url :: $url");

      final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
      log("Login Quick Headers :: $headers");

      final response = await http.post(url, headers: headers, body: body);

      log("Login Quick Status Code :: ${response.statusCode}");
      log("Login Quick Response :: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return LoginUserModel.fromJson(jsonResponse);
      }
      log("Login Quick Api Called Successfully");
    } on AppException catch (exception) {
      Utils.showToast(Get.context!, exception.message);
    } catch (e) {
      log("Error call Login Quick Api :: $e");
    } finally {}
    return null;
  }
}
