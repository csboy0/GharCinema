import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/enums.dart';

class Utils {
  static const sandboxVerifyReceiptUrl = false;

  /// =================== Toast =================== ///
  static showToast(BuildContext context, String msg, {ToastGravity gravity = ToastGravity.BOTTOM}) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      backgroundColor: AppColor.colorBlack,
      textColor: AppColor.colorWhite,
      fontSize: 15,
    );
  }

  /// =================== Current Focus Node =================== ///
  static currentFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  static int getLoginTypeValue(LoginType type) {
    switch (type) {
      case LoginType.MOBILE_NUMBER:
        return 1;
      case LoginType.GOOGLE:
        return 2;
      case LoginType.QUICK:
        return 3;
      case LoginType.APPLE:
        return 4;
      default:
        return -1; // Default case if needed
    }
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  /// =================== Lunch URL =================== ///
  // static Future<void> launchURL(String value) async {
  //   var url = Uri.parse(value);
  //   if (await canLaunchUrl(url)) {
  //     launchUrl(url);
  //   } else {
  //     Utils.showToast(Get.context!, "Web page can't loaded");
  //     throw "Cannot load the page";
  //   }
  // }

  /// =================== Clipboard (Copy Text) =================== ///
  static copyText(String text) {
    // FlutterClipboard.copy(text);
  }

  /// =================== Console Log =================== ///
  static final Logger _logger = Logger();

  static void showLog(String text, {LogLevel level = LogLevel.info, dynamic error, StackTrace? stackTrace}) {
    switch (level) {
      case LogLevel.trace:
        _logger.t(text);
        break;
      case LogLevel.debug:
        _logger.d(text);
        break;
      case LogLevel.info:
        _logger.i(text);
        break;
      case LogLevel.warning:
        _logger.w(text);
        break;
      case LogLevel.error:
        _logger.e(text, error: error, stackTrace: stackTrace);
        break;
      case LogLevel.fatal:
        _logger.f(text, error: error, stackTrace: stackTrace);
        break;
    }
  }

  static String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date).toLocal();
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }
}

enum LogLevel {
  trace,
  debug,
  info,
  warning,
  error,
  fatal,
}

class CustomFormatNumber {
  static String convert(int number) {
    if (number >= 1000000) {
      // Handle 1 million and above
      return '${(number / 1000000).toStringAsFixed(2)}m';
    } else if (number >= 1000) {
      // Handle thousands
      return '${(number / 1000).toStringAsFixed(2)}k';
    } else {
      // Handle less than a thousand
      return number.toString();
    }
  }
}
