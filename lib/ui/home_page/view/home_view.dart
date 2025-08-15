import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/ui/home_page/controller/home_controller.dart';
import 'package:story_box/ui/home_page/widget/home_widget.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';

class HomeViewPage extends StatelessWidget {
  const HomeViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            // Update opacity based on scroll position
            if (scrollNotification.metrics.axis == Axis.vertical) {
              homeController.updateAppBarOpacity(scrollNotification.metrics.pixels);
              log("Vertical Scroll position: ${scrollNotification.metrics.pixels}");
            }
          }
          return true;
        },
        child: RefreshIndicator(
          color: AppColor.colorBlack,
          onRefresh: () async {
            await 400.milliseconds.delay();
            await homeController.onRefresh();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const HomeAppBar(),
              SliverToBoxAdapter(
                child: GetBuilder<HomeController>(
                  id: Constant.idMostTrending,
                  builder: (context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CarouselBlurBackground(),
                        18.height,
                        // if (homeController.trendingMovieSeriesModel?.data != null &&
                        //     homeController.trendingMovieSeriesModel!.data!.isNotEmpty)
                        MostTrendingBuilderView(),
                        const SizedBox(height: 18),
                        const ContinueWatchingBuilderView(),
                        if (homeController.newReleasesVideoModel?.videos != null &&
                            homeController.newReleasesVideoModel!.videos!.isNotEmpty)
                          const NewReleaseBuilderView(),
                        // const ComingSoonBuilderView(),
                        if (homeController.getMoviesGroupedByCategoryModel?.groupedMovies != null &&
                            homeController.getMoviesGroupedByCategoryModel!.groupedMovies!.isNotEmpty)
                          GetBuilder<HomeController>(
                            builder: (logic) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: logic.getMoviesGroupedByCategoryModel?.groupedMovies?.length ?? 0,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return CustomCategoryWiseBuilderView(
                                    title: logic.getMoviesGroupedByCategoryModel?.groupedMovies?[index].categoryName ?? '',
                                    moviesList: logic.getMoviesGroupedByCategoryModel?.groupedMovies?[index].movies ?? [],
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
