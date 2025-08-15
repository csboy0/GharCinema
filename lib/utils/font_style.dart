import 'package:flutter/material.dart';

import 'constant.dart';

abstract class AppFontStyle {
  /// customise style
  static styleW400(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: Constant.appFontFamily,
      fontWeight: FontWeight.w400, // Light
    );
  }

  static styleW500(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: Constant.appFontFamily,
      fontWeight: FontWeight.w500, // Medium
    );
  }

  static styleW600(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: Constant.appFontFamily,
      fontWeight: FontWeight.w600, // Regular
    );
  }

  static styleW700(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: Constant.appFontFamily,
      fontWeight: FontWeight.w700, // Bold
    );
  }

  static styleW800(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: Constant.appFontFamily,
      fontWeight: FontWeight.w800, // Bold
    );
  }

  static styleW900(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: Constant.appFontFamily,
      fontWeight: FontWeight.w900, // Bold
    );
  }

  static customizeStyle({String? fontFamily, color, fontSize, fontWeight, height, decoration}) {
    return TextStyle(
      fontFamily: fontFamily,
      height: height,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: decoration,
    );
  }
}
