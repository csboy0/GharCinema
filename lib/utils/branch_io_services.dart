import 'dart:async';
import 'dart:developer';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:story_box/utils/api.dart';

class BranchIoServices {
  static BranchContentMetaData branchContentMetaData = BranchContentMetaData();
  static BranchUniversalObject? branchUniversalObject;
  static BranchLinkProperties branchLinkProperties = BranchLinkProperties();

  static String eventId = "";
  static String eventType = "";

  // This is Use to Splash Screen...
  static void onListenBranchIoLinks() async {
    StreamController<String> streamController = StreamController<String>();
    StreamSubscription<Map>? streamSubscription = FlutterBranchSdk.initSession().listen(
      (data) {
        log('Click To Branch Io Link => $data');
        streamController.sink.add((data.toString()));

        if (data.containsKey('+clicked_branch_link') && data['+clicked_branch_link'] == true) {
          log("Click To Branch Io Link Page Routes => ${data['Video']}");

          eventId = data["id"];
          eventType = data['pageRoutes'];

          log("Event Id => $eventId");
        }
      },
      onError: (error) {
        log('Branch Io Listen Error => ${error.toString()}');
      },
    );
    log("Stream Subscription => $streamSubscription");
  }

  static Future<void> onCreateBranchIoLink({
    // required String pageRoutes,
    required String movieSeriesId,
    required int totalVideos,
    required String image,
    required String title,
    required String description,
  }) async {
    branchContentMetaData = BranchContentMetaData()
      // ..addCustomMetadata("pageRoutes", pageRoutes)
      ..addCustomMetadata("movieSeriesId", movieSeriesId)
      ..addCustomMetadata("totalVideos", totalVideos);
    // ..addCustomMetadata("image", image)
    // ..addCustomMetadata('userId', userId);

    branchUniversalObject = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      canonicalUrl: 'https://flutter.dev',
      title: title,
      imageUrl: ApiConstant.getBaseURL() + image,
      contentDescription: description,
      contentMetadata: branchContentMetaData,
      keywords: ['Plugin', 'Branch', 'Flutter'],
      publiclyIndex: true,
      locallyIndex: true,
      expirationDateInMilliSec: DateTime.now().add(const Duration(days: 365)).millisecondsSinceEpoch,
    );

    branchLinkProperties = BranchLinkProperties(
        channel: 'facebook', feature: 'sharing', stage: 'new share', campaign: 'campaign', tags: ['one', 'two', 'three'])
      ..addControlParam('\$uri_redirect_mode', '1')
      ..addControlParam('\$ios_nativelink', true)
      ..addControlParam('\$match_duration', 7200)
      ..addControlParam('\$always_deeplink', true)
      ..addControlParam('\$android_redirect_timeout', 750)
      ..addControlParam('referring_user_id', 'user_id');
  }

  static Future<String?> onGenerateLink() async {
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: branchUniversalObject!, linkProperties: branchLinkProperties);
    if (response.success) {
      log("Generated Branch Io Link => ${response.result}");

      return response.result.toString();
    } else {
      log("Generating Branch Io Link Failed !! => ${response.errorCode} - ${response.errorMessage}");
      return null;
    }
  }
}
