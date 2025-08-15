import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_box/utils/color.dart';

class CarouselShimmer extends StatelessWidget {
  const CarouselShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColor.shimmerBaseColor,
        highlightColor: Colors.grey.shade700,
        child: SizedBox(
          height: Get.height * 0.6,
          child: Center(
            child: Container(
              width: Get.width / 1.25,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.shimmer,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: AppColor.colorWhite.withOpacity(0.4),
                  width: 1.0,
                ),
              ),
            ).paddingAll(16),
          ),
        ));
  }
}
