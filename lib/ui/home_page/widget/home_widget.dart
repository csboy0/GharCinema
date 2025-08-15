import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:story_box/custom_widget/custom_blur_widget.dart';
import 'package:story_box/main.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/shimmer/carousel_shimmer.dart';
import 'package:story_box/shimmer/most_trending_shimmer.dart';
import 'package:story_box/shimmer/new_release_shimmer.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/home_page/model/get_movies_grouped_by_category_model.dart';
import 'package:story_box/ui/home_page/model/new_releases_video_model.dart';
import 'package:story_box/ui/home_page/model/trending_movie_series_model.dart';
import 'package:story_box/ui/home_page/view/view_all_page.dart';
import 'package:story_box/utils/app_button.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/dummy_data.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/utils.dart';

///   ------------>>>>>> Home App Bar <<<<<<<<<<-------------
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return SliverAppBar(
          backgroundColor: Colors.black.withOpacity(controller.appBarOpacity),
          pinned: true,
          expandedHeight: 60.0,
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: Container(
                    color: Colors.black.withOpacity(controller.appBarOpacity),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 14.0,
                        top: 20.0,
                        left: 14.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            EnumLocal.txtAppName.name.tr,
                            style: AppFontStyle.styleW800(AppColor.colorWhite, 26),
                          ),
                          const Spacer(),
                          GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.search);
                              },
                              child: Image.asset(AppAsset.icSearch, width: 28, color: Colors.white)),
                          const SizedBox(width: 16),
                          GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.rewards);
                              },
                              child: Lottie.asset(AppAsset.lottieGift, height: 50, width: 50)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

///   ------------>>>>>> Carousel <<<<<<<<<<-------------
// class CarouselImageView extends StatelessWidget {
//   const CarouselImageView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<HomeController>(
//       id: Constant.idHomeCarousel,
//       builder: (logic) {
//         final movies = logic.getMoviesSeriesModel?.data;
//
//         if (movies == null || movies.isEmpty) {
//           // Show a placeholder or loader when data is null or empty
//           // return SizedBox(
//           //   height: Get.height * 0.6,
//           //   child: const Center(
//           //     child: Text(
//           //       'No data available',
//           //       style: TextStyle(color: Colors.white),
//           return const CarouselShimmer();
//         }
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CarouselSlider(
//               carouselController: logic.controller,
//               items: movies.map((movie) {
//                 if (movie.thumbnail == null) {
//                   // Handle null thumbnail case
//                   return Center(
//                     child: Text(
//                       EnumLocal.noImage.name.tr,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   );
//                 }
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: [
//                         Container(
//                           width: double.infinity,
//                           height: double.infinity,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20.0),
//                             border: Border.all(
//                               color: AppColor.colorWhite.withOpacity(0.4),
//                               width: 1.0,
//                             ),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(20.0),
//                             child: CachedNetworkImage(
//                               imageUrl: movie.thumbnail!,
//                               placeholder: (context, url) => Image.asset(
//                                 AppAsset.placeHolderImage,
//                                 // fit: BoxFit.cover,
//                                 height: 40, width: 50,
//                                 color: AppColor.colorIconGrey,
//                               ),
//                               fit: BoxFit.cover,
//                               errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
//                             ),
//                           ),
//                         ),
//                         // Other UI elements...
//                         GestureDetector(
//                           onTap: () {
//                             Get.toNamed(
//                               AppRoutes.episodeWiseReels,
//                               arguments: {
//                                 "movieSeriesId": movie.id ?? "",
//                                 "totalVideos": 0,
//                               },
//                             );
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
//                             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Icon(Icons.play_arrow),
//                                 2.width,
//                                 Text(EnumLocal.play.name.tr, style: AppFontStyle.styleW800(AppColor.colorBlack, 14)),
//                               ],
//                             ),
//                           ).paddingOnly(bottom: 16),
//                         )
//                       ],
//                     );
//                   },
//                 );
//               }).toList(),
//               options: CarouselOptions(
//                 height: Get.height * 0.58,
//                 autoPlay: true,
//                 enlargeCenterPage: true,
//                 onPageChanged: (int index, CarouselPageChangedReason reason) {
//                   logic.onPageChanged(index, reason);
//                 },
//               ),
//             ),
//             const SizedBox(height: 9),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: movies.asMap().entries.map((entry) {
//                 return Container(
//                   margin: const EdgeInsets.only(left: 3, right: 3, top: 12),
//                   height: logic.initialPage == entry.key ? 4 : 3,
//                   width: logic.initialPage == entry.key ? 22 : 14,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: logic.initialPage == entry.key ? Colors.white : Colors.grey,
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }





class CarouselImageView extends StatelessWidget {
  const CarouselImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: Constant.idHomeCarousel,
      builder: (logic) {
        final movies = logic.getMoviesSeriesModel?.data;

        if (movies == null || movies.isEmpty) {
          return const CarouselShimmer();
        }

        final double carouselHeight = Get.height * 0.58;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider(
              carouselController: logic.controller,
              items: movies.map((movie) {
                if (movie.thumbnail == null || movie.thumbnail!.isEmpty) {
                  return Center(
                    child: Text(
                      EnumLocal.noImage.name.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: carouselHeight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: AppColor.colorWhite.withOpacity(0.4),
                              width: 1.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: CachedNetworkImage(
                              imageUrl: movie.thumbnail!,
                              placeholder: (context, url) => Image.asset(
                                AppAsset.placeHolderImage,
                                fit: BoxFit.cover,
                                color: AppColor.colorIconGrey,
                                height: carouselHeight,
                                width: double.infinity,
                              ),
                              fit: BoxFit.cover,
                              height: carouselHeight,
                              width: double.infinity,
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.episodeWiseReels,
                              arguments: {
                                "movieSeriesId": movie.id ?? "",
                                "totalVideos": 0,
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.play_arrow),
                                2.width,
                                Text(
                                  EnumLocal.play.name.tr,
                                  style: AppFontStyle.styleW800(
                                      AppColor.colorBlack, 14),
                                ),
                              ],
                            ),
                          ).paddingOnly(bottom: 16),
                        )
                      ],
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: carouselHeight,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  logic.onPageChanged(index, reason);
                },
              ),
            ),
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: movies.asMap().entries.map((entry) {
                bool isActive = logic.initialPage == entry.key;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin:
                  const EdgeInsets.only(left: 3, right: 3, top: 12),
                  height: isActive ? 4 : 3,
                  width: isActive ? 22 : 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isActive ? Colors.white : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}











/// ------------>>>>>> Carousel Blur Background <<<<<<<<----------------

class CarouselBlurBackground extends StatelessWidget {
  const CarouselBlurBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: Constant.idHomeBlurCarousel,
      builder: (logic) {
        return Stack(
          children: [
            BlurWidget(
              blurAmount: 50.0,
              child: SizedBox(
                height: Get.height * 0.58,
                width: Get.width,
                child: CachedNetworkImage(
                  imageUrl: logic.getMoviesSeriesModel?.data?[logic.initialPage].thumbnail ?? "",
                  placeholder: (context, url) => Image.asset(
                    AppAsset.placeHolderImage,
                    fit: BoxFit.cover,
                    height: 40,
                    color: AppColor.colorIconGrey,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0),
              child: CarouselImageView(),
            ),
          ],
        );
      },
    );
  }
}

///   ------------>>>>>> Most Trending View <<<<<<<<<<-------------

class MostTrendingBuilderView extends StatelessWidget {
  MostTrendingBuilderView({super.key});

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    if (homeController.trendingMovieSeriesModel?.data != null && homeController.trendingMovieSeriesModel!.data!.isNotEmpty) {
      const SizedBox.shrink();
    }
    return GetBuilder<HomeController>(
      id: Constant.idMostTrending,
      builder: (logic) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${EnumLocal.mostTrending.name.tr} 🚀",
              style: AppFontStyle.styleW800(AppColor.colorWhite, 24),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    AppColor.colorButtonPink.withOpacity(0.2),
                    AppColor.colorBlack.withOpacity(0.1),
                    AppColor.colorBlack.withOpacity(0.2),
                    AppColor.colorBlack.withOpacity(0.0)
                  ],
                ),
              ),
              height: Get.height * 0.4,
              child: logic.isLoadingMostTrending
                  ? const MostTrendingShimmer()
                  : GridView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: logic.trendingMovieSeriesModel?.data?.length ?? 0,
                      itemBuilder: (context, index) => GetBuilder<HomeController>(
                        builder: (logic) {
                          return MostTrendingItemView(
                            index: index + 1,
                            trendingMoviesSeriesData: logic.trendingMovieSeriesModel?.data?[index] ?? TrendingMoviesSeriesData(),
                          );
                        },
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of rows
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        mainAxisExtent: 200, // Width of each item
                      ),
                    ),
            ),
          ],
        ).paddingOnly(left: 12);
      },
    );
  }
}

///   ------------>>>>>> Most Trending Item View <<<<<<<<<<-------------

class MostTrendingItemView extends StatelessWidget {
  final TrendingMoviesSeriesData trendingMoviesSeriesData;
  final int index;

  const MostTrendingItemView({super.key, required this.trendingMoviesSeriesData, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.episodeWiseReels,
          arguments: {
            "movieSeriesId": trendingMoviesSeriesData.id ?? "",
            "totalVideos": 0,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // Movie Thumbnail Image



                // old
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: trendingMoviesSeriesData.thumbnail ?? " ",
                    placeholder: (context, url) => Image.asset(
                      AppAsset.placeHolderImage,
                      color: AppColor.colorIconGrey,
                    ).paddingAll(12),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                    height: 110,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),


                // ClipRRect(
                //   borderRadius: BorderRadius.circular(10),
                //   child: CachedNetworkImage(
                //     imageUrl: trendingMoviesSeriesData.thumbnail ?? " ",
                //     placeholder: (context, url) => Image.asset(
                //       AppAsset.placeHolderImage,
                //       color: AppColor.colorIconGrey,
                //       fit: BoxFit.cover,
                //     ).paddingAll(12),
                //     errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                //     fit: BoxFit.cover,
                //   ),
                // ),

                // Triangle Badge
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
                // Text Half on Triangle and Half on Image
                Positioned(
                  bottom: index <= 3 ? -14 : 1,
                  left: index <= 3
                      ? 2
                      : index >= 10
                          ? 1
                          : 5,
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: index <= 3 ? 60 : 12,
                      fontWeight: index <= 3 ? FontWeight.bold : FontWeight.w400,
                      fontStyle: index <= 3 ? FontStyle.italic : FontStyle.normal,
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
                          : [],
                    ),
                  ),
                ),
              ],
            ),
            4.width,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trendingMoviesSeriesData.name ?? "",
                      style: AppFontStyle.styleW800(AppColor.colorWhite, 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      trendingMoviesSeriesData.category?.name ?? "",
                      style: AppFontStyle.styleW600(AppColor.colorWhite.withOpacity(0.7), 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          AppColor.colorPrimary,
          AppColor.colorSecondary,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }
}

class BadgeTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double cornerRadius = 10.0;

    Path path = Path();
    path.moveTo(0, size.height - cornerRadius);
    path.quadraticBezierTo(0, size.height, cornerRadius, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BadgeTriangleClipper oldClipper) => false;
}

///   ------------>>>>>> Continue Watching View <<<<<<<<<<-------------

class ContinueWatchingBuilderView extends StatelessWidget {
  const ContinueWatchingBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: Constant.idGetHistory,
      builder: (homeController) {
        if (homeController.watchedVideos.isEmpty) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              EnumLocal.continueWatching.name.tr,
              style: AppFontStyle.styleW800(AppColor.colorWhite, 24),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 225,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: homeController.watchedVideos.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ContinueWatchingItemView(
                    data: homeController.watchedVideos[index],
                  );
                },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 12);
      },
    );
  }
}

///   ------------>>>>>> Continue Watching Item View <<<<<<<<<<-------------

class ContinueWatchingItemView extends StatelessWidget {
  final dynamic data;

  const ContinueWatchingItemView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // double progressValue = 0.4;

    double progressValue = 0.0;
    int totalEpisodes = data['totalEpisodes'] ?? 0;
    int lastEpisode = data['lastEpisode'] ?? 0;

    if (totalEpisodes > 0) {
      progressValue = lastEpisode / totalEpisodes;
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.episodeWiseReels,
          arguments: {
            "movieSeriesId": data['id'] ?? "",
            "totalVideos": data['totalEpisodes'] ?? 0,
            "playIndex": data['lastEpisode'] ?? 0,
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 150,
                  width: 110,
                  child: Stack(
                    children: [
                      // Image
                      CachedNetworkImage(
                        imageUrl: data['thumbnail'],
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
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                          child: const Icon(Icons.play_arrow_rounded, color: AppColor.colorWhite, size: 25),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColor.colorButtonPink),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Flexible(
                child: Text(
                  data['title'],
                  style: AppFontStyle.styleW800(AppColor.colorWhite, 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'EP.${data['lastEpisode']}', style: AppFontStyle.styleW600(AppColor.colorButtonPink, 11)),
                    TextSpan(
                      text: '/EP.${data['totalEpisodes']}',
                      style: AppFontStyle.styleW600(AppColor.colorWhite, 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///   ------------>>>>>> New Release View <<<<<<<<<<-------------

class NewReleaseBuilderView extends StatelessWidget {
  const NewReleaseBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (logic) {
        const int maxItemsToShow = 10;
        final bool hasMoreItems = (logic.newReleasesVideoModel?.videos?.length ?? 0) > maxItemsToShow;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  EnumLocal.newRelease.name.tr,
                  style: AppFontStyle.styleW800(AppColor.colorWhite, 24),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => ViewAllPage(
                        videos: logic.newReleasesVideos.map((video) => video.toJson()).toList(),
                        title: EnumLocal.newRelease.name.tr,
                        isNewRelease: true,
                      ),
                    );
                  },
                  child: Container(
                    color: AppColor.transparent,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 14, top: 5, bottom: 5),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor.colorWhite,
                        size: 14,
                      ),
                    ),
                  ),
                )
              ],
            ),
            10.height,
            SizedBox(
              height: 225,
              child: logic.isLoadingMostTrending
                  ? const NewReleaseShimmer()
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: hasMoreItems ? maxItemsToShow + 1 : logic.newReleasesVideoModel?.videos?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (hasMoreItems && index == maxItemsToShow) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => ViewAllPage(
                                    videos: logic.newReleasesVideos.map((video) => video.toJson()).toList(),
                                    title: EnumLocal.newRelease.name.tr,
                                    isNewRelease: true,
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 150,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white12,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            color: AppColor.transparent,
                                            child: const Icon(Icons.arrow_forward_ios, color: AppColor.colorWhite, size: 12)),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          EnumLocal.more.name.tr,
                                          style: AppFontStyle.styleW400(AppColor.colorWhite, 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return NewReleaseItemView(
                            newReleasesVideos: logic.newReleasesVideoModel?.videos?[index] ?? NewReleasesVideos(),
                          );
                        }
                      },
                    ),
            ),
          ],
        );
      },
    ).paddingSymmetric(horizontal: 12);
  }
}

///   ------------>>>>>> New Release Item View <<<<<<<<<<-------------

class NewReleaseItemView extends StatelessWidget {
  final NewReleasesVideos newReleasesVideos;

  const NewReleaseItemView({super.key, required this.newReleasesVideos});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.episodeWiseReels,
          arguments: {
            "movieSeriesId": newReleasesVideos.id ?? "",
            "totalVideos": 0,
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 150,
                  width: 110,
                  child: Stack(
                    children: [
                      // Image
                      CachedNetworkImage(
                        imageUrl: newReleasesVideos.thumbnail ?? "",
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
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColor.colorButtonPink),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                              child: Text(EnumLocal.newText.name.tr, style: AppFontStyle.styleW800(AppColor.colorWhite, 10)),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              AppColor.colorBlack.withOpacity(0.6),
                              AppColor.colorBlack.withOpacity(0.3),
                              AppColor.colorBlack.withOpacity(0)
                            ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(4.0), bottomRight: Radius.circular(4.0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.play_arrow_rounded, color: AppColor.colorWhite, size: 22),
                              Text(CustomFormatNumber.convert(newReleasesVideos.views?.toInt() ?? 0),
                                  style: AppFontStyle.styleW800(AppColor.colorWhite, 11)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Flexible(
                child: Text(
                  newReleasesVideos.name ?? "",
                  style: AppFontStyle.styleW800(AppColor.colorWhite, 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///   ------------>>>>>> Coming Soon Builder View <<<<<<<<<<-------------

class ComingSoonBuilderView extends StatelessWidget {
  const ComingSoonBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${EnumLocal.comingSoon.name.tr} 🌸",
          style: AppFontStyle.styleW800(AppColor.colorWhite, 24),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 285, // Set a fixed height for the ListView
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: DummyData.imageList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                // Normal item display
                return ComingSoonItemView(
                  image: DummyData.imageList[index],
                );
              }),
        ),
      ],
    ).paddingSymmetric(horizontal: 12);
  }
}

///   ------------>>>>>> Coming Soon Item View <<<<<<<<<<-------------

class ComingSoonItemView extends StatelessWidget {
  final String image;

  const ComingSoonItemView({super.key, this.image = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "2 Oct",
                  style: AppFontStyle.styleW400(AppColor.colorWhite, 12),
                ),
                const Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Divider(
                    thickness: 0.5,
                  ),
                )),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8), // Ensuring the image and progress bar have rounded corners
              child: SizedBox(
                height: 210, // Set height for each item if needed
                width: 140,
                child: Stack(
                  children: [
                    // Image
                    CachedNetworkImage(
                      imageUrl: image,
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.colorBlack.withOpacity(0.9),
                                AppColor.colorBlack.withOpacity(0),
                              ],
                              stops: const [0.3, 0.9], // You can adjust these based on your design.
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(4.0), bottomRight: Radius.circular(4.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppButton(
                              backgroundColor: AppColor.colorWhite.withOpacity(0.6),
                              icon: Icons.notifications_rounded,
                              iconColor: AppColor.colorWhite,
                              text: "Remind Me",
                              textColor: AppColor.colorWhite,
                              iconSize: 14,
                              textSize: 12,
                              borderRadius: 6.0,
                              onPressed: () {
                                // Add notify me button action here
                              },
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Flexible(
              child: Text(
                'The Virgin and The Billionaire',
                style: AppFontStyle.styleW800(AppColor.colorWhite, 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///   ------------>>>>>> Custom Category Wise Builder View <<<<<<<<<<-------------

class CustomCategoryWiseBuilderView extends StatelessWidget {
  final String title;
  final List<Movies> moviesList;
  final int maxItemsToShow;

  const CustomCategoryWiseBuilderView({
    super.key,
    required this.title,
    required this.moviesList,
    this.maxItemsToShow = 5,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasMoreItems = moviesList.length > maxItemsToShow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title.capitalizeFirst ?? '',
              style: AppFontStyle.styleW800(AppColor.colorWhite, 24),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.to(
                  () => ViewAllPage(
                    videos: moviesList.map((video) => video.toJson()).toList(),
                    title: title,
                  ),
                );
              },
              child: Container(
                color: AppColor.transparent,
                child: const Padding(
                  padding: EdgeInsets.only(left: 16, top: 5, bottom: 5),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.colorWhite,
                    size: 14,
                  ),
                ),
              ),
            )
          ],
        ),
        10.height,
        GetBuilder<HomeController>(
          builder: (logic) {
            return SizedBox(
              height: 225,
              child: logic.isLoadingMostTrending
                  ? const NewReleaseShimmer()
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: hasMoreItems ? maxItemsToShow + 1 : moviesList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (hasMoreItems && index == maxItemsToShow) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 150,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white12,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.arrow_forward_ios, color: AppColor.colorWhite, size: 12),
                                        6.height,
                                        Text(
                                          'More',
                                          style: AppFontStyle.styleW400(AppColor.colorWhite, 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return CategoryWiseItemView(movies: moviesList[index]);
                        }
                      },
                    ),
            );
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 12);
  }
}

/// --------------->>>>>> Category Wise Item View <<<<<<<<<<<

class CategoryWiseItemView extends StatelessWidget {
  final Movies movies;

  const CategoryWiseItemView({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.episodeWiseReels,
          arguments: {
            "movieSeriesId": movies.id ?? "",
            "totalVideos": 0,
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 150,
                  width: 110,
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: movies.thumbnail ?? "",
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
                          child: Row(
                            children: [
                              const Icon(Icons.play_arrow_rounded, color: AppColor.colorWhite, size: 22),
                              Text(CustomFormatNumber.convert(movies.totalViews?.toInt() ?? 0),
                                  style: AppFontStyle.styleW800(AppColor.colorWhite, 11)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  movies.name ?? "",
                  style: AppFontStyle.styleW800(AppColor.colorWhite, 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*Get.bottomSheet(
                                  Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: AppColor.colorBlack,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: SizedBox(
                                      height: Get.height * 0.6, // Adjust height
                                      child: DefaultTabController(
                                        length: 2, // Number of tabs
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Text(
                                                "List (Completed)",
                                                style: TextStyle(color: AppColor.colorWhite),
                                              ),
                                            ),
                                            const TabBar(
                                              indicatorColor: Colors.red,
                                              tabs: [
                                                Tab(text: '0 - 49'),
                                                Tab(text: '50 - 61'),
                                              ],
                                            ),
                                            Expanded(
                                              child: TabBarView(
                                                children: [
                                                  // Tab 1 content
                                                  GridView.builder(
                                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 5, // Number of columns in the grid
                                                      crossAxisSpacing: 6.0,
                                                      mainAxisSpacing: 6.0,
                                                      childAspectRatio: 1.7, // Adjust this to make rectangles
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                                    itemCount: 50, // Total number of items in Tab 1
                                                    itemBuilder: (context, index) {
                                                      // Show 'Trailer' for the 0th index
                                                      if (index == 0) {
                                                        return Container(
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey.shade800, // Different color for trailer
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                          child: const Text(
                                                            'Trailer',
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                        );
                                                      }
                                                      // First 7 episodes are free
                                                      else if (index > 0 && index <= 7) {
                                                        return Container(
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey.shade800, // Free episodes with a green background
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                          child: Text(
                                                            '${index}',
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                        );
                                                      }
                                                      // Other episodes are locked
                                                      else {
                                                        return Container(
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey.shade800, // Locked episodes with grey background
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                          child: Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              Text(
                                                                '${index}',
                                                                style: TextStyle(color: Colors.white),
                                                              ),
                                                              Align(
                                                                alignment: Alignment.topRight,
                                                                child: Container(
                                                                  padding: const EdgeInsets.symmetric(
                                                                      horizontal: 4, vertical: 2),
                                                                  decoration: const BoxDecoration(
                                                                    color: AppColor
                                                                        .colorButtonPink, // Lock icon background color
                                                                    borderRadius: BorderRadius.only(
                                                                      topRight: Radius.circular(8),
                                                                      bottomLeft: Radius.circular(4),
                                                                    ),
                                                                  ),
                                                                  child: const Icon(
                                                                    Icons.lock,
                                                                    color:
                                                                        Colors.white, // Lock icon for locked episodes
                                                                    size: 10,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  // Tab 2 content
                                                  GridView.builder(
                                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 5, // Number of columns in the grid
                                                      crossAxisSpacing: 6.0,
                                                      mainAxisSpacing: 6.0,
                                                      childAspectRatio: 1.7, // Adjust this to make rectangles
                                                    ),
                                                    itemCount: 12, // Total number of items in Tab 2
                                                    itemBuilder: (context, index) {
                                                      return Container(
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.shade800,
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                        child: Text(
                                                          (50 + index).toString(),
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );*/
