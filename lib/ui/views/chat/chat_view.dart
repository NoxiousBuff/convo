import 'package:hint/ui/views/chat/chat_media/text_media.dart';

import 'chat_viewmodel.dart';
import 'widgets/chat_options.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:hint/app/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/models/user_model.dart';
import 'package:hint/models/dule_model.dart';
import 'package:ezanimation/ezanimation.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/empty_state.dart';
import 'package:hint/api/replymessage_value.dart';
import 'package:extended_image/extended_image.dart';
import 'package:gmo_media_picker/media_picker.dart';
import 'package:hint/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/shared/user_profile_photo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hint/extensions/custom_color_scheme.dart';
import 'package:hint/ui/views/chat/widgets/chat_textfield.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/chat/widgets/replymessage_tile.dart';
import 'package:hint/ui/views/write_letter/write_letter_view.dart';
import 'package:hint/ui/views/chat/widgets/chat_animation_options.dart';
import 'package:hint/ui/views/chat/message_bubble/message_bubble_view.dart';
import 'package:hint/ui/views/settings/user_account/user_account_view.dart';

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

class _ChatViewState extends State<ChatView> with TickerProviderStateMixin {
  /// Duration of each animation in chat room
  static const duration = Duration(seconds: 4);

  /// calling database API calss
  final databaseService = DatabaseService();

  /// calling the replyMessage locator
  final replyMsgLocator = locator.get<GetReplyMessageValue>();

  /// animation controllers
  late AnimationController fuckCntlr;
  late AnimationController heartCntlr;
  late AnimationController dollarCntlr;
  late AnimationController balloonCntlr;
  late AnimationController confettiCntlr;

  final ezAnimation = EzAnimation(0.0, 200.0, const Duration(seconds: 4));

  Animation<double> balloonSize(AnimationController balloonCntlr) {
    Animation<double> _balloonSize = Tween<double>(begin: 0, end: 500)
        .animate(CurvedAnimation(parent: balloonCntlr, curve: Curves.linear));
    return _balloonSize;
  }

  Animation<Offset> balloonPosition(AnimationController balloonCntlr) {
    final _position = Tween<Offset>(
            begin: const Offset(0, 0), end: const Offset(1, 1))
        .animate(CurvedAnimation(parent: balloonCntlr, curve: Curves.linear));
    return _position;
  }

  @override
  void initState() {
    databaseService.updateUserDataWithKey(DatabaseMessageField.msgTxt, '');

    databaseService.updateUserDataWithKey(
        DatabaseMessageField.roomUid, widget.conversationId);

    /// initialise the heart controller
    heartCntlr = AnimationController(vsync: this, duration: duration);

    /// initialise the balloon controller
    balloonCntlr = AnimationController(vsync: this, duration: duration);

    /// initialise the fuck controller
    fuckCntlr = AnimationController(vsync: this, duration: duration);

    /// initialise the confetti controller
    confettiCntlr = AnimationController(vsync: this, duration: duration);

    /// initialise the dollar controller
    dollarCntlr = AnimationController(vsync: this, duration: duration);

    fuckCntlr.addListener(() => setState(() {}));
    heartCntlr.addListener(() => setState(() {}));
    dollarCntlr.addListener(() => setState(() {}));
    balloonCntlr.addListener(() => setState(() {}));
    confettiCntlr.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    fuckCntlr.removeListener(() {});
    heartCntlr.removeListener(() {});
    dollarCntlr.removeListener(() {});
    balloonCntlr.removeListener(() {});
    confettiCntlr.removeListener(() {});

    fuckCntlr.dispose();
    heartCntlr.dispose();
    dollarCntlr.dispose();
    balloonCntlr.dispose();
    confettiCntlr.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.reactive(
      viewModelBuilder: () => ChatViewModel(
          fireUser: widget.fireUser, conversationId: widget.conversationId),
      builder: (context, model, child) {
        return StreamBuilder<DatabaseEvent>(
          stream: model.realtimeDBDocument,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('There is something wrong');
            }

            if (!snapshot.hasData) const CupertinoActivityIndicator();
            final data = snapshot.data;
            if (data != null) {
              final receiverData = data.snapshot.value;
              final receiverUser = DuleModel.fromJson(receiverData);
              switch (receiverUser.aniType) {
                case AnimationType.confetti:
                  {
                    confettiCntlr.forward();
                  }
                  break;
                case AnimationType.balloons:
                  {
                    balloonCntlr.forward();
                  }
                  break;
                case AnimationType.hearts:
                  {
                    heartCntlr.forward();
                  }
                  break;

                case AnimationType.dollar:
                  {
                    dollarCntlr.forward();
                  }
                  break;
                case AnimationType.fuckOff:
                  {
                    fuckCntlr.forward();
                  }
                  break;

                default:
                  {}
              }
            }

            return Stack(
              alignment: Alignment.center,
              children: [
                Scaffold(
                  appBar: AppBar(
                    leading: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(FeatherIcons.arrowLeft,
                          color: Theme.of(context).colorScheme.mediumBlack),
                    ),
                    titleSpacing: 0.0,
                    elevation: 0.0,
                    backgroundColor: Theme.of(context).colorScheme.lightGrey,

                    /// This will display the username unique name of each user
                    title: InkWell(
                      onTap: () => navService.materialPageRoute(
                          context, const UserAccountView()),
                      child: Row(
                        children: [
                          /// This display the profile photo of user
                          UserProfilePhoto(
                            widget.fireUser.photoUrl,
                            height: 36,
                            width: 36,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          horizontalSpaceSmall,

                          /// This will display the current Display name of a user
                          Text(
                            widget.fireUser.displayName,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.black),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      /// A model bottom sheet appear after pressing this icon
                      /// which contain some options regarding the chat room
                      /// like clear the chat and report the chat and more
                      IconButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              children: const [
                                verticalSpaceRegular,

                                /// This will clear all the conversation in a chat room
                                ChatOptions(
                                    icon: FeatherIcons.delete, label: 'Delete'),

                                /// This will report to convo about a user
                                ChatOptions(
                                    icon: Icons.report, label: 'Report'),
                                verticalSpaceRegular,
                              ],
                            );
                          },
                        ),
                        icon: Icon(
                          FeatherIcons.info,
                          color: Theme.of(context).colorScheme.mediumBlack,
                        ),
                      ),
                    ],
                  ),
                  body: Column(
                    children: [
                      /// This is the list of chat messages which user send or recived
                      chatList(context, model),

                      /// This is textfield of the chat screen
                      /// With the help of this textfield user send text message
                      textField(context, model),

                      /// These are the bottom options for any chatroom  like pick images , videos and docs play animation and many nore
                      _buildBottomOptions(context, model),

                      /// This bottom padding to keep textfield above from the hardware keybottons in the android device
                      bottomPadding(context),
                    ],
                  ),
                ),
                heartCntlr.isAnimating
                    ? LottieBuilder.asset('json/heart.json',
                        controller: heartCntlr)
                    : shrinkBox,
                fuckCntlr.isAnimating
                    ? LottieBuilder.asset('json/fuck_off.json',
                        controller: fuckCntlr)
                    : shrinkBox,
                confettiCntlr.isAnimating
                    ? LottieBuilder.asset(
                        'json/confetti.json',
                        fit: BoxFit.cover,
                        controller: confettiCntlr,
                        height: screenHeight(context),
                      )
                    : shrinkBox,
                dollarCntlr.isAnimating
                    ? LottieBuilder.asset('json/dollar_rain.json',
                        controller: dollarCntlr)
                    : shrinkBox,
                balloonCntlr.isAnimating
                    ? LottieBuilder.asset('json/balloons.json',
                        controller: balloonCntlr)
                    : shrinkBox,
              ],
            );
          },
        );
      },
    );
  }

  /// These options are for messaging like send media
  /// run effects send hand drawing art and ohter stuff like that
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
          /// This will show the options for playing animation like
          /// confetti balloons and other
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

                    /// This will play confetti animation
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Chip(label: Text('Confetti'))),
                    horizontalSpaceRegular,

                    /// This will play hearts animation
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Chip(label: Text('Hearts'))),
                    horizontalSpaceRegular,

                    /// This will play balloons animation
                    InkWell(
                      onTap: () => Navigator.pop(context),
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

        /// Click and send image from your device camera
        IconButton(
          onPressed: () {},
          icon: const Icon(FeatherIcons.camera),
          color: Theme.of(context).colorScheme.darkGrey,
          iconSize: 32,
        ),

        /// This Icon is used for pickin media like images and videos and send it
        IconButton(
          onPressed: () => GmoMediaPicker.picker(
            context,
            isMulti: true,
            mulCallback: (List<AssetEntity> assets) async {
              /// Pick the media from device
              /// like images and videos
              if (await model.pickedMediaLength(assets) < 8) {
                /// This will upload all media in firebase storage
                /// and added the information into firestore
                await Future.wait(
                    assets.map((asset) => model.uploadAndAddToDatabase(asset)));
              } else {
                /// This snackbar will appear if the of selected files are greater than 8 MB
                /// because maximum uploading file size is 8 MB
                /// and this will one file or more than one but max Size is 8 MB
                customSnackbars.infoSnackbar(context,
                    title: 'Maximum size must be less than 8 MB');
              }
            },
          ),
          icon: const Icon(FeatherIcons.image),
          color: Theme.of(context).colorScheme.darkGrey,
          iconSize: 32,
        ),

        /// This icon will display the picking the docs from device
        /// User can send any documents to another user
        IconButton(
          iconSize: 32,
          icon: const Icon(FeatherIcons.folder),
          color: Theme.of(context).colorScheme.darkGrey,
          onPressed: () async {
            /// This will pick all document from the device
            /// user can pick any document like
            /// pdf, png, mp4 etc.
            final result = await model.documentsPicker(context);
            if (result != null) {
              /// This will convert the picked documents list into a
              /// list of file
              final files = result.files
                  .map((platformFile) => File(platformFile.path!))
                  .toList();
              if (await model.pickedDocumentsLength(files) < 8) {
                /// This will upload all documents in firebase storage
                /// and added the information into firestore
                Future.wait(result.files.map((file) => model.uploadDocs(file)));
              } else {
                /// This snackbar will appear if the of selected documents are greater than 8 MB
                /// because maximum uploading documents size is 8 MB
                /// and this will one document or more than one but max Size is 8 MB
                customSnackbars.infoSnackbar(context,
                    title: 'Maximum size must be less than 8 MB');
              }
            }
          },
        ),
        IconButton(
          onPressed: () => navService.materialPageRoute(
              context, WriteLetterView(fireUser: widget.fireUser)),
          icon: const Icon(FeatherIcons.send),
          color: Theme.of(context).colorScheme.darkGrey,
          iconSize: 32,
        ),

        /// display the screen animations option
        /// for playing for e.g confetti, balloons, heart, coins etc
        IconButton(
          onPressed: () => showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (_) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: screenHeightPercentage(context, percentage: 0.1),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    horizontalSpaceSmall,
                    AnimationOptionChip(
                        label: 'Confetti',
                        onTap: () {
                          model.updateAnimation(
                              context: context,
                              controller: confettiCntlr,
                              animationType: AnimationType.confetti);
                        }),
                    horizontalSpaceSmall,
                    AnimationOptionChip(
                        label: 'Balloons',
                        onTap: () {
                          model.updateAnimation(
                              context: context,
                              controller: balloonCntlr,
                              animationType: AnimationType.balloons);
                        }),
                    horizontalSpaceSmall,
                    AnimationOptionChip(
                      label: 'Hearts',
                      onTap: () {
                        model.updateAnimation(
                            context: context,
                            controller: heartCntlr,
                            animationType: AnimationType.hearts);
                      },
                    ),
                    horizontalSpaceSmall,
                    AnimationOptionChip(
                        label: 'Fuck Off',
                        onTap: () {
                          model.updateAnimation(
                              context: context,
                              controller: fuckCntlr,
                              animationType: AnimationType.fuckOff);
                        }),
                    horizontalSpaceSmall,
                    AnimationOptionChip(
                        label: 'Dollars',
                        onTap: () {
                          model.updateAnimation(
                              context: context,
                              controller: dollarCntlr,
                              animationType: AnimationType.dollar);
                        }),
                    horizontalSpaceSmall,
                  ],
                ),
              );
            },
          ),
          icon: const Icon(FeatherIcons.edit2),
          color: Theme.of(context).colorScheme.darkGrey,
          iconSize: 32,
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            model.addMessage();
            model.messageTech.clear();
            model.updateUserDataWithKey(DatabaseMessageField.msgTxt, '');
          },
          icon: const Icon((FeatherIcons.refreshCcw)),
          color: Theme.of(context).colorScheme.red,
          iconSize: 32,
        ),
        horizontalSpaceTiny,
      ],
    );
  }

  /// This is the message bubble of those message
  /// which was received by current user OR will receive
  /// These message are appears on the left side of the screen
  /// With different color compare with sended message
  /// These message are received by current user
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
              const padding =
                  EdgeInsets.symmetric(horizontal: 14, vertical: 10);
              final DuleModel duleModel = DuleModel.fromJson(json);
              var maxWidth = screenWidthPercentage(context, percentage: 0.8);
              return duleModel.msgTxt.isEmpty
                  ? shrinkBox
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              padding: padding,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: Text(
                                duleModel.msgTxt,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     duleModel.msgTxt.isEmpty
              //         ? shrinkBox
              //         : Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Container(
              //               alignment: Alignment.center,
              //               padding: const EdgeInsets.symmetric(
              //                   horizontal: 16, vertical: 12),
              //               decoration: BoxDecoration(
              //                   color:
              //                       Theme.of(context).colorScheme.yellowAccent,
              //                   borderRadius: BorderRadius.circular(20)),
              //               child: Text(
              //                 duleModel.msgTxt,
              //                 style: TextStyle(
              //                   color: Theme.of(context).colorScheme.black,
              //                   fontSize: 18,
              //                 ),
              //               ),
              //             ),
              //           ),
              //     SizedBox(
              //       width: screenWidthPercentage(context, percentage: 0.1),
              //     ),
              //   ],
              // );
            } else {
              return shrinkBox;
            }
          }
        },
      ),
    );
  }

  /// This will appears when user send any media
  /// This shows the uploading progress of files which user uploading into database
  /// This is a stream so, all progress will display in realtime OR live
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

  /// This is the list of all messages in a conversation of two user
  ///  OR in a chat room
  Widget chatList(BuildContext context, ChatViewModel model) {
    bool sendedByMe =
        replyMsgLocator.senderUid == FirestoreApi().getCurrentUser!.uid;
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
              SliverToBoxAdapter(
                /// This tile will appear above on the textfield when isReply is true
                child: ReplyMessageTile(
                  sendedByMe: sendedByMe,
                  fireUserName: widget.fireUser.username,
                ),
              ),
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
                            child: MessageBubbleView(
                                message: message,
                                fromReceiver: fromReceiver,
                                fireUserId: widget.fireUser.id),
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

  Widget textField(BuildContext context, ChatViewModel model) {
    return ChatTextField(
      child: CupertinoTextField.borderless(
        controller: model.messageTech,
        style: TextStyle(
          color: Theme.of(context).colorScheme.black,
          fontSize: 18,
        ),
        placeholder: 'Messages sent as you type',
        textInputAction: TextInputAction.newline,
        minLines: 1,
        maxLines: 6,
        maxLength: 160,
        onChanged: (value) {
          model.updateMessageText(value);
          model.updateUserDataWithKey(DatabaseMessageField.msgTxt, value);
        },
      ),
    );
  }

  /// creating an ios style textfield for typing messages
  Widget chatTextField(BuildContext context, ChatViewModel model) {
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
                      onTap: () => model.addMessage(),
                    ),
                    suffixMode: OverlayVisibilityMode.editing,
                    controller: model.messageTech,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.black,
                      fontSize: 18,
                    ),
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
