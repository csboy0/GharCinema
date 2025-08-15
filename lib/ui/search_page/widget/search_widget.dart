import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/shimmer/search_item_shmmer.dart';
import 'package:story_box/ui/home_page/widget/home_widget.dart';
import 'package:story_box/ui/search_page/controller/search_screen_controller.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

import '../../../utils/constant.dart';
import '../../home_page/controller/home_controller.dart';
import '../../home_page/model/trending_movie_series_model.dart';

class SearchTextField extends StatelessWidget {
  final VoidCallback onSearch;

  SearchTextField({
    super.key,
    required this.onSearch,
  });

  final controller = Get.find<SearchScreenController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColor.colorWhite),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Obx(
            () => TextFormField(
              controller: controller.searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade900,
                hintText: EnumLocal.searchByTitleTheme.name.tr,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.primaryColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  color: AppColor.colorWhite,
                  onPressed: onSearch,
                ),
                suffixIcon: controller.searchText.value
                    ? GestureDetector(
                        onTap: () {
                          controller.clearSearch();
                          controller.update([
                            Constant.idMostTrending,
                            'searchResults',
                          ]);
                        },
                        child: const Icon(Icons.close))
                    : null,
              ),
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  controller.saveSearch(value);
                }
              },
              onChanged: (value) {
                controller.searchContent(value);
                controller.update();
              },
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchBuilder extends StatelessWidget {
  const SearchBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchScreenController>(
      id: 'searchResults',
      builder: (controller) {
        if (controller.isSearching) {
          return const SearchItemShimmer();
        }
        if (controller.searchController.text.isNotEmpty && controller.searchResults.isEmpty) {
          return Center(
              child: Text(
            EnumLocal.noResultsFound.name.tr,
            style: AppFontStyle.styleW800(AppColor.colorIconGrey, 14),
          ));
        }
        return controller.searchController.text.isEmpty
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.searchHistory.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              EnumLocal.searchHistory.name.tr,
                              style: AppFontStyle.styleW800(AppColor.colorIconGrey, 22),
                            ),
                            16.height,
                            if (!controller.isShowClearHistory)
                              GestureDetector(
                                onTap: () {
                                  controller.onDeleteButtonClick();
                                },
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white54,
                                  size: 22,
                                ),
                              )
                            else
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.isShowClearHistory = false;
                                      controller.update(['searchResults', 'searchHistory']);
                                    },
                                    child: Text(
                                      EnumLocal.cancel.name.tr,
                                      style: AppFontStyle.styleW800(AppColor.colorWhite, 16),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                    child: VerticalDivider(
                                      color: AppColor.greyColor,
                                      thickness: 1,
                                      width: 26,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.clearAllHistory();
                                    },
                                    child: Text(
                                      EnumLocal.clearAll.name.tr,
                                      style: AppFontStyle.styleW800(AppColor.primaryColor, 16),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        16.height,
                        const SearchHistoryChips(),
                        16.height,
                      ],
                      GetBuilder<HomeController>(
                        id: Constant.idMostTrending,
                        builder: (logic) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                EnumLocal.peopleAreSearching.name.tr,
                                style: AppFontStyle.styleW800(AppColor.colorIconGrey, 22),
                              ).paddingOnly(bottom: 16),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: logic.trendingMovieSeriesModel?.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return GetBuilder<HomeController>(
                                    builder: (logic) {
                                      final data = logic.trendingMovieSeriesModel?.data?[index] ?? TrendingMoviesSeriesData();
                                      return SearchItemView(
                                        data: data,
                                        isShowCategory: true,
                                        index: index + 1,
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      EnumLocal.peopleAreSearching.name.tr,
                      style: AppFontStyle.styleW800(AppColor.colorIconGrey, 22),
                    ).paddingOnly(top: 10, left: 16, bottom: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.searchResults.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = controller.searchResults[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.episodeWiseReels,
                                arguments: {
                                  "movieSeriesId": data.sId ?? "",
                                  "totalVideos": 0,
                                },
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    height: 140,
                                    width: 110,
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: data.thumbnail ?? '',
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                          placeholder: (context, url) => Center(
                                            child: Image.asset(
                                              AppAsset.placeHolderImage,
                                              color: AppColor.colorIconGrey,
                                            ).paddingAll(16),
                                          ),
                                          errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppColor.colorBlack.withOpacity(0.6),
                                                  AppColor.colorBlack.withOpacity(0.3),
                                                  AppColor.colorBlack.withOpacity(0),
                                                ],
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                              ),
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(4.0),
                                                bottomRight: Radius.circular(4.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        data.name ?? '',
                                        style: AppFontStyle.styleW600(AppColor.colorWhite, 16),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          capitalizeFirstLetter(data.category ?? ''),
                                          style: AppFontStyle.styleW500(AppColor.primaryColor, 11),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        data.description ?? '',
                                        style: AppFontStyle.styleW500(AppColor.colorIconGrey, 13),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ).paddingSymmetric(horizontal: 10),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }
}

class SearchItemView extends StatelessWidget {
  const SearchItemView({super.key, this.data, required this.isShowCategory, required this.index});

  final dynamic data;
  final bool isShowCategory;
  final int index;

  @override
  Widget build(BuildContext context) {
    String capitalizeFirstLetter(String input) {
      if (input.isEmpty) return input;
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }

    LinearGradient getGradientForIndex(int index) {
      if (index == 1) {
        return const LinearGradient(
          colors: [Colors.orangeAccent, Colors.yellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      } else if (index == 2) {
        return const LinearGradient(
          colors: [Color(0xff64B5F6), Color(0xffE3F2FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      } else if (index == 3) {
        return const LinearGradient(
          colors: [Color(0xffEF9A9A), Color(0xffFFEBEE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      } else {
        return const LinearGradient(
          colors: [
            AppColor.colorTextGrey,
            AppColor.colorTextGrey,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(
            AppRoutes.episodeWiseReels,
            arguments: {
              "movieSeriesId": data.id ?? "",
              "totalVideos": 0,
            },
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 140,
                width: 110,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: data.thumbnail ?? '',
                      placeholder: (context, url) => Center(
                        child: Image.asset(
                          AppAsset.placeHolderImage,
                          color: AppColor.colorIconGrey,
                        ).paddingAll(16),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: ClipPath(
                        clipper: BadgeTriangleClipper(),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: getGradientForIndex(index),
                          ),
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: index <= 3 ? -18 : -12,
                      left: 2,
                      child: Text(
                        '$index',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: index <= 3 ? 80 : 60,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          shadows: index <= 3
                              ? [
                                  Shadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 3,
                                    color: index == 1
                                        ? Colors.orangeAccent
                                        : index == 2
                                            ? const Color(0xff64B5F6)
                                            : const Color(0xffEF9A9A),
                                  ),
                                ]
                              : [
                                  const Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                    color: AppColor.colorWhite,
                                  )
                                ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.colorBlack.withOpacity(0.6),
                              AppColor.colorBlack.withOpacity(0.3),
                              AppColor.colorBlack.withOpacity(0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(4.0),
                            bottomRight: Radius.circular(4.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.name ?? '',
                    style: AppFontStyle.styleW600(AppColor.colorWhite, 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      capitalizeFirstLetter(data.category?.name ?? ''),
                      style: AppFontStyle.styleW500(AppColor.primaryColor, 11),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.description ?? '',
                    style: AppFontStyle.styleW500(AppColor.colorIconGrey, 13),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ).paddingSymmetric(horizontal: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchHistoryChips extends StatelessWidget {
  const SearchHistoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchScreenController>(
      id: 'searchHistory',
      builder: (controller) {
        return Wrap(
          spacing: 8.0,
          children: controller.searchHistory.map((term) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.colorWhite.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    term,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  if (controller.isShowClearHistory) ...[
                    6.width,
                    GestureDetector(
                      onTap: () {
                        controller.deleteHistoryItem(term);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColor.colorIconGrey),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
