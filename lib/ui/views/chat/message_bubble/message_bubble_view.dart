import 'package:intl/intl.dart';
import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hint/api/firestore.dart';
import 'package:hint/app/app_logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hint/ui/shared/swipe_to.dart';
import 'package:hint/services/nav_service.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/app_strings.dart';
import 'package:hint/ui/shared/alert_dialog.dart';
import 'package:hint/ui/shared/custom_snackbars.dart';
import 'package:hint/ui/views/chat/chat_media/text_media.dart';
import 'package:hint/ui/views/chat/chat_media/image_media.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hint/ui/views/chat/chat_media/document_media.dart';
import 'package:hint/ui/views/chat/replymessage/replymessage.dart';
import 'package:hint/ui/views/message_forwarder/forward_view.dart';
import 'package:hint/ui/views/chat/chat_media/videothumbnail_widget.dart';
import 'package:hint/ui/views/chat/message_bubble/messagebubble_view.dart';

/// This the widget of message bubble
/// This widget is responsible for displaying each message we sended or received
/// In any conversation
class MessageBubbleView extends StatefulWidget {
  final Message message;
  final String fireUserId;
  final bool fromReceiver;
  const MessageBubbleView(
      {Key? key,
      required this.message,
      required this.fromReceiver,
      required this.fireUserId})
      : super(key: key);

  @override
  State<MessageBubbleView> createState() => _MessageBubbleViewState();
}

class _MessageBubbleViewState extends State<MessageBubbleView> {
  @override
  Widget build(BuildContext context) {
    /// This widget display the reactions on message
    Widget displayReactions(Message message, String userUid,
        {double height = 16, double width = 16}) {
      if (message.reactions.containsKey(userUid)) {
        switch (message.reactions[userUid]) {

          /// This case return angry reaction gif
          case ReactionsField.angry:
            return Image.asset(
              'images/angry.gif',
              height: height,
              width: width,
            );

          /// This case return the haha reaction gif
          case ReactionsField.haha:
            return Image.asset(
              'images/haha.gif',
              height: height,
              width: width,
            );

          /// This case display the wow reaction gif
          case ReactionsField.wow:
            return Image.asset(
              'images/wow.gif',
              height: height,
              width: width,
            );

          /// This case display the like reaction gif
          case ReactionsField.like:
            return Image.asset(
              'images/like.gif',
              height: height,
              width: width,
            );

          /// This case display the sad rection gif
          case ReactionsField.sad:
            return Image.asset(
              'images/sad.gif',
              height: height,
              width: width,
            );

          /// This case display the love rection gif
          case ReactionsField.love:
            return Image.asset(
              'images/love.gif',
              height: height,
              width: width,
            );

          /// This is the default case
          default:
            return shrinkBox;
        }
      } else {
        return shrinkBox;
      }
    }

    /// show the time when message delivered
    Widget deliveredText(Message message) {
      final date = message.timestamp.toDate();
      final time = DateFormat('hh:mm a').format(date);

      /// The current user unique Id which helps to identify the user by its id
      String currentUserUid = FirestoreApi().currentUserId;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(time, style: const TextStyle(fontSize: 10)),
          ),
          displayReactions(message, widget.fireUserId),
          displayReactions(message, currentUserUid),
          message.isRead && message.senderUid == currentUserUid
              ? const Text('✔️', style: TextStyle(fontSize: 10))
              : shrinkBox,
          horizontalSpaceTiny,
        ],
      );
    }

    /// message bubble decide check the type of message
    Widget messageBubble() {
      switch (widget.message.type) {
        case MediaType.text:

          /// This widget is responsible for displaing text message
          return TextMedia(
              fromReceiver: widget.fromReceiver, message: widget.message);

        case MediaType.image:

          /// This widget is responsible for displaing image message
          return ImageMedia(message: widget.message);
        case MediaType.video:

          /// This widget is responsible for displaing video message
          return VideoThumbnailWidget(message: widget.message);
        case MediaType.document:

          /// This widget is responsible for displaing documents
          return DocumentMedia(
              message: widget.message, fromReceiver: widget.fromReceiver);

        default:

          /// This is an empty box with zero size
          return shrinkBox;
      }
    }

    /// Reaction widget (reaction gifs)
    Widget reaction(
      String name, {
      void Function()? onTap,
    }) {
      return Flexible(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              name,
              height: 50,
              width: 50,
            ),
          ),
        ),
      );
    }

    /// This is the message option widget whcih display the option
    Widget msgOptionsWidget(
        {required String text,
        required IconData icon,
        void Function()? onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon),
              horizontalSpaceRegular,
              Text(
                text,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      );
    }

    /// Message options
    /// These options will appear in a modal bottom sheet
    ///  when we long press on the message
    /// These are the options a specific message
    /// which will change on the basis of the senderUid
    messageOptions(BuildContext context, MessageBubbleViewModel model) {
      bool isTypeText = widget.message.type == MediaType.text;
      return showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
            maxHeight: screenHeightPercentage(context, percentage: 0.5)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32),
            topLeft: Radius.circular(32),
          ),
        ),
        builder: (context) {
          return Column(
            children: [
              verticalSpaceRegular,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    /// This display angry reaction gif
                    reaction(
                      'images/angry.gif',
                      onTap: () => model.reactOnTheMessage(
                        context,
                        message: widget.message,
                        fireUserID: widget.fireUserId,
                        reactionValue: ReactionsField.angry,
                      ),
                    ),

                    /// This display haha reaction gif
                    reaction(
                      'images/haha.gif',
                      onTap: () => model.reactOnTheMessage(
                        context,
                        message: widget.message,
                        fireUserID: widget.fireUserId,
                        reactionValue: ReactionsField.haha,
                      ),
                    ),

                    /// This display like reaction gif
                    reaction(
                      'images/like.gif',
                      onTap: () => model.reactOnTheMessage(
                        context,
                        message: widget.message,
                        fireUserID: widget.fireUserId,
                        reactionValue: ReactionsField.like,
                      ),
                    ),

                    /// This display love reaction gif
                    reaction(
                      'images/love.gif',
                      onTap: () => model.reactOnTheMessage(
                        context,
                        message: widget.message,
                        fireUserID: widget.fireUserId,
                        reactionValue: ReactionsField.love,
                      ),
                    ),

                    /// This display sad reaction gif
                    reaction(
                      'images/sad.gif',
                      onTap: () => model.reactOnTheMessage(
                        context,
                        message: widget.message,
                        fireUserID: widget.fireUserId,
                        reactionValue: ReactionsField.sad,
                      ),
                    ),

                    /// This display wow reaction gif
                    reaction(
                      'images/wow.gif',
                      onTap: () => model.reactOnTheMessage(
                        context,
                        message: widget.message,
                        fireUserID: widget.fireUserId,
                        reactionValue: ReactionsField.wow,
                      ),
                    ),
                  ],
                ),
              ),

              /// This is an message option
              /// This will aapears after long press on a message
              /// This widget is for replying back to specific message
              msgOptionsWidget(
                icon: Icons.reply_outlined,
                text: 'Reply',
                onTap: () => model.getSwipedMessageValues(widget.message),
              ),

              /// This is an message option
              /// This will aapears after long press on a message
              /// This widget is for forward a message
              msgOptionsWidget(
                  icon: Icons.forward_outlined,
                  text: 'Forward',
                  onTap: () => navService.materialPageRoute(
                      context, ForwardView(message: widget.message))),

              /// This is an message option
              /// This will aapears after long press on a message
              /// If message type is text then copy text will appear and type is
              /// image, video or document then Share option will appear
              /// This widget is for Copying text if type text
              /// and for share media for any type except text
              msgOptionsWidget(
                  icon: isTypeText ? Icons.copy : Icons.share_outlined,
                  text: isTypeText ? 'Copy Text' : 'Share',
                  onTap: () {
                    if (isTypeText) {
                      Clipboard.setData(ClipboardData(
                          text: widget
                              .message.message[MessageField.messageText]));
                      customSnackbars.infoSnackbar(context,
                          title: 'Your text was copied');
                    } else {
                      final filePath = hiveApi.getFromHive(
                          HiveApi.mediaHiveBox, widget.message.messageUid);
                      Share.shareFiles([filePath])
                          .onError(
                            (error, stackTrace) => DuleAlertDialog(
                              title: 'Missing Media',
                              icon: FeatherIcons.alertCircle,
                              description:
                                  'This file is missing, you can\'t send it.',
                              primaryButtonText: 'OK',
                              primaryOnPressed: () => Navigator.pop(context),
                            ),
                          )
                          .catchError((error) => getLogger('MessageBubbleView')
                              .e('Sharing File Error :$error'));
                    }
                    Navigator.pop(context);
                  }),

              /// This is an message option
              /// This will aapears after long press on a message
              /// This widget is for delete a specific message
              msgOptionsWidget(
                icon: Icons.delete_outline,
                text: 'Delete',
                onTap: () => model.deleteMessage(
                  context,
                  fireUserID: widget.fireUserId,
                  messageUid: widget.message.messageUid,
                ),
              ),

              /// This is an message option
              /// This will aapears after long press on a message
              /// This widget is for reporting to a message
              /// if message contains any illegal OR adult content
              /// OR volitile Convo privacy policy
              msgOptionsWidget(icon: Icons.report_outlined, text: 'Report'),
            ],
          );
        },
      );
    }

    return ViewModelBuilder<MessageBubbleViewModel>.reactive(
      viewModelBuilder: () => MessageBubbleViewModel(),
      builder: (context, model, child) {
        return GestureDetector(
          onDoubleTap: () =>
              model.removeReaction(widget.message, widget.fireUserId),
          onLongPress: () => messageOptions(context, model),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                minWidth: MediaQuery.of(context).size.width * 0.1),

            /// This give the ability to swipe the message for reply
            child: SwipeTo(
              onRightSwipe: () => model.getSwipedMessageValues(widget.message),
              child: Column(
                mainAxisAlignment: widget.fromReceiver
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                crossAxisAlignment: widget.fromReceiver
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  /// This is the reply message
                  /// This will only appear when user reply to a specific message
                  widget.message.isReply
                      ? ReplyMessage(
                          replyMessage: widget.message.replyMessage,
                          senderUid: widget.message.senderUid)
                      : shrinkBox,
                  messageBubble(),

                  /// This widget display the delivered time of any message
                  deliveredText(widget.message),
                  verticalSpaceSmall,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
