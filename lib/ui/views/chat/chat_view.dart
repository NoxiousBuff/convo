import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/models/dule_model.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/empty_state.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/ui/shared/user_profile_photo.dart';
import 'package:hint/ui/views/chat/message_bubble/message_bubble_view.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';
import 'package:stacked/stacked.dart';
import 'package:gmo_media_picker/media_picker.dart';
import 'chat_viewmodel.dart';

// FlutterUploader _uploader = FlutterUploader();

// void backgroundHandler() {
//   // Needed so that plugin communication works.
//   WidgetsFlutterBinding.ensureInitialized();

//   // This uploader instance works within the isolate only.
//   FlutterUploader uploader = FlutterUploader();

//   // You have now access to:
//   uploader.progress.listen((progress) {
//     // upload progress
//   });
//   uploader.result.listen((result) {
//     // upload results
//   });
// }

class ChatView extends StatefulWidget {
  const ChatView(
      {Key? key, required this.fireUser, required this.conversationId})
      : super(key: key);

  static const String id = '/ChatView';

  final FireUser fireUser;
  final String conversationId;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.reactive(
      viewModelBuilder: () => ChatViewModel(
          fireUser: widget.fireUser, conversationId: widget.conversationId),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(FeatherIcons.arrowLeft,
                  color: Theme.of(context).colorScheme.mediumBlack),
            ),
            titleSpacing: 0.0,
            elevation: 0.0,
            backgroundColor: Theme.of(context).colorScheme.lightGrey,
            title: Row(
              children: [
                UserProfilePhoto(
                  widget.fireUser.photoUrl,
                  height: 36,
                  width: 36,
                  borderRadius: BorderRadius.circular(15),
                ),
                horizontalSpaceSmall,
                Text(
                  widget.fireUser.displayName,
                  style: TextStyle(color: Theme.of(context).colorScheme.black),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                chatList(context, model),
                chatTextField(context, model),
                _buildBottomOptions(context, model),
                bottomPadding(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomOptions(BuildContext context, ChatViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        horizontalSpaceRegular,
        IconButton(
          onPressed: () {},
          icon: const Icon(FeatherIcons.edit3),
          color: Theme.of(context).colorScheme.darkGrey,
          iconSize: 32,
        ),
        IconButton(
          onPressed: () => showModalBottomSheet(
            elevation: 0,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return SizedBox(
                height: 100,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    horizontalSpaceRegular,
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Chip(label: Text('Confetti'))),
                    horizontalSpaceRegular,
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Chip(label: Text('Hearts'))),
                    horizontalSpaceRegular,
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Chip(
                        label: Text('Balloons'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          icon: const Icon(FeatherIcons.loader),
          color: Theme.of(context).colorScheme.darkGrey,
          iconSize: 32,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(FeatherIcons.camera),
          color: Theme.of(context).colorScheme.darkGrey,
          iconSize: 32,
        ),
        IconButton(
          onPressed: () => GmoMediaPicker.picker(
            context,
            isMulti: true,
            mulCallback: (List<AssetEntity> assets) async {
              if (await model.pickedMediaLength(assets) < 8) {
                await Future.wait(
                    assets.map((asset) => model.uploadAndAddToDatabase(asset)));
              } else {
                customSnackbars.infoSnackbar(context, title: 'Maximum size must be less than 8 MB');
              }

              //final mediaList = model.selectedMediaList;
              // await Future.wait(
              //   mediaList.map(
              //     (media) {
              //       return model
              //           .addMediaMessage(media['MediaType'], media['URL'])
              //           .then((value) =>
              //               model.log.wtf('successfully added to firestore'));
              //     },
              //   ),
              // );
            },
          ),
          icon: const Icon(FeatherIcons.image),
          color: Theme.of(context).colorScheme.darkGrey,
          iconSize: 32,
        ),
        IconButton(
          onPressed: () => navService.materialPageRoute(
              context, WriteLetterView(fireUser: widget.fireUser)),
          icon: const Icon(FeatherIcons.send),
          color: Theme.of(context).colorScheme.darkGrey,
          iconSize: 32,
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon((FeatherIcons.refreshCcw)),
          color: Theme.of(context).colorScheme.red,
          iconSize: 32,
        ),
        horizontalSpaceTiny,
      ],
    );
  }

  recieverMsgBubble(BuildContext contex, ChatViewModel model) {
    return SliverToBoxAdapter(
      child: StreamBuilder<DatabaseEvent>(
        stream: model.realtimeDBDocument,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return shrinkBox;
          }
          if (!snapshot.hasData) {
            return shrinkBox;
          } else {
            final data = snapshot.data;

            if (data != null) {
              final json = data.snapshot.value;
              final DuleModel duleModel = DuleModel.fromJson(json);
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  duleModel.msgTxt.isEmpty
                      ? shrinkBox
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.yellowAccent,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              duleModel.msgTxt,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: screenWidthPercentage(context, percentage: 0.1),
                  ),
                ],
              );
            } else {
              return shrinkBox;
            }
          }
        },
      ),
    );
  }

  Widget uploadingFileIndicator(BuildContext context, ChatViewModel model) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: screenWidthPercentage(context, percentage: 0.6),
            color: Theme.of(context).colorScheme.darkGrey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.fileTitle,
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).colorScheme.black),
                ),
                LinearProgressIndicator(
                  value: model.fileProgress,
                  valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).colorScheme.blue),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  chatList(BuildContext context, ChatViewModel model) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: model.getUserchat,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('There is some error. Please try again later.'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          final messages = snapshot.data!.docs;
          return CustomScrollView(
            scrollBehavior: const CupertinoScrollBehavior(),
            reverse: true,
            slivers: [
              // SliverToBoxAdapter(child: uploadingFileIndicator(context, model)),
              recieverMsgBubble(context, model),
              messages.isEmpty
                  ? model.messageText.isNotEmpty
                      ? const SliverToBoxAdapter(child: shrinkBox)
                      : SliverToBoxAdapter(
                          child: emptyState(
                            context,
                            heading: 'No messages here',
                            emoji: '🙌',
                            description: 'Break the norm and\nstart the convo',
                          ),
                        )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final message =
                              Message.fromFirestore(messages[index]);
                          bool fromReceiver =
                              message.senderUid == widget.fireUser.id;
                          return Align(
                            alignment: fromReceiver
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: MessageBubble(
                                message: message, fromReceiver: fromReceiver),
                          );
                        },
                        childCount: messages.length,
                      ),
                    ),
              sliverVerticalSpaceLarge,
            ],
          );
        },
      ),
    );
  }

  chatTextField(BuildContext context, ChatViewModel model) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth:
                          screenWidthPercentage(context, percentage: 0.85),
                      minWidth:
                          screenWidthPercentage(context, percentage: 0.01)),
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  decoration: BoxDecoration(
                      color: model.messageText.isNotEmpty
                          ? Theme.of(context).colorScheme.blue
                          : Theme.of(context).colorScheme.lightGrey,
                      borderRadius: BorderRadius.circular(32)),
                  child: CupertinoTextField.borderless(
                    suffix: GestureDetector(
                      child: const Icon(FeatherIcons.send),
                      onTap: () {
                        model.addMessage();
                      },
                    ),
                    suffixMode: OverlayVisibilityMode.editing,
                    controller: model.messageTech,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.black,
                        fontSize: 18),
                    placeholder: 'Messages sent as you type',
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 6,
                    onChanged: (value) {
                      model.updateMessageText(value);
                      model.updateUserDataWithKey(
                          DatabaseMessageField.msgTxt, value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
