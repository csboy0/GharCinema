import 'dart:io';

import 'package:story_box/utils/constant.dart';

class GoogleAdHelper {
  static String get rewardedAd => Platform.isAndroid
      ? Constant.reward
      : Platform.isIOS
          ? Constant.rewardIos
          : "Platform Not Support !!";
}
