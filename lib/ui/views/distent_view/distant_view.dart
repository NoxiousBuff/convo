import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import '../user_account/account_view.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/views/help_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/storage_media.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/views/privacy/privacy.dart';
import 'package:hint/routes/cupertino_page_route.dart';

class DistantView extends StatelessWidget {
  final FireUser fireUser;
  const DistantView({Key? key, required this.fireUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget optionTile({
      required String text,
      required IconData icon,
      required BuildContext context,
      Function? onTap,
      Widget? trailing,
    }) {
      return ValueListenableBuilder<Box>(
        valueListenable: appSettings.listenable(),
        builder: (context, box, child) {
          bool darkMode = box.get(darkModeKey);
          return Container(
            color:darkMode ? darkModeColor : systemBackground,
            child: Column(
              children: [
                InkWell(
                  onTap: onTap as void Function()?,
                  child: ListTile(
                    trailing: trailing,
                    title: Text(text,
                        style: Theme.of(context).textTheme.bodyText2),
                    leading: Icon(icon,color:darkMode ? dirtyWhite : iconColor),
                  ),
                ),
                const Divider(height: 0.0),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        width: screenWidth(context),
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              margin: const EdgeInsets.only(left: 16, bottom: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: ExtendedImage(
                  width: 200,
                  height: 200,
                  enableLoadState: true,
                  handleLoadingProgress: true,
                  image: NetworkImage(fireUser.photoUrl!),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: screenWidthPercentage(context, percentage: 0.9),
                child: Column(
                  children: [
                    optionTile(
                        context: context,
                        text: 'Account',
                        icon: CupertinoIcons.person,
                        onTap: () {
                          Navigator.push(
                            context,
                            cupertinoTransition(
                              enterTo: Account(fireUser: fireUser),
                              exitFrom: DistantView(fireUser: fireUser),
                            ),
                          );
                        }),
                    optionTile(
                      context: context,
                      text: 'Privacy & Safety',
                      icon: CupertinoIcons.lock,
                      onTap: () => Navigator.push(
                        context,
                        cupertinoTransition(
                          enterTo: const Privacy(),
                          exitFrom: DistantView(fireUser: fireUser),
                        ),
                      ),
                    ),
                    optionTile(
                      context: context,
                      text: 'Notifications',
                      icon: CupertinoIcons.bell,
                      onTap: () {},
                    ),
                    optionTile(
                      context: context,
                      text: 'Help',
                      icon: CupertinoIcons.question_circle,
                      onTap: () => Navigator.push(
                        context,
                        cupertinoTransition(
                          enterTo: const Help(),
                          exitFrom: DistantView(fireUser: fireUser),
                        ),
                      ),
                    ),
                    optionTile(
                      context: context,
                      text: 'Media',
                      icon: CupertinoIcons.photo_on_rectangle,
                      onTap: () => Navigator.push(
                        context,
                        cupertinoTransition(
                          enterTo: const StorageMedia(),
                          exitFrom: DistantView(fireUser: fireUser),
                        ),
                      ),
                    ),
                    ValueListenableBuilder<Box>(
                      valueListenable: appSettings.listenable(),
                      builder: (context, box, child) {
                        var darkMode = box.get(darkModeKey);
                        return optionTile(
                          context: context,
                          text: darkMode ? 'Light Theme' : 'Dark Theme',
                          icon: CupertinoIcons.person,
                          trailing: CupertinoSwitch(
                            value: box.get(darkModeKey),
                            onChanged: (bool val) {
                              box.put(darkModeKey, val);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
