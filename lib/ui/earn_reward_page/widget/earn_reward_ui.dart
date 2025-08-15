// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';

class CheckInDialog extends StatefulWidget {
  CheckInDialog({super.key, this.todayCoin});
  String? todayCoin;

  @override
  State<CheckInDialog> createState() => _CheckInDialogState();
}

class _CheckInDialogState extends State<CheckInDialog> {
  bool _showLottie = true;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showLottie = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.transparent,
      child: Stack( alignment: Alignment.center,
        children: [
          Column(
            children: [
              const Spacer(),
              Container(
                width: Get.width,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.black87,
                  image: const DecorationImage(
                    image: AssetImage(AppAsset.icDialogBackground),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 110, child: Image.asset(AppAsset.icGiftDialog)),
                    14.height,
                    const Text(
                      'Check-In Successful',
                      style: TextStyle(
                          color: AppColor.colorLightOrange,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: Constant.appFontFamily),
                    ),
                    50.height,
                    Text(
                      '+${widget.todayCoin}/Coins',
                      style: const TextStyle(
                          color: AppColor.colorLightYellow,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: Constant.appFontFamily),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Spacer(),
            ],
          ),
          if (_showLottie)
          Positioned(
            bottom: 120,
            child: Lottie.asset(
              "assets/lottie/cannon.json",
              // height: Get.height
            ),
          ),
          Positioned(
            bottom: 170,
            child: GestureDetector(
              onTap: () {
                Get.back(); // Close the dialog
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  AppAsset.icClose,
                  color: AppColor.colorWhite,  height: 26,
                  width: 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
