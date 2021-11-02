import 'dart:async';
import 'package:hint/api/hive.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hint/ui/views/profile_view/profile_viewmodel.dart';

class ProfileView extends StatelessWidget {
  final bool iBlockThisUser;
  final FireUser fireUser;
  final ChatViewModel model;
  final String conversationId;
  ProfileView(
      {Key? key,
      required this.model,
      required this.fireUser,
      required this.iBlockThisUser,
      required this.conversationId})
      : super(key: key);

  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController biocontroller = TextEditingController();
  final bool switchBool = false;
  final log = getLogger('ProfileView');

  Widget profileOption({
    required String title,
    required IconData icon,
    void Function()? onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            child: Center(
              child: Icon(
                icon,
                color: inactiveGray,
              ),
            ),
            backgroundColor: dirtyWhite,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText2,
          )
        ],
      ),
    );
  }

  Widget profileDialog(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeightPercentage(context, percentage: 0.4),
          maxWidth: screenWidthPercentage(context, percentage: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: CircleAvatar(
                maxRadius: 30,
                backgroundImage: CachedNetworkImageProvider(fireUser.photoUrl!),
              ),
            ),
            Text(
              fireUser.email,
              style: Theme.of(context).textTheme.bodyText2,
            )
          ],
        ),
      ),
    );
  }

  Widget notificationDialog(BuildContext context, ProfileViewModel model) {
    final maxWidth = screenWidthPercentage(context, percentage: 0.6);
    final maxHeight = screenHeightPercentage(context, percentage: 0.52);
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          maxWidth: maxWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Text(
                'Mute notification for this conversation',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: model.optionName.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                  value: index,
                  groupValue: model.value,
                  title: Text(
                    model.optionName[index],
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  onChanged: (int? i) {
                    model.currentIndex(i);
                    Navigator.pop(context);
                  },
                );
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: () {
                    model.currentIndex(null);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Don\'t Mute',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: lightBlue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> clearChatDialog(BuildContext context) async {
    final maxWidth = screenWidthPercentage(context, percentage: 0.55);
    final maxHeight = screenHeightPercentage(context, percentage: 0.18);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
              maxWidth: maxWidth,
            ),
            child: Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    'If you delete this chat all messages and media will\nbe delete permanently',
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: black),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await model.clearChat();
                    await Hive.box('UrlData[$conversationId]').clear();
                    await Hive.box('ImagesMemory[$conversationId]').clear();
                    await Hive.box("ChatRoomMedia[$conversationId]").clear();
                    await Hive.box('VideoThumbnails[$conversationId]').clear();
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Delete',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: activeBlue),
                      ),
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

  Widget profileBox({
    required BuildContext context,
    required ProfileViewModel model,
  }) {
    final backGroundImage = CachedNetworkImageProvider(fireUser.photoUrl!);
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            maxRadius: 70,
            backgroundColor: activeBlue,
            backgroundImage: backGroundImage,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    fireUser.username,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    profileOption(
                      title: "Profile",
                      context: context,
                      icon: CupertinoIcons.person,
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          return profileDialog(context);
                        },
                      ),
                    ),
                    profileOption(
                      title: "Mute",
                      icon: model.value != null
                          ? CupertinoIcons.bell_slash
                          : CupertinoIcons.bell,
                      context: context,
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          return notificationDialog(context, model);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget defaultOptions(BuildContext context, ProfileViewModel model) {
    Widget optionTile({
      IconData? icon,
      required String title,
      void Function()? onTap,
    }) =>
        ValueListenableBuilder<Box>(
          valueListenable: hiveApi.appSettings.listenable(),
          builder: (context, box, child) {
            bool darkTheme = box.get(HiveApi.darkModeKey);
            return ListTileTheme(
              tileColor: darkTheme ? darkModeColor : null,
              iconColor: darkTheme ? dirtyWhite : darkModeColor,
              child: ListTile(
                onTap: onTap,
                trailing: Icon(icon, size: 20),
                title:
                    Text(title, style: Theme.of(context).textTheme.bodyText2),
              ),
            );
          },
        );

    return Column(
      children: [
        optionTile(title: 'Clear Chat', icon: CupertinoIcons.delete),
        optionTile(title: 'Encryption', icon: CupertinoIcons.lock),
        optionTile(title: 'Disappearing Messages', icon: CupertinoIcons.timer),
      ],
    );
  }

  Widget moreActionOption(BuildContext context) {
    Widget optionTile({
      IconData? icon,
      required String title,
      void Function()? onTap,
    }) =>
        ValueListenableBuilder<Box>(
          valueListenable: hiveApi.appSettings.listenable(),
          builder: (context, box, child) {
            bool darkTheme = box.get(HiveApi.darkModeKey);
            return ListTileTheme(
              tileColor: darkTheme ? darkModeColor : null,
              iconColor: darkTheme ? dirtyWhite : darkModeColor,
              child: ListTile(
                onTap: onTap,
                trailing: Icon(icon, size: 20),
                title:
                    Text(title, style: Theme.of(context).textTheme.bodyText2),
              ),
            );
          },
        );

    return Column(
      children: [
        optionTile(title: 'Share Contact', icon: Icons.share_outlined),
        optionTile(
            title: 'View Media and Links',
            icon: CupertinoIcons.photo_on_rectangle),
        optionTile(
            title: 'Create Group with Vikas', icon: CupertinoIcons.person_3),
      ],
    );
  }

  Widget privacyOption(BuildContext context, ProfileViewModel model,
      ChatViewModel chatViewModel) {
    Widget optionTile({
      IconData? icon,
      Widget? subtitle,
      required String title,
      void Function()? onTap,
    }) =>
        ValueListenableBuilder<Box>(
          valueListenable: hiveApi.appSettings.listenable(),
          builder: (context, box, child) {
            bool darkTheme = box.get(HiveApi.darkModeKey);
            return ListTileTheme(
              tileColor: darkTheme ? darkModeColor : null,
              iconColor: darkTheme ? dirtyWhite : darkModeColor,
              child: ListTile(
                onTap: onTap,
                subtitle: subtitle,
                trailing: Icon(icon, size: 20),
                title:
                    Text(title, style: Theme.of(context).textTheme.bodyText2),
              ),
            );
          },
        );

    return Column(
      children: [
        optionTile(
          title: iBlockThisUser ? 'Unblock' : 'Block this Contact',
          icon: Icons.block_outlined,
          onTap: () => iBlockThisUser
              ? model.blockAndUnBlock(
                  fireUserId: fireUser.id,
                  chatViewModel: chatViewModel,
                  currentUserID: FirestoreApi.auth.currentUser!.uid,
                )
              : model.blockContactDialog(
                  context: context,
                  fireUser: fireUser,
                  fireUserId: fireUser.id,
                  chatViewModel: chatViewModel,
                ),
        ),
        optionTile(title: 'ignore Messages', icon: CupertinoIcons.chat_bubble),
        optionTile(
          title: 'Something\'s went wroung',
          subtitle: Text('Give feedback and report conversation',
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (model) async {
        await Hive.openBox(hiveApi.urlData(conversationId));
        await Hive.openBox(hiveApi.imagesMemory(conversationId));
        await Hive.openBox(hiveApi.chatRoomMedia(conversationId));
        await Hive.openBox(hiveApi.thumbnailsPath(conversationId));
        await Hive.openBox(hiveApi.videoThumbnails(conversationId));
      },
      builder: (_, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
          ),
          body: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              profileBox(context: context, model: viewModel),
              defaultOptions(context, viewModel),
              SizedBox(
                height: 60,
                child: ListTile(
                  title: Text(
                    'More Actions',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              moreActionOption(context),
              SizedBox(
                height: 60,
                child: ListTile(
                  title: Text(
                    'Privacy',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              privacyOption(context, viewModel, model)
            ],
          ),
        );
      },
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class RdioButonList extends StatefulWidget {
  const RdioButonList({Key? key}) : super(key: key);

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<RdioButonList> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: RadioListBuilder(
          num: 20,
        ),
      ),
    );
  }
}

class RadioListBuilder extends StatefulWidget {
  final int? num;

  const RadioListBuilder({Key? key, this.num}) : super(key: key);

  @override
  RadioListBuilderState createState() {
    return RadioListBuilderState();
  }
}

class RadioListBuilderState extends State<RadioListBuilder> {
  int? value;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return RadioListTile(
          value: index,
          groupValue: value,
          onChanged: (int? ind) => setState(() => value = ind),
          title: Text("Number $index"),
        );
      },
      itemCount: 5,
    );
  }
}
