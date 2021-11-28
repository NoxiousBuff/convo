import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/api/hive.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hive/hive.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'SecurityView',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Messages in end-to-end encrypted chats stay between you and the people you choose. Not even Dule can read them.',
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontSize: 16, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 0),
          const SizedBox(height: 20),
          ListTile(
            title: const Text(
              'Show security notifications on this phone',
            ),
            trailing: ValueListenableBuilder<Box>(
              valueListenable: hiveApi.hiveStream(HiveApi.appSettingsBoxName),
              builder: (context, box, child) {
                const boxName = HiveApi.appSettingsBoxName;
                const key = AppSettingKeys.securityNotifications;
                bool securityNotifications =
                    Hive.box(boxName).get(key, defaultValue: false);
                return CupertinoSwitch(
                  value: securityNotifications,
                  onChanged: (val) {
                    box.put(AppSettingKeys.securityNotifications,
                        !securityNotifications);
                  },
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Get notify when your security code changes for a contacts\'s phone in an end-to-end encrypted chat.',
              style:
                  Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}