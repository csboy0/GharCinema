import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_box/ui/search_page/model/search_result.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/utils.dart';

class SearchApi {
  static Future<List<SearchResult>> findContentBySearch(String userId, String searchString) async {
    final url = Uri.parse(
      "${ApiConstant.getBaseURL() + ApiConstant.findContentBySearch}userId=$userId&searchString=$searchString",
    );

    final headers = {"key": ApiConstant.SECRET_KEY};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        Utils.showLog("Search API Response => ${response.body}", level: LogLevel.debug);

        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true && jsonData['searchData'] is List) {
          return (jsonData['searchData'] as List).map((data) => SearchResult.fromJson(data)).toList();
        } else {
          Utils.showLog("Unexpected JSON structure or empty searchData list", level: LogLevel.error);
        }
      } else {
        Utils.showLog("Search API Status Code Error => ${response.statusCode}", level: LogLevel.error);
      }
    } catch (error) {
      Utils.showLog("Search API Error => $error", level: LogLevel.error);
    }

    return [];
  }
}
