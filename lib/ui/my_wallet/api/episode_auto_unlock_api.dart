import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/my_wallet/model/EpisodeAutoUnlockModel.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/params.dart';

class EpisodeAutoUnlockApi {
  Future<List<EpisodeAutoUnlockModel>> callApi({
    required String userId,
    required String start,
    required String limit,
  }) async {
    try {
      final queryParameters = {
        Params.userId: userId,
        Params.start: start,
        Params.limit: limit,
      };

      String queryString = Uri(queryParameters: queryParameters).query;

      log("New Releases Video Params :: $queryString");

      final url = Uri.parse(
        "${ApiConstant.getBaseURL() + ApiConstant.getEpisodeAutoUnlockHistory + queryString}",
      );

      final headers = {"key": ApiConstant.SECRET_KEY};
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        log("Fetch episode unlock API Response => ${response.body}");

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['data'] is List) {
          List<EpisodeAutoUnlockModel> episodeUnlockList =
              (jsonData['data'] as List).map((coinData) => EpisodeAutoUnlockModel.fromJson(coinData)).toList();

          return episodeUnlockList;
        } else {
          log("Unexpected JSON structure or empty data list");
        }
      } else {
        log("Fetch episode unlock API Status Code Error => ${response.statusCode}");
      }
    } catch (error) {
      log("Fetch episode unlock API Error => $error");
    }

    return [];
  }
}
