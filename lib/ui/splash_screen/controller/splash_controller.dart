import 'dart:developer';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/login_page/model/login_user_model.dart';
import 'package:story_box/ui/profile_page/api/profile_api.dart';
import 'package:story_box/utils/branch_io_services.dart';
import 'package:story_box/utils/preference.dart';
import '../../../notification/notification_service.dart';
import '../../../utils/utils.dart';

class SplashScreenController extends GetxController {
  bool isLoading = false;
  LoginUserModel? loginUserModel;

  @override
  Future<void> onInit() async {
    NotificationServices.initFirebase();
    Future.delayed(const Duration(seconds: 3), () async {
      if (Preference.isLogin) {
        BranchIoServices.onListenBranchIoLinks();
        Get.offAllNamed(AppRoutes.bottomBarPage);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });

    log("Preference.isLogin${Preference.isLogin}");
    loginUserModel = await ProfileApi.callApi();

    if (loginUserModel?.message == "User does not found!") {
      Utils.showToast(Get.context!, "User does not found!");
      Preference.clear();
      Preference.clearWatchedVideos();
      GoogleSignIn().signOut();
      log("not found");
      Get.offAllNamed(AppRoutes.login);

      return;
    }
    super.onInit();
  }
}
