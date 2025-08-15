import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:story_box/ui/home_page/model/trending_movie_series_model.dart';
import 'package:story_box/utils/api.dart';
import 'package:story_box/utils/app_exception.dart';
import 'package:story_box/utils/params.dart';
import 'package:story_box/utils/utils.dart';

class TrendingMoviesSeriesApi {
  TrendingMovieSeriesModel? trendingMovieSeriesModel;

  static Future<TrendingMovieSeriesModel?> callApi({
    required String start,
    required String limit,
  }) async {
    try {
      final queryParameters = {
        Params.start: start,
        Params.limit: limit,
      };

      String queryString = Uri(queryParameters: queryParameters).query;

      log("Trending Movies Series Params :: $queryString");

      final url = Uri.parse(ApiConstant.getBaseURL() + ApiConstant.trendingMovieSeries + queryString);
      log("Trending Movies Series Url :: $url");

      final headers = {"key": ApiConstant.SECRET_KEY, 'Content-Type': 'application/json'};
      log("Trending Movies Series Headers :: $headers");

      final response = await http.get(url, headers: headers);

      log("Trending Movies Series Status Code :: ${response.statusCode}");
      log("Trending Movies Series Response :: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return TrendingMovieSeriesModel.fromJson(jsonResponse);
      }
      log("Trending Movies Series Api Called Successfully");
    } on AppException catch (exception) {
      Utils.showToast(Get.context!, exception.message);
    } catch (e) {
      log("Error call Trending Movies Series Api :: $e");
    } finally {}
    return null;
  }
}
