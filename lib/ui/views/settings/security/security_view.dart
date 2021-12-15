import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/account/edit_account/widgets/widgets.dart';
import 'package:hint/ui/views/auth/auth_widgets.dart';
import 'package:hive/hive.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: cwAuthAppBar(
        context,
        title: 'Security',
        onPressed: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          verticalSpaceRegular,
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              maxRadius: 70,
              backgroundColor: AppColors.blueAccent,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(CupertinoIcons.shield_fill,
                        color: AppColors.blue, size: 90),
                    Icon(CupertinoIcons.lock_fill,
                        color: AppColors.white, size: 40)
                  ],
                ),
              ),
            ),
          ),
          verticalSpaceMedium,
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text(
              'Messages in end-to-end encrypted chats stay between you and the people you choose. Not even Dule can read them.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
          ),
          verticalSpaceMedium,
          const Divider(height: 0),
          verticalSpaceMedium,
          ValueListenableBuilder<Box>(
            valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
            builder: (context, box, child) {
              const boxName = HiveApi.appSettingsBoxName;
              const key = AppSettingKeys.securityNotifications;
              bool securityNotifications =
                  Hive.box(boxName).get(key, defaultValue: false);
              return Row(
                children: [
                  Expanded(
                      child: cwEADetailsTile(
                          context, 'Show security notifications',
                          subtitle:
                              'Get notify when your security code changes for a contacts\'s phone in an end-to-end encrypted chat.',
                          showTrailingIcon: false)),
                  horizontalSpaceRegular,
                  CupertinoSwitch(
                    value: securityNotifications,
                    onChanged: (val) {
                      box.put(AppSettingKeys.securityNotifications,
                          !securityNotifications);
                    },
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
