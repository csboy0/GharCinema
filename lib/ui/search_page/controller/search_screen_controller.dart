import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:story_box/ui/home_page/model/trending_movie_series_model.dart';
import 'package:story_box/ui/search_page/api/search_api.dart';
import 'package:story_box/ui/search_page/model/search_result.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/preference.dart';

import '../../home_page/api/trending_movie_series_api.dart';

class SearchScreenController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  TrendingMovieSeriesModel? trendingMovieSeriesModel;
  List<SearchResult> searchResults = [];
  List<String> searchHistory = <String>[].obs;
  bool isSearching = false;
  RxBool searchText = false.obs;
  bool isShowClearHistory = false;

  Future<void> searchContent(String searchString) async {
    isSearching = true;
    update(['searchResults']);
    // String query = searchString.isEmpty ? "All" : searchString;

    searchResults = await SearchApi.findContentBySearch(Preference.userId, searchString);

    isSearching = false;
    update(['searchResults']);
  }

  @override
  void onInit() async {
    super.onInit();

    searchHistory.addAll(Preference.getSearchHistory());
    searchController.addListener(() {
      searchText.value = searchController.text.isNotEmpty;
    });
    trendingMovieSeriesModel = await TrendingMoviesSeriesApi.callApi(
      start: "1",
      limit: "10",
    );
    update([Constant.idMostTrending]);
  }

  void clearSearch() async {
    searchController.clear();
    searchText.value = false;
    trendingMovieSeriesModel = await TrendingMoviesSeriesApi.callApi(
      start: "1",
      limit: "10",
    );
  }

  void saveSearch(String searchTerm) async {
    if (searchTerm.isNotEmpty) {
      await Preference.addSearchToHistory(searchTerm);
      searchHistory.add(searchTerm);
      update(['searchHistory']);
    }
  }

  void deleteHistoryItem(String item) async {
    await Preference.deleteSearchFromHistory(item);
    searchHistory.remove(item);
    update(['searchResults', 'searchHistory']);
  }

  void clearAllHistory() async {
    await Preference.clearSearchHistory();
    searchHistory.clear();
    update(['searchResults', 'searchHistory']);
  }

  onDeleteButtonClick() {
    isShowClearHistory = true;
    update(['searchResults', 'searchHistory']);
  }
}
