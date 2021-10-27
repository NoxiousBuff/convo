import 'package:flutter/material.dart';
import 'package:hint/constants/app_keys.dart';
import 'package:hint/models/message_model.dart';
import 'package:hint/ui/shared/ui_helpers.dart';
import 'package:hint/constants/message_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessageContainer extends StatelessWidget {
  final String conversationId;
  const LastMessageContainer({Key? key, required this.conversationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(convoFirestorekey)
          .doc(conversationId)
          .collection(chatsFirestoreKey)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('It has Error'),
          );
        }
        final data = snapshot.data;
        if (data != null) {
          final lastDocument = data.docs.first;
          final lastMessage = Message.fromFirestore(lastDocument);
          switch (lastMessage.type) {
            case MediaType.text:
              {
                return SizedBox(
                  child: Text(
                    lastMessage.message[MessageField.messageText],
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                );
              }

            case MediaType.url:
              {
                return SizedBox(
                  width: screenWidthPercentage(context, percentage: 0.8),
                  child: Text(
                    lastMessage.message[MessageField.messageText],
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                );
              }
            case MediaType.canvasImage:
              {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.photo),
                    const SizedBox(width: 5),
                    Text(
                      'CanvasImage',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                );
              }
            case MediaType.pixaBayImage:
              {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.photo),
                    const SizedBox(width: 5),
                    Text(
                      'Image',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                );
              }
            case MediaType.image:
              {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.photo),
                    const SizedBox(width: 5),
                    Text(
                      'Image',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                );
              }
            case MediaType.video:
              {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.videocam_outlined),
                    const SizedBox(width: 5),
                    Text(
                      'Video',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                );
              }
            case MediaType.emoji:
              {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.sentiment_satisfied),
                    const SizedBox(width: 5),
                    Text(
                      'Sticker',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                );
              }
            case MediaType.meme:
              {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.gif_outlined),
                    const SizedBox(width: 5),
                    Text(
                      'Gif',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                );
              }
            default:
              {
                return const SizedBox.shrink();
              }
          }
        } else {
          return Container(
            margin: EdgeInsets.only(
                right: screenWidthPercentage(context, percentage: 0.4)),
            decoration: BoxDecoration(
              color: Colors.indigo.shade300.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(''),
          );
        }
      },
    );
  }
}
