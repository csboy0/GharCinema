import 'dart:io';

import 'package:story_box/ui/setting_view_page/api/setting_api.dart';

abstract class Constant {
  static const languageEn = "en";
  static const countryCodeEn = "US";

  static const responseFailureCode = 400;
  static const responseUnauthenticatedCode = 401;
  static const responseSuccessCode = 200;
  static const responseNeedOTPVerification = 402;
  static double bottomBarSize = Platform.isAndroid ? 65 : 80;

  static const appFontFamily = "Urbanist";

  static const currencySymbol = "₹";

  /// <<===================>> ****** Widget Id's for refresh in GetX ****** <<===================>>

  static const idProgressView = "idProgressView";
  static const idMostTrending = "idMostTrending";
  static const idHomeCarousel = "idHomeCarousel";
  static const idGetHistory = "onGetHistory";
  static const idFavourite = "isFavourite";
  static const idHomeBlurCarousel = "idHomeBlurCarousel";
  static const idBottomBar = "idBottomBar";
  static const idOnChangeBottomBar = "idOnChangeBottomBar";
  static const idChangeLanguage = "idChangeLanguage";

  /// <<====================>> Admin Setting Payment Keys <<====================>>

  static bool googlePlaySwitch = SettingApi.setting?.googlePlaySwitch ?? false;
  static bool stripeSwitch = SettingApi.setting?.stripeSwitch ?? false;
  static bool razorPaySwitch = SettingApi.setting?.razorPaySwitch ?? false;
  static bool flutterWaveSwitch = SettingApi.setting?.flutterWaveSwitch ?? false;

  static String privacyPolicyLink = SettingApi.setting?.privacyPolicyLink ?? "";
  static String termsOfUsePolicyLink = SettingApi.setting?.termsOfUsePolicyLink ?? "";
  static String contactEmail = SettingApi.setting?.contactEmail ?? "";
  static String currencyIcon = SettingApi.setting?.currency?.symbol ??"";

  // static String currencySymbol = SettingApi.setting?.currency?.symbol ?? "";
  static String currencyCode = SettingApi.setting?.currency?.currencyCode ?? "";

  static String stripeMerchantCountryCode = SettingApi.setting?.currency?.countryCode ?? "";

  static String stripeTestSecretKey = SettingApi.setting?.stripeSecretKey ?? "";
  static String stripeTestPublicKey = SettingApi.setting?.stripePublishableKey ?? "";

  static String flutterWaveId = SettingApi.setting?.flutterWaveId ?? "";
  static String razorSecretKey = SettingApi.setting?.razorSecretKey ?? "";

  static String interstitial = SettingApi.setting?.android?.google?.interstitial ?? "";
  static String reward = SettingApi.setting?.android?.google?.reward ?? "";
  static String native = SettingApi.setting?.android?.google?.native ?? "";

  static String interstitialIos = SettingApi.setting?.ios?.google?.interstitial ?? "";
  static String rewardIos = SettingApi.setting?.ios?.google?.reward ?? "";
  static String nativeIos = SettingApi.setting?.ios?.google?.native ?? "";
}
