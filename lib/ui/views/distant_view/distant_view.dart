import 'package:hint/app/app.dart';
import 'package:hint/ui/views/user_contacts/user_contacts.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/api/hive_helper.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/views/help_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/storage_media.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hint/ui/views/privacy/privacy.dart';
import 'package:hint/routes/cupertino_page_route.dart';
import 'package:hint/ui/views/user_account/account_view.dart';
import 'package:hint/ui/views/distant_view/distantview_viewmodel.dart';

class DistantView extends StatelessWidget {
  final FireUser fireUser;
  const DistantView({Key? key, required this.fireUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final log = getLogger('DistantView');

    Future<void> changeChatBackground(DistantViewViewModel model) async {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
            title: Text(
              'Pick Image From',
              style: Theme.of(context).textTheme.headline6,
            ),
            content: Container(
              constraints: BoxConstraints(
                maxHeight: screenHeightPercentage(context, percentage: 0.18),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () async {
                          var pickedImage =
                              await model.pickImage(ImageSource.camera);
                          if (pickedImage != null) {
                            model.uploadFile(
                              filePath: pickedImage.path,
                            );
                            Navigator.pop(context);
                          } else {
                            log.w('Image was not selected from camera');
                          }
                        },
                        child: Text(
                          'Camera',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () async {
                          var pickedImage =
                              await model.pickImage(ImageSource.gallery);
                          if (pickedImage != null) {
                            model.uploadAndSave(pickedImage.path);
                            Navigator.pop(context);
                          } else {
                            log.w('Image was not selected from gallery');
                          }
                        },
                        child: Text(
                          'Gallery',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: lightBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return ViewModelBuilder<DistantViewViewModel>.reactive(
      viewModelBuilder: () => DistantViewViewModel(),
      builder: (context, model, child) {
        final exitFrom = DistantView(fireUser: fireUser);
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
                                exitFrom: exitFrom,
                              ),
                            );
                          },
                        ),
                        optionTile(
                          context: context,
                          text: 'Contact',
                          icon: CupertinoIcons.person,
                          onTap: () {
                            Navigator.push(
                              context,
                              cupertinoTransition(
                                enterTo: UserContacts(),
                                exitFrom: exitFrom,
                              ),
                            );
                          },
                        ),
                        optionTile(
                          context: context,
                          text: 'Privacy & Safety',
                          icon: CupertinoIcons.lock,
                          onTap: () => Navigator.push(
                            context,
                            cupertinoTransition(
                              enterTo: const Privacy(),
                              exitFrom: exitFrom,
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
                              exitFrom: exitFrom,
                            ),
                          ),
                        ),
                        optionTile(
                          context: context,
                          text: 'Media',
                          icon: Icons.data_usage_outlined,
                          onTap: () => Navigator.push(
                            context,
                            cupertinoTransition(
                              enterTo: const StorageMedia(),
                              exitFrom: exitFrom,
                            ),
                          ),
                        ),
                        optionTile(
                          context: context,
                          icon: Icons.wallpaper,
                          text: 'Chat Background',
                          onTap: () => changeChatBackground(model),
                        ),
                        ValueListenableBuilder<Box>(
                          valueListenable: appSettings.listenable(),
                          builder: (context, box, child) {
                            const key = darkModeKey;
                            var value = box.get(key, defaultValue: false);
                            return optionTile(
                              context: context,
                              text: isDarkTheme ? 'Light Theme' : 'Dark Theme',
                              icon: CupertinoIcons.person,
                              trailing: CupertinoSwitch(
                                value: value,
                                onChanged: (bool val) {
                                  box.put(darkModeKey, val);
                                  model.themeChanger(val);
                                },
                              ),
                            );
                          },
                        ),
                        optionTile(
                          context: context,
                          text: 'Logout',
                          icon: Icons.logout_outlined,
                          onTap: () {
                            model
                                .signOut(context)
                                .catchError((e) => log.e('signOutError:$e'))
                                .onError(
                                  (error, stackTrace) =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                    SnackBar(
                                      elevation: 8.0,
                                      backgroundColor: inactiveGray,
                                      content: Text(
                                        'Unable To Log Out',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                  ),
                                );
                          },
                          trailing: model.isBusy
                              ? const SizedBox(
                                  height: 17,
                                  width: 17,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 1.7,
                                      valueColor:
                                          AlwaysStoppedAnimation(activeBlue)))
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget optionTile({
    required String text,
    required IconData icon,
    required BuildContext context,
    Function? onTap,
    Widget? trailing,
  }) {
    return Container(
      color: isDarkTheme ? darkModeColor : systemBackground,
      child: Column(
        children: [
          InkWell(
            onTap: onTap as void Function()?,
            child: ListTile(
              trailing: trailing,
              title: Text(text, style: Theme.of(context).textTheme.bodyText2),
              leading:
                  Icon(icon, color: isDarkTheme ? dirtyWhite : inactiveGray),
            ),
          ),
          const Divider(height: 0.0),
        ],
      ),
    );
  }
}
