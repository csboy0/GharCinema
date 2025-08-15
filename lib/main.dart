import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:story_box/connectivity_manager/connectivity_manager.dart';
import 'package:story_box/custom_widget/platfrom_id.dart';
import 'package:story_box/localization/localizations_delegate.dart';
import 'package:story_box/notification/notification_service.dart';
import 'package:story_box/routes/app_pages.dart';
import 'package:story_box/routes/app_routes.dart';
import 'package:story_box/ui/setting_view_page/api/setting_api.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/preference.dart';
import 'localization/locale_constant.dart';
import 'utils/utils.dart';

Future<void> main() async {
  /// Initialize  Widgets binding use in the firebase core or etc...
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Shared Preference
  await Preference().instance();

  ///settingApiCall
  await SettingApi.callApi();

  /// initialize Firebase
  await Firebase.initializeApp();

  /// initialize branch io
  await onInitializeBranchIo();

  /// FCM Token
  ///
  final fcmToken = await FirebaseMessaging.instance.getToken();

  /// Initialize Mobile Ads testing
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: ["27725C0BA50B789AA8A8833105F99920"],
    ),
  );

  FirebaseMessaging.onBackgroundMessage(
      NotificationServices.backgroundNotification);

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
  Stripe.publishableKey = Constant.stripeTestPublicKey;

  /// Initialize Internet connectivity manger
  await InternetConnectivity().instance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final StreamController purchaseStreamController =
      StreamController<PurchaseDetails>.broadcast();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        log("didChangeDependencies Preference Revoked ${locale.languageCode}");
        log("didChangeDependencies GET LOCALE Revoked ${Get.locale!.languageCode}");
        Get.updateLocale(locale);
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ghar Cinema',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: AppPages.list,
      defaultTransition: Transition.fadeIn,
      locale: const Locale("en"),
      translations: AppLanguages(),
      fallbackLocale: const Locale(Constant.languageEn, Constant.countryCodeEn),
      initialRoute: AppRoutes.splash,
    );
  }
}
// >>>>>> >>>>>> Sized Box Extension <<<<<< <<<<<<

extension HeightExtension on num {
  SizedBox get height => SizedBox(height: toDouble());
}

extension WidthExtension on num {
  SizedBox get width => SizedBox(width: toDouble());
}

Future<void> onInitializeBranchIo() async {
  try {
    await FlutterBranchSdk.init().then((value) {
      FlutterBranchSdk.validateSDKIntegration();
    });
  } catch (e) {
    Utils.showLog("Initialize Branch Io Failed !! => $e");
  }
}
