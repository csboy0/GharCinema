import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlurWidget extends StatelessWidget {
  final Widget child;
  final double blurAmount;

  const BlurWidget({
    super.key,
    required this.child,
    this.blurAmount = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.6,
      child: Stack(
        children: [
          child, //
          SizedBox(
            height: Get.height * 0.6,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
              child: Container(
                height: Get.height * 0.6,
                width: Get.width,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
