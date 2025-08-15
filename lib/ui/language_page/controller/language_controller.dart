import 'dart:ui';
import 'package:get/get.dart';
import 'package:story_box/localization/localizations_delegate.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/preference.dart';

class LanguageScreenController extends GetxController {
  int selectedLanguage = 0;
  LanguageModel? languagesChosenValue;

  String? prefLanguageCode;
  String? prefCountryCode;

  @override
  void onInit() {
    getLanguageData();
    selectedLanguage = Preference.language ;
    super.onInit();
  }

  getLanguageData() {
    prefLanguageCode = Preference.shared.getString(Preference.selectedLanguage) ?? 'en';
    prefCountryCode = Preference.shared.getString(Preference.selectedCountryCode) ?? 'US';
    languagesChosenValue = languages
        .where((element) => (element.languageCode == prefLanguageCode && element.countryCode == prefCountryCode))
        .toList()[0];
    update([Constant.idChangeLanguage]);
  }

  onLanguageSave() {
    Preference.shared.setString(Preference.selectedLanguage, languagesChosenValue!.languageCode);
    Preference.shared.setString(Preference.selectedCountryCode, languagesChosenValue!.countryCode);
    Get.updateLocale(Locale(languagesChosenValue!.languageCode, languagesChosenValue!.countryCode));
    Get.back();
  }

  onChangeLanguage(LanguageModel value, int index) {
    languagesChosenValue = value;

    selectedLanguage = index;

    Preference.onSetLanguage(index);
    Get.back();
    // selectedLanguage = Preference.language ?? 0;
    // log("SET :: ${selectedLanguage}===Preference.language>>>=${Preference.language}");

    update([Constant.idChangeLanguage]);
  }
}
