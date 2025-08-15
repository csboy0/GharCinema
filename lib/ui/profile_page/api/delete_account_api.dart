import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:story_box/utils/api.dart';

class DeleteUserApi {
  static Future<bool> callApi({required String userId}) async {
    log("Delete User Api Calling... ");

    final uri = Uri.parse(
      "${ApiConstant.getBaseURL() + ApiConstant.deleteUserAccount}userId=$userId",
    );

    log("Delete User Api Calling...$uri ");

    final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
    log("Get fetch user Headers :: $headers");

    try {
      var response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        log("Delete User Api Response => ${response.body}");

        return jsonResponse["status"];
      } else {
        log("Delete User Api StateCode Error ");
      }
    } catch (error) {
      log("Delete User Api Error => $error");
    }
    return false;
  }
}
