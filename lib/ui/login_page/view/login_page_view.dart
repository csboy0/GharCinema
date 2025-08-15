import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/main.dart';
import 'package:story_box/ui/login_page/controller/login_page_controller.dart';
import 'package:story_box/utils/asset.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: Get.width,
              height: Get.height,
              child: Image.asset(
                AppAsset.icLoginBg,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  const Spacer(),
                  Image.asset(
                    'assets/icons/app_logo.png', // Add your logo here
                    height: 90,
                  ),
                  20.height,
                  // App Title
                  Text(
                    "Ghar Cinema",
                    style: AppFontStyle.styleW800(
                      AppColor.colorWhite,
                      36,
                    ),
                  ),
                  10.height,
                  Text(
                    EnumLocal.welcomeToStoryBox.name.tr,
                    style: AppFontStyle.styleW500(
                      AppColor.colorWhite,
                      22,
                    ),
                  ),
                  30.height,
                  // Continue with Guest Button
                  GetBuilder<LoginPageController>(
                    builder: (controller) {
                      return AppLoginButton(
                        image: AppAsset.icProfile,
                        label: EnumLocal.continueWithGuest.name.tr,
                        color: AppColor.transparent,
                        textColor: AppColor.colorWhite,
                        onTap: () {
                          controller.onGuestLogin();
                        },
                      );
                    },
                  ),
                  // Sign in with Google Button
                  GetBuilder<LoginPageController>(
                    builder: (controller) {
                      return AppLoginButton(
                        image: AppAsset.icGoogle,
                        label: EnumLocal.signInWithGoogle.name.tr,
                        color: AppColor.transparent,
                        onTap: () {
                          controller.onGoogleLogin();
                          // Handle Google Login
                        },
                      );
                    },
                  ),

                  // Continue with Apple Button
                  if (Platform.isIOS)
                    GetBuilder<LoginPageController>(
                      builder: (controller) {
                        return AppLoginButton(
                          image: AppAsset.icApple,
                          label: EnumLocal.continueWithApple.name.tr,
                          color: AppColor.colorWhite,
                          textColor: AppColor.colorBlack,
                          onTap: () {
                            controller.loginWithApple();
                            // Handle Apple Login
                          },
                        );
                      },
                    ),
                  const Spacer(),
                  // Terms of Service and Privacy Policy
                  Text(
                    EnumLocal.ifYouContinueYouAgree.name.tr,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  14.height
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppLoginButton extends StatelessWidget {
  final String? image;
  final String label;
  final Color color;
  final Color? textColor;
  final VoidCallback onTap;

  const AppLoginButton({
    super.key,
    this.image,
    required this.label,
    required this.color,
    required this.onTap,
    this.textColor = AppColor.colorWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: color, // Background color of the button
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
              border: Border.all(
                color: AppColor.colorWhite, // Border color
                width: 1.0, // Border width
              )),
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
          width: double.infinity, // Full width buttons
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image != null ? Image.asset(image!, height: 24, width: 24) : const SizedBox(),
              const SizedBox(width: 10), // Space between image and label
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
