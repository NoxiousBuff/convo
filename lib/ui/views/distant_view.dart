import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'help_view.dart';
import 'privacy/privacy.dart';
import 'storage_media.dart';
import 'user_account/account_view.dart';

class DistantView extends StatelessWidget {
  final FireUser fireUser;
  const DistantView({Key? key, required this.fireUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: activeBlue, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SizedBox(
        width: screenWidth(context),
        child: Column(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  maxRadius: 50,
                  backgroundImage:
                      CachedNetworkImageProvider(fireUser.photoUrl!),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: screenWidthPercentage(context, percentage: 0.9),
                child: Column(
                  children: [
                    widget(
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
                    widget(
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
                    widget(
                      context: context,
                      text: 'Notifications',
                      icon: CupertinoIcons.bell,
                      onTap: () {},
                    ),
                    widget(
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
                    widget(
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widget({
    required BuildContext context,
    required String text,
    required IconData icon,
    required Function onTap,
  }) {
    return Container(
      color: systemBackground,
      child: Column(
        children: [
          InkWell(
            onTap: onTap as void Function()?,
            child: ListTile(
              title: Text(
                text,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              leading: Icon(icon),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 14.0,
              ),
            ),
          ),
          const Divider(height: 0.0),
        ],
      ),
    );
  }
}
