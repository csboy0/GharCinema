import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_box/localization/localizations_delegate.dart';
import 'package:story_box/ui/language_page/controller/language_controller.dart';
import 'package:story_box/utils/color.dart';
import 'package:story_box/utils/constant.dart';
import 'package:story_box/utils/custom_dialog.dart';
import 'package:story_box/utils/dummy_data.dart';
import 'package:story_box/utils/enums.dart';
import 'package:story_box/utils/font_style.dart';
import 'package:story_box/utils/preference.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  final controller = Get.find<LanguageScreenController>();

  @override
  void initState() {
    controller.selectedLanguage = Preference.language;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorBlack,
      appBar: AppBar(
        surfaceTintColor: AppColor.colorBlack,
        backgroundColor: AppColor.colorBlack,
        centerTitle: true,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () => Get.back(),
        ),
        title: Text(
          EnumLocal.language.name.tr,
          style: AppFontStyle.styleW600(AppColor.colorWhite, 20),
        ),
      ),
      body: Container(
        color: AppColor.bgGreyColor,
        child: GetBuilder<LanguageScreenController>(
            id: Constant.idChangeLanguage,
            builder: (logic) {
              return ListView.builder(
                itemCount: DummyData.languages.length,
                itemBuilder: (context, index) {
                  log('DATA :: ${logic.selectedLanguage}');
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          DummyData.languages[index],
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        trailing: logic.selectedLanguage == index
                            ? Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: AppColor.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                            : Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                text: '${EnumLocal.switchTo.name.tr} ${DummyData.languages[index]} ?',
                                buttonText: EnumLocal.confirm.name.tr,
                                onTap: () {
                                  logic.onChangeLanguage(languages[index], index);
                                  logic.onLanguageSave();
                                },
                              );
                            },
                          );
                        },
                      ),
                      Divider(
                        color: AppColor.greyColor.withOpacity(0.1),
                      ),
                    ],
                  );
                },
              );
            }),
      ),
    );
  }
}
