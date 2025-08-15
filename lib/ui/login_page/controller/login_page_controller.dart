import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:story_box/custom_widget/platfrom_id.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/login_page/api/login_api.dart';
import 'package:story_box/ui/login_page/model/login_user_model.dart';
import 'package:story_box/utils/custom_progress_dialog.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/preference.dart';
import 'package:story_box/utils/utils.dart';

class LoginPageController extends GetxController {
  LoginUserModel? loginUserModel;

  @override
  void onInit() async {
    /// FCM Token
    final fcmToken = await FirebaseMessaging.instance.getToken();

    /// Device Id
    final identity = await PlatformDeviceId.getDeviceId;
    Utils.showLog("Device Id => $identity");
    Utils.showLog("FCM Token => $fcmToken");
    log("FCM Token => $fcmToken");
    log("identity => $identity");

    if (identity != null && fcmToken != null) {
      Preference.onSetFcmToken(fcmToken);
      Preference.onSetIdentity(identity);
    }
    super.onInit();
  }

  // Future<void> onGoogleLogin() async {
  //   try {
  //     // Show loader
  //     Get.dialog(const CustomProgressDialog());
  //
  //     UserCredential? userCredential = await signInWithGoogle();
  //
  //     if (userCredential?.user?.email != null) {
  //       loginUserModel = await LoginApi.callApi(
  //         loginType: Utils.getLoginTypeValue(LoginType.GOOGLE),
  //         email: userCredential?.user?.email ?? "",
  //         identity: Preference.identity ,
  //         fcmToken: Preference.fcmToken ,
  //         name: userCredential?.user?.displayName ?? "",
  //         profilePic: userCredential?.user?.photoURL ?? '',
  //       );
  //
  //       // Calling Sign Up Api...
  //       if (loginUserModel != null) {
  //         if (loginUserModel?.status == true) {
  //           String loginUserJson = jsonEncode(loginUserModel?.user?.toJson());
  //           await Preference.shared.setString(Preference.userData, loginUserJson);
  //           await Preference.onSetUserID(loginUserModel?.user?.id ?? "");
  //           Get.offAllNamed(AppRoutes.bottomBarPage);
  //           await Preference.onIsLogin(true);
  //           log("message UserID :: ${Preference.userId}");
  //         } else {
  //           Utils.showToast(Get.context!, loginUserModel?.message ?? "");
  //         }
  //       }
  //
  //       String? userDataJson = Preference.shared.getString(Preference.userData);
  //       if (userDataJson != null) {
  //         Map<String, dynamic> userMap = jsonDecode(userDataJson);
  //         LoginUserModel loginUserModel = LoginUserModel.fromJson(userMap);
  //         log("loginUserModel :: ${loginUserModel.toJson()}");
  //       }
  //     } else {
  //       Utils.showToast(Get.context!, EnumLocal.txtSomeThingWentWrong.name.tr);
  //       Utils.showLog("Google Login Failed !!");
  //     }
  //   } catch (e) {
  //     log("Error in Google Login: $e");
  //     Utils.showToast(Get.context!, "An error occurred during login.");
  //   } finally {
  //     // Dismiss the loader
  //     if (Get.isDialogOpen ?? false) {
  //       Get.back();
  //     }
  //   }
  // }


  ///new

  Future<void> onGoogleLogin() async {
    try {
      // Show loader
      Get.dialog(const CustomProgressDialog());

      UserCredential? userCredential = await signInWithGoogle();

      if (userCredential?.user?.email != null) {
        loginUserModel = await LoginApi.callApi(
          loginType: Utils.getLoginTypeValue(LoginType.GOOGLE),
          email: userCredential?.user?.email ?? "",
          identity: Preference.identity,
          fcmToken: Preference.fcmToken,
          name: userCredential?.user?.displayName ?? "",
          profilePic: userCredential?.user?.photoURL ?? '',
        );

        if (loginUserModel != null) {
          if (loginUserModel?.status == true) {
            // Success - proceed with login
            String loginUserJson = jsonEncode(loginUserModel?.user?.toJson());
            await Preference.shared.setString(Preference.userData, loginUserJson);
            await Preference.onSetUserID(loginUserModel?.user?.id ?? "");
            await Preference.onIsLogin(true);
            Get.offAllNamed(AppRoutes.bottomBarPage);
            log("message UserID :: ${Preference.userId}");
          } else {
            // API returned failure - clean up Google session
            await _cleanupGoogleSession();
            Utils.showToast(Get.context!, loginUserModel?.message ?? "");
          }
        } else {
          // API call failed - clean up Google session
          await _cleanupGoogleSession();
          Utils.showToast(Get.context!, "Login failed. Please try again.");
        }
      } else {
        Utils.showToast(Get.context!, EnumLocal.txtSomeThingWentWrong.name.tr);
        Utils.showLog("Google Login Failed !!");
      }
    } catch (e) {
      // Any error - clean up Google session
      await _cleanupGoogleSession();
      log("Error in Google Login: $e");
      Utils.showToast(Get.context!, "An error occurred during login.");
    } finally {
      // Dismiss the loader
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  Future<void> _cleanupGoogleSession() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Utils.showLog("Google session cleaned up");
    } catch (e) {
      Utils.showLog("Error cleaning up Google session: $e");
    }
  }

  onGuestLogin() async {
    try {
      Get.dialog(const CustomProgressDialog());
      loginUserModel = await LoginApi.callApi(
        loginType: Utils.getLoginTypeValue(LoginType.QUICK),
        email: Preference.identity,
        identity: Preference.identity,
        fcmToken: Preference.fcmToken,
        name: "Guest",
      );

      if (loginUserModel != null) {
        if (loginUserModel?.status == true) {
          String loginUserJson = jsonEncode(loginUserModel?.user?.toJson());
          await Preference.shared.setString(Preference.userData, loginUserJson);
          await Preference.onSetUserID(loginUserModel?.user?.id ?? "");
          await Preference.onIsLogin(true);
          Get.offAllNamed(AppRoutes.bottomBarPage);
          log("message UserID :: ${Preference.userId}");
        } else {
          Utils.showToast(Get.context!, loginUserModel?.message ?? "");
        }
      }
      String? userDataJson = Preference.shared.getString(Preference.userData);
      if (userDataJson != null) {
        Map<String, dynamic> userMap = jsonDecode(userDataJson);
        LoginUserModel loginUserModel = LoginUserModel.fromJson(userMap);
        // Use the loginUserModel as needed
        log("loginUserModel :: ${loginUserModel.toJson()}");
      }
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  loginWithApple() async {
    try {
      Get.dialog(const CustomProgressDialog());
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      var auth = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final user = auth.user;
      log("oauthCredential :: $oauthCredential");
      log("user :: $user");
      if (user != null) {
        ///=====CALL API======///
        loginUserModel = await LoginApi.callApi(
          loginType: Utils.getLoginTypeValue(LoginType.APPLE),
          email: user.email ?? "",
          identity: Preference.identity,
          fcmToken: Preference.fcmToken ,
          name: user.email ?? "",
          profilePic: user.photoURL ?? '',
        );
        if (loginUserModel != null) {
          String loginUserJson = jsonEncode(loginUserModel?.user?.toJson());
          await Preference.shared.setString(Preference.userData, loginUserJson);
          await Preference.onSetUserID(loginUserModel?.user?.id ?? "");
          await Preference.onIsLogin(true);
          Get.offAllNamed(AppRoutes.bottomBarPage);
          log("message UserID :: ${Preference.userId}");
        } else {
          Utils.showToast(Get.context!, loginUserModel?.message ?? "");
        }
        String? userDataJson = Preference.shared.getString(Preference.userData);
        if (userDataJson != null) {
          Map<String, dynamic> userMap = jsonDecode(userDataJson);
          LoginUserModel loginUserModel = LoginUserModel.fromJson(userMap);
          // Use the loginUserModel as needed
          log("loginUserModel :: ${loginUserModel.toJson()}");
        }
      }
    } catch (e) {
      Utils.showToast(Get.context!, EnumLocal.txtSomeThingWentWrong.name.tr);
      log(" $e");
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  // static Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //     final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
  //     final result = await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //     Utils.showLog("Google Login Email => ${result.user?.email}");
  //
  //     Utils.showLog("Google Login isNewUser => ${result.additionalUserInfo?.isNewUser}");
  //
  //     return result;
  //   } catch (error) {
  //     Utils.showLog("Google Login Error => $error");
  //   }
  //   return null;
  // }

///new


  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Sign out first to ensure account selection dialog appears
      await GoogleSignIn().signOut();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        Utils.showLog("Google Sign-In canceled by user");
        return null;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken
      );
      final result = await FirebaseAuth.instance.signInWithCredential(credential);

      Utils.showLog("Google Login Email => ${result.user?.email}");
      Utils.showLog("Google Login isNewUser => ${result.additionalUserInfo?.isNewUser}");

      return result;
    } catch (error) {
      Utils.showLog("Google Login Error => $error");
      return null;
    }
  }

}
