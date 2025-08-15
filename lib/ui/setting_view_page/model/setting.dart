// To parse this JSON data, do
//
//     final setting = settingFromJson(jsonString);

import 'dart:convert';

Setting settingFromJson(String str) => Setting.fromJson(json.decode(str));

String settingToJson(Setting data) => json.encode(data.toJson());

class Setting {
  Currency? currency;
  Android? android;
  Android? ios;
  String? id;
  bool? googlePlaySwitch;
  bool? stripeSwitch;
  String? stripePublishableKey;
  String? stripeSecretKey;
  bool? razorPaySwitch;
  String? razorPayId;
  String? razorSecretKey;
  String? flutterWaveId;
  bool? flutterWaveSwitch;
  String? privacyPolicyLink;
  String? termsOfUsePolicyLink;
  int? durationOfShorts;
  int? minCoinForCashOut;
  int? minWithdrawalRequestedCoin;
  int? referralRewardCoins;
  int? watchingVideoRewardCoins;
  int? commentingRewardCoins;
  int? likeVideoRewardCoins;
  int? loginRewardCoins;
  int? maxAdPerDay;
  bool? isGoogle;
  PrivateKey? privateKey;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? freeEpisodesForNonVip;
  String? contactEmail;

  Setting({
    this.currency,
    this.android,
    this.ios,
    this.id,
    this.googlePlaySwitch,
    this.stripeSwitch,
    this.stripePublishableKey,
    this.stripeSecretKey,
    this.razorPaySwitch,
    this.razorPayId,
    this.razorSecretKey,
    this.flutterWaveId,
    this.flutterWaveSwitch,
    this.privacyPolicyLink,
    this.termsOfUsePolicyLink,
    this.durationOfShorts,
    this.minCoinForCashOut,
    this.minWithdrawalRequestedCoin,
    this.referralRewardCoins,
    this.watchingVideoRewardCoins,
    this.commentingRewardCoins,
    this.likeVideoRewardCoins,
    this.loginRewardCoins,
    this.maxAdPerDay,
    this.isGoogle,
    this.privateKey,
    this.createdAt,
    this.updatedAt,
    this.freeEpisodesForNonVip,
    this.contactEmail,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        currency: json["currency"] == null ? null : Currency.fromJson(json["currency"]),
        android: json["android"] == null ? null : Android.fromJson(json["android"]),
        ios: json["ios"] == null ? null : Android.fromJson(json["ios"]),
        id: json["_id"],
        googlePlaySwitch: json["googlePlaySwitch"],
        stripeSwitch: json["stripeSwitch"],
        stripePublishableKey: json["stripePublishableKey"],
        stripeSecretKey: json["stripeSecretKey"],
        razorPaySwitch: json["razorPaySwitch"],
        razorPayId: json["razorPayId"],
        razorSecretKey: json["razorSecretKey"],
        flutterWaveId: json["flutterWaveId"],
        flutterWaveSwitch: json["flutterWaveSwitch"],
        privacyPolicyLink: json["privacyPolicyLink"],
        termsOfUsePolicyLink: json["termsOfUsePolicyLink"],
        durationOfShorts: json["durationOfShorts"],
        minCoinForCashOut: json["minCoinForCashOut"],
        minWithdrawalRequestedCoin: json["minWithdrawalRequestedCoin"],
        referralRewardCoins: json["referralRewardCoins"],
        watchingVideoRewardCoins: json["watchingVideoRewardCoins"],
        commentingRewardCoins: json["commentingRewardCoins"],
        likeVideoRewardCoins: json["likeVideoRewardCoins"],
        loginRewardCoins: json["loginRewardCoins"],
        maxAdPerDay: json["maxAdPerDay"],
        isGoogle: json["isGoogle"],
        privateKey: json["privateKey"] == null ? null : PrivateKey.fromJson(json["privateKey"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        freeEpisodesForNonVip: json["freeEpisodesForNonVip"],
        contactEmail: json["contactEmail"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency?.toJson(),
        "android": android?.toJson(),
        "ios": ios?.toJson(),
        "_id": id,
        "googlePlaySwitch": googlePlaySwitch,
        "stripeSwitch": stripeSwitch,
        "stripePublishableKey": stripePublishableKey,
        "stripeSecretKey": stripeSecretKey,
        "razorPaySwitch": razorPaySwitch,
        "razorPayId": razorPayId,
        "razorSecretKey": razorSecretKey,
        "flutterWaveId": flutterWaveId,
        "flutterWaveSwitch": flutterWaveSwitch,
        "privacyPolicyLink": privacyPolicyLink,
        "termsOfUsePolicyLink": termsOfUsePolicyLink,
        "durationOfShorts": durationOfShorts,
        "minCoinForCashOut": minCoinForCashOut,
        "minWithdrawalRequestedCoin": minWithdrawalRequestedCoin,
        "referralRewardCoins": referralRewardCoins,
        "watchingVideoRewardCoins": watchingVideoRewardCoins,
        "commentingRewardCoins": commentingRewardCoins,
        "likeVideoRewardCoins": likeVideoRewardCoins,
        "loginRewardCoins": loginRewardCoins,
        "maxAdPerDay": maxAdPerDay,
        "isGoogle": isGoogle,
        "privateKey": privateKey?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "freeEpisodesForNonVip": freeEpisodesForNonVip,
        "contactEmail": contactEmail,
      };
}

class Android {
  Google? google;

  Android({
    this.google,
  });

  factory Android.fromJson(Map<String, dynamic> json) => Android(
        google: json["google"] == null ? null : Google.fromJson(json["google"]),
      );

  Map<String, dynamic> toJson() => {
        "google": google?.toJson(),
      };
}

class Google {
  String? interstitial;
  String? native;
  String? reward;

  Google({
    this.interstitial,
    this.native,
    this.reward,
  });

  factory Google.fromJson(Map<String, dynamic> json) => Google(
        interstitial: json["interstitial"],
        native: json["native"],
        reward: json["reward"],
      );

  Map<String, dynamic> toJson() => {
        "interstitial": interstitial,
        "native": native,
        "reward": reward,
      };
}

class Currency {
  String? name;
  String? symbol;
  String? countryCode;
  String? currencyCode;
  bool? isDefault;

  Currency({
    this.name,
    this.symbol,
    this.countryCode,
    this.currencyCode,
    this.isDefault,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        name: json["name"],
        symbol: json["symbol"],
        countryCode: json["countryCode"],
        currencyCode: json["currencyCode"],
        isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "symbol": symbol,
        "countryCode": countryCode,
        "currencyCode": currencyCode,
        "isDefault": isDefault,
      };
}

class PrivateKey {
  String? type;
  String? projectId;
  String? privateKeyId;
  String? privateKey;
  String? clientEmail;
  String? clientId;
  String? authUri;
  String? tokenUri;
  String? authProviderX509CertUrl;
  String? clientX509CertUrl;
  String? universeDomain;

  PrivateKey({
    this.type,
    this.projectId,
    this.privateKeyId,
    this.privateKey,
    this.clientEmail,
    this.clientId,
    this.authUri,
    this.tokenUri,
    this.authProviderX509CertUrl,
    this.clientX509CertUrl,
    this.universeDomain,
  });

  factory PrivateKey.fromJson(Map<String, dynamic> json) => PrivateKey(
        type: json["type"],
        projectId: json["project_id"],
        privateKeyId: json["private_key_id"],
        privateKey: json["private_key"],
        clientEmail: json["client_email"],
        clientId: json["client_id"],
        authUri: json["auth_uri"],
        tokenUri: json["token_uri"],
        authProviderX509CertUrl: json["auth_provider_x509_cert_url"],
        clientX509CertUrl: json["client_x509_cert_url"],
        universeDomain: json["universe_domain"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "project_id": projectId,
        "private_key_id": privateKeyId,
        "private_key": privateKey,
        "client_email": clientEmail,
        "client_id": clientId,
        "auth_uri": authUri,
        "token_uri": tokenUri,
        "auth_provider_x509_cert_url": authProviderX509CertUrl,
        "client_x509_cert_url": clientX509CertUrl,
        "universe_domain": universeDomain,
      };
}
