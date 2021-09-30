import 'dart:async';
import 'package:hint/app/app_logger.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/app/app_colors.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/views/chat/chat_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hint/ui/views/profile_view/profile_viewmodel.dart';

class ProfileView extends StatelessWidget {
  final FireUser fireUser;
  final ChatViewModel model;
  final String conversationId;
  ProfileView(
      {Key? key,
      required this.fireUser,
      required this.model,
      required this.conversationId})
      : super(key: key);

  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController biocontroller = TextEditingController();
  final bool switchBool = false;

  Widget profileOption(
      {required String title,
      required IconData icon,
      void Function()? onTap,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            backgroundColor: dirtyWhite,
          ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                    await Hive.box(conversationId).clear();
                    await model.clearChat();
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

  Widget profileBox(
      {required BuildContext context, required ProfileViewModel model}) {
    final backGroundImage = CachedNetworkImageProvider(fireUser.photoUrl!);
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            maxRadius: 70,
            backgroundColor: activeGreen,
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
                          final maxHeight =
                              screenHeightPercentage(context, percentage: 0.5);
                          final maxWidth =
                              screenWidthPercentage(context, percentage: 0.6);
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight: maxHeight,
                                maxWidth: maxWidth,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Text(
                                      'Mute notification for this conversation',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: model.optionName.length,
                                    //physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return RadioListTile(
                                        value: index,
                                        activeColor: activeBlue,
                                        groupValue: model.value,
                                        title: Text(
                                          model.optionName[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        onChanged: (int? i) {
                                          model.currentIndex(i);
                                          getLogger('ProfileView')
                                              .wtf("value:${model.value}");
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
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

  Widget options(BuildContext context) {
    return Container(
      color: systemBackground,
      child: Column(
        children: [
          ListTile(
            onTap: () => clearChatDialog(context),
            title: Text('Clear Chat',
                style: Theme.of(context).textTheme.bodyText2),
            trailing: const Icon(CupertinoIcons.delete),
          ),
          ListTile(
            title: Text('Disappearing messages',
                style: Theme.of(context).textTheme.bodyText2),
            trailing: const Icon(CupertinoIcons.timer),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: systemBackground,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: activeBlue),
      ),
      body: ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        builder: (_, viewModel, child) {
          return ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              profileBox(context: context, model: viewModel),
              options(context),
              SizedBox(
                height: 40,
                child: ListTile(
                  title: Text(
                    'More Actions',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: black),
                  ),
                ),
              ),
              ListTile(
                title: Text('View Photos and Videos and Links',
                    style: Theme.of(context).textTheme.bodyText2!),
                trailing: const Icon(CupertinoIcons.photo),
              ),
              ListTile(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) {
                    final maxHeight =
                        screenHeightPercentage(context, percentage: 0.18);
                    final maxWidth =
                        screenWidthPercentage(context, percentage: 0.6);
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Container(
                        constraints: BoxConstraints(
                            maxHeight: maxHeight, maxWidth: maxWidth),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: Text(
                                'Groups are currently in beta version we will soon add groups and unable this feature',
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: black),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'OK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
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
                ),
                title: Text('Create Group with Vikas',
                    style: Theme.of(context).textTheme.bodyText2!),
                trailing: const Icon(CupertinoIcons.person_3),
              ),
              ListTile(
                title: Text('Share Contact',
                    style: Theme.of(context).textTheme.bodyText2!),
                trailing: const Icon(Icons.share),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  title: Text(
                    'Privacy',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: black),
                  ),
                ),
              ),
              ListTile(
                title: Text('Block',
                    style: Theme.of(context).textTheme.bodyText2!),
                trailing: const Icon(CupertinoIcons.minus_circle),
              ),
              ListTile(
                title: Text('Ignore Messages',
                    style: Theme.of(context).textTheme.bodyText2!),
                trailing: const Icon(CupertinoIcons.chat_bubble),
              ),
              Container(
                color: systemBackground,
                child: ListTile(
                  title: Text('Something\'s Wrong',
                      style: Theme.of(context).textTheme.bodyText2!),
                  subtitle: Text(
                    'Give feedback and report conversation',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
