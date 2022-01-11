import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/services/push_notification_service.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';

import 'notification_viewmodel.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  static const String id = '/NotificationView';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationViewModel>.reactive(
      viewModelBuilder: () => NotificationViewModel(),
      onModelReady: (model) => model.checkIfNotificationAllowed(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scaffoldColor,
        appBar: cwAuthAppBar(
          context,
          title: 'Notifications',
          onPressed: () => Navigator.pop(context),
        ),
        body: model.isNoticationAllowed
            ? ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  verticalSpaceRegular,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      cwEADescriptionTitle(context, 'Status'),
                    ],
                  ),
                  verticalSpaceRegular,
                  ValueListenableBuilder<Box>(
                    valueListenable:
                        hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                    builder: (context, appSettingsBox, child) {
                      final isTokenSaved = appSettingsBox.get(
                          AppSettingKeys.isTokenSaved,
                          defaultValue: false);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cwEADetailsTile(
                            context,
                            'Notification Status',
                            subtitle: isTokenSaved
                                ? 'Completed'
                                : 'Incomplete !!. Please restart the app with proper internet connectivity. If issue  persist , contact us via settings last option.',
                            showTrailingIcon: false,
                          ),
                        ],
                      );
                    },
                  ),
                  verticalSpaceRegular,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      cwEADescriptionTitle(context, 'Notifications'),
                    ],
                  ),
                  verticalSpaceRegular,
                  ValueListenableBuilder<Box>(
                      valueListenable:
                          hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                      builder: (context, box, child) {
                        final isZapNotificationsAllowed = box.get(
                          AppSettingKeys.isZapAllowed,
                          defaultValue: true,
                        );
                        return Row(
                          children: [
                            Expanded(
                              child: cwEADetailsTile(context, 'Zap',
                                  subtitle:
                                      'Sent when someone send you notifications calling you for chat.',
                                  showTrailingIcon: false),
                            ),
                            horizontalSpaceRegular,
                            CupertinoSwitch(
                              value: isZapNotificationsAllowed,
                              onChanged: (val) {
                                box.put(AppSettingKeys.isZapAllowed,
                                    !isZapNotificationsAllowed);
                              },
                            )
                          ],
                        );
                      }),
                  ValueListenableBuilder<Box>(
                      valueListenable:
                          hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                      builder: (context, box, child) {
                        bool isLetterNotificationsAllowed = box.get(
                          AppSettingKeys.isLetterAllowed,
                          defaultValue: true,
                        );
                        return Row(
                          children: [
                            Expanded(
                              child: cwEADetailsTile(context, 'Letters',
                                  subtitle:
                                      'Sent when someone send you a letter.',
                                  showTrailingIcon: false),
                            ),
                            horizontalSpaceRegular,
                            CupertinoSwitch(
                              value: isLetterNotificationsAllowed,
                              onChanged: (val) {
                                box.put(AppSettingKeys.isLetterAllowed,
                                    !isLetterNotificationsAllowed);
                              },
                            )
                          ],
                        );
                      }),
                  ValueListenableBuilder<Box>(
                      valueListenable:
                          hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                      builder: (context, box, child) {
                        bool isDiscoverNotificationsAllowed = box.get(
                          AppSettingKeys.isDiscoverAllowed,
                          defaultValue: true,
                        );
                        return Row(
                          children: [
                            Expanded(
                              child: cwEADetailsTile(context, 'Discover',
                                  subtitle:
                                      'Sent when new people for you to talk..',
                                  showTrailingIcon: false),
                            ),
                            horizontalSpaceRegular,
                            CupertinoSwitch(
                              value: isDiscoverNotificationsAllowed,
                              onChanged: (val) {
                                box.put(AppSettingKeys.isDiscoverAllowed,
                                    !isDiscoverNotificationsAllowed);
                                if (!isDiscoverNotificationsAllowed) {
                                  AwesomeNotifications()
                                      .cancelSchedulesByChannelKey(
                                          NotificationChannelKeys
                                              .discoverChannel);
                                } else {
                                  pushNotificationService
                                      .createScheduledDiscoverNotifications();
                                }
                              },
                            )
                          ],
                        );
                      }),
                  ValueListenableBuilder<Box>(
                      valueListenable:
                          hiveApi.hiveStream(HiveApi.appSettingsBoxName),
                      builder: (context, box, child) {
                        bool isSecurityNotificationsAllowed = box.get(
                          AppSettingKeys.isSecurityAllowed,
                          defaultValue: true,
                        );
                        return Row(
                          children: [
                            Expanded(
                              child: cwEADetailsTile(context, 'Security',
                                  subtitle:
                                      'Sent when we are securing the app so as to have complete transparency.',
                                  showTrailingIcon: false),
                            ),
                            horizontalSpaceRegular,
                            CupertinoSwitch(
                              value: isSecurityNotificationsAllowed,
                              onChanged: (val) {
                                box.put(AppSettingKeys.isSecurityAllowed,
                                    !isSecurityNotificationsAllowed);
                                if (!isSecurityNotificationsAllowed) {
                                  AwesomeNotifications()
                                      .cancelSchedulesByChannelKey(
                                          NotificationChannelKeys
                                              .securityChannel);
                                } else {
                                  pushNotificationService
                                      .createScheduledSecurityNotifications();
                                }
                              },
                            )
                          ],
                        );
                      }),
                ],
              )
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  verticalSpaceRegular,
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      maxRadius: 70,
                      backgroundColor: Theme.of(context).colorScheme.blueAccent,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.shield_fill,
                              color: Theme.of(context).colorScheme.blue,
                              size: 90,
                            ),
                            Icon(
                              CupertinoIcons.bell_fill,
                              color: Theme.of(context).colorScheme.white,
                              size: 40,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  Container(
                    margin: const EdgeInsets.symmetric(),
                    child: Text(
                      'Notifications are helpful beacuse they let you free your time and unnecessary checking app for any messages. Get notified when :',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.mediumBlack,
                      ),
                    ),
                  ),
                  verticalSpaceRegular,
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      '➡ friends want to talk with you',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.mediumBlack,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      '➡ someone sends you a letter',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.mediumBlack,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      '➡ you meet new friend on the app',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.mediumBlack,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      '➡ securing your data',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.mediumBlack,
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  const Divider(height: 0),
                  verticalSpaceMedium,
                  cwEADetailsTile(
                    context,
                    'Allow Notifications',
                    onTap: () {
                      AwesomeNotifications().showNotificationConfigPage();
                    },
                    subtitle: 'Tap to open settings page',
                    icon: FeatherIcons.externalLink,
                  ),
                ],
              ),
      ),
    );
  }
}
